%% init script
close all;
clear;
% environment settings
startup;

%% LMS ALE: Delta for fixed M

% delays
Delta = 1:25;
% step-size
mu = 0.01;

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

% LMS model order
M = 5;

% predictions
x_hat = zeros(N, R, length(Delta));
% MSE
mse = zeros(R, length(Delta));
% MPSE
mpse = zeros(length(Delta), 1);

for i = 1:length(Delta)
    
    for j = 1:R
        
        % guassian noise
        eta = random('Normal', 0, sigma_2, N, 1);
        % signal
        s(:, j) = x' + filter(b, a, eta);
        % data preprocessing
        [X, d] = XyDelta(s(:, j), Delta(i), M);
        % LMS
        [x_hat(:, j, i), ~, ~] = LMS(X, d, mu, 0);
        
        % MSE
        mse(j, i) = mean((x(t0:end)' - x_hat(t0:end, j, i)).^2);
    end
    
    % MPSE
    mpse(i) = mean(mse(:, i));
    % figure - overlay
    fig = figure("Name", sprintf("%d Realisations Overlay", R));
    plts = [];
    % print overlays
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
    title(sprintf("\\textbf{ALE}: %d Realisations Overlay, with $\\mathbf{\\Delta=%d}$ and $\\mathbf{M=%d}$", R, Delta(i), M));
    xlabel("Time Index, $t$");
    ylabel("");
    lgd = legend(plts);
    lgd.NumColumns = length(plts);
    grid on; grid minor;
    saveas(fig, sprintf("Assignment3/assets/3.3/a/ale_overlay-Delta_%d.eps", Delta(i)), "epsc");
    ylim([-5 5]);
end

% figure - mpse
fig = figure("Name", sprintf("MPSE against Delta"));
plot(Delta, pow2db(mpse));
title(sprintf("\\textbf{ALE}: MPSE against delay $\\Delta$, with $\\mathbf{M=%d}$", M));
xlabel("Delay, $\Delta$");
ylabel("MPSE (dB)");
grid on; grid minor;
[xmin, xmax, ymin, ymax] = axis_range(Delta, pow2db(mpse), 0.05);
axis([xmin, xmax, ymin, ymax]);
saveas(fig, sprintf("Assignment3/assets/3.3/a/ale_mpse.eps"), "epsc");