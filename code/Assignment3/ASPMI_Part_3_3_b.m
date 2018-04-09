%% init script
close all;
clear;
% environment settings
startup;

%% LMS ALE: varying Delta & M

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
M = [5 10 15 20];

% predictions
x_hat = zeros(N, R, length(Delta));
% MSE
mse = zeros(R, length(Delta));
% MPSE
mpse = zeros(length(Delta), 1);

% figure - mpse vs Delta
fig = figure("Name", sprintf("MPSE against Delta"));
% axis ranges
xmin = inf;
xmax = -inf;
ymin = inf;
ymax = -inf;

for m = 1:length(M)

    for i = 1:length(Delta)

        for j = 1:R
        
            % guassian noise
            eta = random('Normal', 0, sigma_2, N, 1);
            % signal
            s(:, j) = x' + filter(b, a, eta);
            % data preprocessing
            [X, d] = XyDelta(s(:, j), Delta(i), M(m));
            % LMS
            [x_hat(:, j, i), ~, ~] = LMS(X, d, mu, 0);

            % MSE
            mse(j, i) = mean((x(t0:end)' - x_hat(t0:end, j, i)).^2);
        end
    
        % MPSE
        mpse(i) = mean(mse(:, i));

    end
    
    plot(Delta, pow2db(mpse), "DisplayName", sprintf("M=%d", M(m)));
    hold on;
    
    % axis range
    [xmin_i, xmax_i, ymin_i, ymax_i] = axis_range(Delta, pow2db(mpse), 0.05);
    xmin = min(xmin, xmin_i);
    xmax = max(xmax, xmax_i);
    ymin = min(ymin, ymin_i);
    ymax = max(ymax, ymax_i);
end

title(sprintf("\\textbf{ALE}: MPSE against delay $\\mathbf{\\Delta}$"));
xlabel("Delay, $\mathbf{\Delta}$");
ylabel("MPSE (dB)");
grid on; grid minor;
lgd = legend("show");
axis([xmin, xmax, ymin, ymax]);
saveas(fig, sprintf("Assignment3/assets/3.3/b/ale_mpse_vs_Delta.eps"), "epsc");

% LMS model order
M = 1:20;

% optimal delay
Delta = 3;

% MSE
mse = zeros(R, length(M));
% MPSE
mpse = zeros(length(M), 1);

for m = 1:length(M)

    for j = 1:R

        % guassian noise
        eta = random('Normal', 0, sigma_2, N, 1);
        % signal
        s(:, j) = x' + filter(b, a, eta);
        % data preprocessing
        [X, d] = XyDelta(s(:, j), Delta, M(m));
        % LMS
        [tmp, ~, ~] = LMS(X, d, mu, 0);

        % MSE
        mse(j, m) = mean((x(t0:end) - tmp(t0:end)).^2);
    end

    % MPSE
    mpse(m) = mean(mse(:, m));
end

% figure - mpse vs M
fig = figure("Name", sprintf("MPSE against M"));
plot(M, pow2db(mpse));
title(sprintf("\\textbf{ALE}: MPSE against Model Order $\\mathbf{M}$"));
xlabel("Model Order, $\mathbf{M}$");
ylabel("MPSE (dB)");
grid on; grid minor;
[xmin, xmax, ymin, ymax] = axis_range(M, pow2db(mpse), 0.05);
axis([xmin, xmax, ymin, ymax]);
saveas(fig, sprintf("Assignment3/assets/3.3/b/ale_mpse_vs_M.eps"), "epsc");