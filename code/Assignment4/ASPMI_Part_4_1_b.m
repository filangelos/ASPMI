%% init script
close all;
clear;
% environment settings
startup;

%% CLMS vs ACLMS

% number of samples
N = 5000;

% fetch data
wind = complex(zeros(3, N));
load('data/wind-dataset/low-wind.mat');
wind(1, :) = complex(v_east, v_north);
load('data/wind-dataset/medium-wind.mat');
wind(2, :) = complex(v_east, v_north);
load('data/wind-dataset/high-wind.mat');
wind(3, :) = complex(v_east, v_north);

labels = {'Low', 'Medium', 'High'};

% circularity plots
for i = 1:size(wind, 1)
    
    % circularity coefficient
    rho = circularity((wind(i, :)));

    % figure - circularity
    fig = figure("Name", sprintf("Circularity Plot %d", i));
    scatter(real(wind(i, :)), imag(wind(i, :)), 30, COLORS(i, :), "filled")
    title(sprintf("\\textbf{%s Regime}: Circularity Check, $\\mathbf{\\rho=%.3f}$", labels{i}, rho));
    xlabel("$u_{east}$");
    xlabel("$u_{north}$");
    grid on; grid minor;
    saveas(fig, sprintf("Assignment4/assets/4.1/b/circularity_%d.eps", i), "epsc");

end

% leakage parameter
gamma = 0;
% step-size
mu = [0.1 0.005 0.001];
% model orders
M = 1:30;

% algorithms
algo = {'CLMS', 'ACLMS'};

% error
error = zeros(N, size(wind, 1), length(M), length(algo));

% (A)CLMS filters
for i = 1:size(wind, 1)

    for j = 1:length(M)
    
        % data preprocessing
        [X, d] = XyDelta(wind(i, :), 1, M(j));
        
        % CLMS
        [~, error(:, i, j, 1), ~] = CLMS(X, d, mu(i), gamma);
        % ACLMS
        [~, error(:, i, j, 2), ~] = ACLMS(X, d, mu(i));
    
    end
    
    % figure - learning curves
    fig = figure("Name", sprintf("Learning Curves %d", i));
    MPSE_CLMS = reshape(pow2db(mean(abs(error(:, i, :, 1)).^2, 1)), length(M), 1, 1);
    plot(M, MPSE_CLMS, "DisplayName", "CLMS");
    hold on
    MPSE_ACLMS = reshape(pow2db(mean(abs(error(:, i, :, 2)).^2, 1)), length(M), 1, 1);
    plot(M, MPSE_ACLMS, "DisplayName", "ACLMS");
    title(sprintf("\\textbf{%s Regime}: Learning Curves for \\textbf{CLMS} and \\textbf{ACLMS}", labels{i}));
    xlabel("Model Order, $M$");
    ylabel("Squared Error (dB)");
    grid on; grid minor;
    legend("show")
    saveas(fig, sprintf("Assignment4/assets/4.1/b/learning_curves_%d.eps", i), "epsc");

end