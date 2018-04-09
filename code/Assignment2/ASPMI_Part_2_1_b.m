%% init script
close all;
clear;
% environment settings
startup;

%% Variance of Correlogram

% sampling frequency
Fs = 10;
% number of samples
K = 512;
% linspace - time index
n = 0:1/(2*Fs):10;
% clean signal
A0 = 1.5;
A1 = 1;
A2 = 2;
f0 = 0.3;
f1 = 0.6;
f2 = 0.9;
x = [A0.*sin(2*pi*n*f0) + A1.*sin(2*pi*n*f1) + A2.*sin(2*pi*n*f2) zeros(1, K-length(n))];

% number of realisations
iters = 100;
% noise power
pxx = 2;

% container
Pxx_biased = zeros(iters, K*2-1);

fig_mean = figure("Name", "PSD observations & mean");

for i = 1:iters

    % noise
    w = wgn(length(x), 1, pxx)';
    % observations
    y = x + w;
    % Correlogram
    [~, ~, ~, Pxx_biased(i, :), ~, fs] = correlation(y);
    % plot realisation
    plot(fs*Fs, real(Pxx_biased(i,:)), 'Color', COLORS(6, :), 'LineWidth', 0.5);
    hold on;

end

% plot mean
plot(fs*Fs, mean(real(Pxx_biased)), 'Color', COLORS(1, :));
title(sprintf("PSD estimates (different realisations and mean)"));
xlabel("Frequency ($\pi$ radians)");
ylabel("Power Spectral Density");
grid on; grid minor;
[~, ~, ymin, ~] = axis_range(fs*Fs, min(real(Pxx_biased)), 0.05);
[~, ~, ~, ymax] = axis_range(fs*Fs, max(real(Pxx_biased)), 0.05);
axis([0.0, 1.6, ymin, ymax]);
saveas(fig_mean, sprintf("Assignment2/assets/2.1/b/psd_mean.eps"), "epsc");
hold off;

% plot standard deviation
fig_std = figure("Name", sprintf("PSD observations & mean %d", length(n)));
plot(fs*Fs, std(real(Pxx_biased)), 'Color', COLORS(7, :));
title(sprintf("Standard deviation of the PSD estimate"));
xlabel("Frequency ($\pi$ radians)");
ylabel("Power Spectral Density");
grid on; grid minor;
[~, ~, ymin, ymax] = axis_range(fs*Fs, std(real(Pxx_biased)), 0.05);
axis([0.0, 1.6, ymin, ymax]);
saveas(fig_std, sprintf("Assignment2/assets/2.1/b/psd_std.eps"), "epsc");
hold off;