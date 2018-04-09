%% init script
close all;
clear;
% environment settings
startup;

%% LMS AR: EMPSE

% number of samples
N = 1000;
% realisations
R = 100;

% AR model parameters
a = [0.1 0.8];
sigma_2 = 0.25;
b = 0;
p = length(a);

% AR process simulation
ar = arima("Constant", b, "AR", a, "Variance", sigma_2);
x = simulate(ar, N, "NumPaths", R);

% step-size
mu = [0.01 0.05];

% steady-state time index
t0 = 500;

% error
error = zeros(N, R, length(mu));
% MSE: steady-state
mse = zeros(R, length(mu));
% EMSE
emse = zeros(R, length(mu));

for i=1:length(mu)
    for j=1:R
        % data preprocessing
        [X, y] = XyDelta(x(:, j), 1, p);
        % LMS
        [~, error(:, j, i), ~] = LMS(X, y, mu(i), 0);
        % MSE: steady-state
        mse(j, i) = mean(error(t0:end, j, i).^2);
        % EMSE
        emse(j, i) = mse(j, i) / sigma_2 - 1;
    end
%     % one realisations
%     fprintf("[mu = %.2f] EMPSE: One realisation: %.5f\n", mu(i), emse(1, i));
    % ensemble
    fprintf("[mu = %.2f] EMPSE: 100 realisations: %.5f\n", mu(i), mean(emse(:, i), 1));
end