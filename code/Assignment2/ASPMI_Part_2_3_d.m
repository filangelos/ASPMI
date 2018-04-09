%% init script
close all;
clear;
% environment settings
startup;

addpath('data/PCR/');

%% PCR vs OLS: regval

% fetch data
pcr = load('data/PCR/PCAPCR.mat');

% number of iterations
iter = 100;

% -- OLS --
% weigts
B_OLS = pcr.Xnoise' * pcr.Xnoise \ pcr.Xnoise' * pcr.Y;
% error
e_OLS = zeros(iter, 1);
% realisations
for j = 1:iter
    % simulation
    [Y, Y_OLS] = regval(B_OLS);
    % L2_norm
    e_OLS(j) = norm(Y - Y_OLS, 2);
end

% -- PCR --
% data dimensions
[m, n] = size(pcr.Xnoise);

% rank of low-rank approximation
r = 1:10;

% error
e_PCR = zeros(iter, length(r));

for i = 1:length(r)
    
    % SVD
    [Unoise, Snoise, Vnoise] = svd(pcr.Xnoise);
    
    % approximations
    Xnoise_tilda = Unoise(1:m, 1:r(i)) * Snoise(1:r(i), 1:r(i)) * Vnoise(1:n, 1:r(i))';

    % weights
    B_PCR = Vnoise(1:n, 1:r(i)) / Snoise(1:r(i), 1:r(i)) * Unoise(1:m, 1:r(i))' * pcr.Y;
    % realisations
    for j = 1:iter
        % simulation
        [Y, Y_PCR] = regval(B_PCR);
        % L2_norm
        e_PCR(j, i) = norm(Y - Y_PCR, 2);
    end
    
end

% figure
fig_train = figure("Name", "OLS vs PCR: regval");
for j = 1:iter
    plot([r(1) r(end)], [e_OLS(j) e_OLS(j)], 'Color', COLORS(3, :), 'LineWidth', 0.5);
    hold on;
end
for j = 1:iter
    plot(r, e_PCR(j, 1:end), 'Color', COLORS(6, :), 'LineWidth', 0.5);
    hold on;
end
p1 = plot(r, mean(e_PCR, 1), 'Color', COLORS(1, :), "DisplayName", "PCR");
hold on;
p2 = plot([r(1) r(end)], [mean(e_OLS) mean(e_OLS)], 'Color', COLORS(2, :), "LineStyle", "--", "DisplayName", "OLS");
title("\textbf{OLS \& PCR}: Model Evaluation");
xlabel("Low-Rank Approximation, $r$");
ylabel("$\|\mathbf{Y} - \tilde{\mathbf{Y}}\|_{2}$");
xticks(r);
[xmin, xmax, ymin, ymax] = axis_range(r, mean(e_PCR, 1), 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
legend([p1 p2]);
saveas(fig_train, "Assignment2/assets/2.3/d/regval.eps", "epsc");