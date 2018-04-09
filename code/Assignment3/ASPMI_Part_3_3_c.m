%% init script
close all;
clear;
% environment settings
startup;

%% LMS ALE vs ANC

% algorithms
algo = {'ALE', 'ANC'};

% ALE: delay
Delta = 3;
% ALE: model order
M_ALE = 6;
% ALE: step-size
mu_ALE = 0.005;
% ANC: model order
M_ANC = 6;
% ANC: step-size
mu_ANC = 0.005;

% number of samples
N = 1000;
% realisations
R = 100;
% steady-state: offset
t0 = 50;

% sinewave params
A = 1;
t = 1:N;
f0 = 0.005;
% sinewave
x = A * sin(2*pi*f0*t);

% noise params
sigma_2 = 1;
b = [1 0 0.5];
a = 1;

% signals
s = zeros(N, R);

% predictions
x_hat = zeros(N, R, 2);
% MSE
mse = zeros(R, length(algo));
% MPSE
mpse = zeros(length(algo), 1);

for j = 1:R
    
    % gaussian white noise
    u = random('Normal', 0, sigma_2, N, 1);
    % colored noise
    eta = filter(b, a, u)';
    % correlated noise
    epsilon = eta * 0.9 + 0.05;
    % signal
    s(:, j) = x + eta;
        
    % ALE - data preprocessing
    [X_ALE, d_ALE] = XyDelta(s(:, j), Delta, M_ALE);
    % ALE - LMS
    x_hat(:, j, 1) = LMS(X_ALE, d_ALE, mu_ALE, 0);
    
    % ALE - MSE
    mse(j, 1) = mean((x(t0:end)' - x_hat(t0:end, j, 1)).^2);
    
    % ANC - data preprocessing
    [X_ANC, ~] = XyDelta(epsilon, 1, M_ANC);
    d_ANC = [0 s(1:end-1, j)'];
    
    % ANC - LMS
    eta_hat = LMS(X_ANC, d_ANC, mu_ANC, 0);
        
    x_hat(:, j, 2) = d_ANC - eta_hat;
    % ANC - MSE
    mse(j, 2) = mean((x' - x_hat(:, j, 2)).^2);
    
end

% MPSE
mpse(:) = mean(mse, 1);

for i = 1:length(algo)
    % figure - overlay
    fig = figure("Name", sprintf("Overlay"));
    plts = [];
    % plot overlays
    for j = 1:R
        % noisy signal, s(n)
        plts(1) = plot(t, s(:, j), "Color", COLORS(1, :), "DisplayName", "$s(n)$");
        hold on;
    end
    for j = 1:R
        % filter output, x_hat(n)
        plts(2) = plot(t, x_hat(:, j, i), "Color", COLORS(2, :), "DisplayName", "$\hat{x}(n)$");
        hold on;
    end
    % clean signal
    plts(3) = plot(t, x, "Color", COLORS(3, :), "DisplayName", "$x(n)$");
    title(sprintf("\\textbf{%s}: %d Realisations Overlay, $\\mathbf{MPSE=%.4f}$", algo{i}, R, mpse(i)));
    xlabel("Time Index, $t$");
    ylabel("");
    lgd = legend(plts);
    lgd.NumColumns = length(plts);
    grid on; grid minor;
    saveas(fig, sprintf("Assignment3/assets/3.3/c/%s_overlay.eps", algo{i}), "epsc");
    ylim([-5 5]);
end

% figure - overlay
fig = figure("Name", sprintf("Mean"));
plot(mean( x_hat(:, :, 1), 2 ), "DisplayName", algo{1})
hold on
plot(mean( x_hat(:, :, 2), 2 ), "DisplayName", algo{2})
hold on
plot(x, "DisplayName", "$x(n)$")
title(sprintf("\\textbf{ALE vs ANC}: Ensemble Means"));
xlabel("Time Index, $t$");
ylabel("");
legend("show");
grid on; grid minor;
saveas(fig, sprintf("Assignment3/assets/3.3/c/comparison.eps"), "epsc");