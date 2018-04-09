%% init script
close all;
clear;
% environment settings
startup;

%% LMS AR: Squared Error

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

% error
error = zeros(N, R, length(mu));

% figure - 1 realisation
fig_1 = figure("Name", "1 Realisation");
% figure - ensemble
fig_ens = figure("Name", sprintf("%d Realisations", R));


for i=1:length(mu)
    for j=1:R
        % data preprocessing
        [X, y] = XyDelta(x(:, j), 1, p);
        % LMS
        [~, error(:, j, i), ~] = LMS(X, y, mu(i), 0);
    end
    figure(fig_1);
    plot(pow2db(error(:, 1, i).^2), "DisplayName", sprintf("$\\mu=%.2f$", mu(i)));
    hold on;
    figure(fig_ens);
    plot(pow2db(mean(error(:, :, i).^2, 2)), "DisplayName", sprintf("$\\mu=%.2f$", mu(i)));
    hold on;
end

figure(fig_1);
title("\textbf{Squared Prediction Error}: One Realisation");
xlabel("Time Index, $t$");
ylabel("Squared Prediction Error (dB)");
axis([0 1000 -70 30]);
legend("show");
grid on; grid minor;
saveas(fig_1, "Assignment3/assets/3.1/b/squared_prediction_error_1.eps", "epsc");

figure(fig_ens);
title(sprintf("\\textbf{Squared Prediction Error}: %d Realisations", R));
xlabel("Time Index, $t$");
ylabel("Squared Prediction Error (dB)");
axis([0 1000 -10 0]);
legend("show");
grid on; grid minor;
saveas(fig_ens, "Assignment3/assets/3.1/b/squared_prediction_error_ens.eps", "epsc");