%% init script
close all;
clear;
% environment settings
startup;

%% GNGD NLMS

% number of samples
N = 1000;
% realisations
R = 100;
% GASS params
rho = 0.05;
mu_0 = 0.1;
gamma = 0;
alpha = 0.75;
% LMS step-size
mu = [1];

% AR model parameters
a = [1 0.9];
sigma_2 = 0.5;
b = 1;
p = length(a);

% algorithms
algo = {'benvenist'};

% weights
weights = zeros(p, R, N, length(algo) + length(mu));

% error
error = zeros(N, R, 1, length(algo) + length(mu));

for i=1:length(algo)
    for j=1:R
        
        % guassian noise
        eta = random('Normal', 0, sigma_2, N, 1);

        % signal
        x = filter(a, b, eta);

        % data preprocessing
        [X, ~] = XyDelta(eta, 1, p);
        y = [0 x(1:end-1)'];
        
        % GASS
        [~, error(:, j, :, i), weights(:, j, :, i)] = GASS(X, y, mu_0, rho, gamma, string(algo{i}), alpha);
        % NLMS
        [~, error(:, j, :, length(algo) + mod(i, length(mu)) + 1), weights(:, j, :, length(algo) + mod(i, length(mu)) + 1)] = NLMS(X, y, mu(mod(i, length(mu))+1), 0, rho);
    end
end

fig = figure("Name", sprintf("Weight Error Curves"));

% legend labels
labels = [arrayfun(@(x) replace(x, '_', '\_'), algo) "GNGD"];

for k = 1:size(weights, 4)

    plot(a(end) - reshape(mean(weights(p, :, :, k), 2), N, []), "DisplayName", labels{k});
%     plot(a(end) - mean(weights(:, :, length(a), k), 2), "DisplayName", labels{k});
    hold on;

end

title(sprintf("\\textbf{GNGD}: Weight Error Curves, $\\tilde{w}(n) = w_{0} - w(n)$"));
xlabel("Time Index, $t$");
ylabel("Filter Weights Error");
lgd = legend("show");
lgd.NumColumns = 2;
grid on; grid minor;
xlim([0 100]);
saveas(fig, sprintf("Assignment3/assets/3.2/c/weight_error_curves.eps"), "epsc");

hold off;

fig = figure("Name", sprintf("Squared Error Curves"));

for k = 1:size(weights, 4)

    plot(pow2db(mean(error(:, :, 1, k), 2).^2), "DisplayName", labels{k});
    hold on;

end

title(sprintf("\\textbf{GNGD}: Squared Error Curves, $e^{2}(n) = (y(n) - \\hat{y}(n))^{2}$"));
xlabel("Time Index, $t$");
ylabel("Squared Prediction Error (dB)");
lgd = legend("show", "Location", "NorthEast");
lgd.NumColumns = 2;
grid on; grid minor;
xlim([0 400]);
saveas(fig, sprintf("Assignment3/assets/3.2/c/squared_prediction_error.eps"), "epsc");
