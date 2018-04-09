%% init script
close all;
clear;
% environment settings
startup;

%% Leaky LMS AR: Parameters Impact

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
gamma = 0:0.2:1.0;

% weights
weights = zeros(p, R, N, length(mu));

for l=1:length(gamma)

    for i=1:length(mu)
        for j=1:R
            % data preprocessing
            [X, y] = XyDelta(x(:, j), 1, p);
            % (Leaky) LMS
            [~, ~, weights(:, j, :, i)] = LMS(X, y, mu(i), gamma(l));
        end

        fig = figure("Name", sprintf("Weights for mu=%.2f, gamma=%.1f", mu(i), gamma(l)));
        for k=1:p
    
            plot(reshape(mean(weights(k, :, :, i), 2), N, []), "Color", COLORS(k, :), "DisplayName", sprintf("$\\hat{\\alpha}_{%d}$", k));
            hold on;
            plot([1 size(weights, 3)], [a(k) a(k)], "LineStyle", "-.", "Color", COLORS(k+2, :), "DisplayName", sprintf("$\\alpha_{%d}$", k));
            hold on;

        end
        title(sprintf("\\textbf{Leaky LMS}: Filter Weights Evolution\n$\\mu=%.2f$ and $\\gamma=%.1f$", mu(i), gamma(l)));
        xlabel("Time Index, $t$");
        ylabel("Filter Weights");
        ylim([-0.2 1.2]);
        yticks(-0.2:0.2:1.4);
        lgd = legend("Location", "North");
        lgd.NumColumns = 2*p;
        grid on; grid minor;
        saveas(fig, sprintf("Assignment3/assets/3.1/f/weights_evolution-mu_%.2f-gamma_%.1f.eps", mu(i), gamma(l)), "epsc");
    end

end
