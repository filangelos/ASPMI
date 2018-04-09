%% init script
close all;
clear;
% environment settings
startup;

%% CLMS vs ACLMS

% number of samples
N = 1000;
% realisations
R = 100;

% (A)CLMS parameters
mu = 0.1;
gamma = 0;
M = 2;

% WLMA model parameters
sigma_2 = 1;
b = [1.5+1i, 2.5-0.5i];
a = 1;

% algorithms
algo = {'CLMS', 'ACLMS'};

% weights
weights = zeros(M, R, N, length(algo));

% error
error = zeros(N, R, 1, length(algo));

for j=1:R

    % guassian noise
    x = wgn(N, 1,pow2db(sigma_2), 'complex');
    % signal
    y = WLMA(b, a, x);
    % data preprocessing
    [X, ~] = XyDelta(x, 1, M);
    d = [0 conj(y(1:end-1))'];

    % CLMS
    [~, error(:, j, :, 1), weights(:, j, :, 1)] = CLMS(X, d, mu, gamma);
    % ACLMS
    [~, error(:, j, :, 2), weights(:, j, :, 2)] = ACLMS(X, d, mu);

end

% figure - non-circularity
fig = figure("Name", sprintf("Non-Circularity"));
scatter(real(y), imag(y), 30, "filled", "DisplayName", "WLMA(1)")
hold on
scatter(real(x), imag(x), 30, "filled", "DisplayName", "WGN")
title(sprintf("\\textbf{WLMA}: Circularity Check"));
xlabel("Real Part, $\Re$");
ylabel("Imaginary Part, $\Im$");
legend("show");
grid on; grid minor;
saveas(fig, sprintf("Assignment4/assets/4.1/a/comparison.eps"), "epsc");

% figure - learning curves
fig = figure("Name", sprintf("Learning Curves"));
plot(pow2db(mean(abs(error(:, :, 1, 1)).^2, 2)), "DisplayName", "CLMS");
hold on
plot(pow2db(mean(abs(error(:, :, 1, 2)).^2, 2)), "DisplayName", "ACLMS");
title(sprintf("\\textbf{WLMA}: Learning Curves for \\textbf{CLMS} and \\textbf{ACLMS}"));
xlabel("Time Index, $t$");
ylabel("Squared Error (dB)");
legend("show", "Location", "East");
grid on; grid minor;
ylim([-310 20]);
saveas(fig, sprintf("Assignment4/assets/4.1/a/learning_curves.eps"), "epsc");

function y = WLMA(b, a, x)
    N = length(x);
    y = zeros(N, 1);
    x = [0; x];
    for i=1:N
        y(i) = a * x(i+1) + b(1) * x(i) + b(2) * conj(x(i));
    end
end