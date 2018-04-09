%% init script
close all;
clear;
% environment settings
startup;

%% AR Process Modeling, N=10000

% AR coefficients
a = [2.76, -3.81, 2.65, -0.92];
% AR process
AR = arima('Constant', 0, 'AR', a, 'Variance', 1);
% number of samples
off = 500;
N = 10000;
% draw samples from stochastic process
x_ = simulate(AR, N+off);
% remove first 500 samples
% to remove the transient output of the filter
x = x_(off+1:end);
% ideal spectrum
[ideal, w] = freqz(1, [1 -a], length(x));

% AR processes orders to try
order = 2:14;

% error
sigma_w = -ones(1, length(order));
error = zeros(1, length(order));
% log-likelihood
logL = zeros(length(order), 1);

for i = 1:length(order)

    % get coefficients by Yule-Walker method
    [a_hat, sigma_w(1, i)] = aryule(x, order(i));
    
    % model
    mod = arima(order(i), 0, 0);
    % estimation
    [~, ~, logL(i)] = estimate(mod, x, 'Display', 'off');
    
    % PSD estimate
    % P_{y} = \frac{\sima_{w}^{2}}{|1-\sum_{k=1}^{p} a_{k}e^{-jkw}|^{2}}
    [peaks(:, i), ~] = freqz(sigma_w(1, i)^(1/2), a_hat, length(x));
    
    fig = figure("Name", sprintf("AR(%d)", order(i)));
    plot(w/pi, pow2db(abs(ideal).^2), "DisplayName", "original");
    hold on
    plot(w/pi, pow2db(abs(peaks(:, i)).^2), "DisplayName", "model");
    title(sprintf("\\textbf{AR(%d)}: Spectral Estimation, $\\mathbf{N = %d}$", order(i), N));
    xlabel("Normalised Frequency");
    ylabel("Power Spectral Density (dB)");
    grid on; grid minor;
    [~, ~, ~, ~] = axis_range(w/pi, max([pow2db(abs(peaks(:, i)).^2) pow2db(abs(ideal).^2)]), 0.05);
    [~, ~, ~, ~] = axis_range(w/pi, min([pow2db(abs(peaks(:, i)).^2) pow2db(abs(ideal).^2)]), 0.05);
    axis([0.15, 0.35, 20, 50]);
    legend("show");
    saveas(fig, sprintf("Assignment2/assets/2.2/c/ar_%d.eps", order(i)), "epsc");
    hold off;
        
end

fig = figure("Name", "Error");
plot(order, pow2db(sigma_w));
title(sprintf("\\textbf{AR} Process: Noise Power against Model Order, $\\mathbf{N = %d}$", N));
xlabel("Model Order, $p$");
ylabel("Noise Power, $\sigma_{w}^{2}$ (dB)");
grid on; grid minor;
[xmin, xmax, ymin, ymax] = axis_range(order, pow2db(sigma_w), 0.05);
axis([xmin, xmax, ymin, ymax]);
saveas(fig, "Assignment2/assets/2.2/c/error.eps", "epsc");

[aic, bic] = aicbic(logL, order, N);
[minY, minX] = min(pow2db(aic));

fig = figure("Name", "AIC");
plot(order, pow2db(aic));
hold on;
scatter(minX, minY, 50, 'filled');
title(sprintf("\\textbf{AR} Process: AIC against Model Order, $\\mathbf{N = %d}$", N));
xlabel("Model Order, $p$");
ylabel("AIC, $\sigma_{w}^{2}$ (dB)");
grid on; grid minor;
[xmin, xmax, ymin, ymax] = axis_range(order, pow2db(bic), 0.05);
axis([xmin, xmax, ymin, ymax]);
saveas(fig, "Assignment2/assets/2.2/c/aic.eps", "epsc");