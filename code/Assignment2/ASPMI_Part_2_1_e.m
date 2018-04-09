%% init script
close all;
clear;
% environment settings
startup;

%% MUSIC

% length of signal
K = 50;
% frequencies
f0 = 0.3;
f1 = 0.32;
% linspace
n = 0:29;
% signal
x = [exp(1j*2*pi*f0*n) + exp(1j*2*pi*f1*n) zeros(1, K - length(n))];
% signal space dimensionality
p = [1 2 3];

% number of realisations
iters = 200;

for j = 1:length(p)

    % container
    S = zeros(iters, 256);

    fig_mean = figure("Name", "MUSIC realisations & mean");

    for i = 1:iters

        % noise
        noise = 0.2/sqrt(2) * (randn(1, K) + 1j*randn(1, K));
        % observations
        y = x + noise;
        % correlation matrix estimate
        [~, R] = corrmtx(y, 14, 'mod');
        % MUSIC
        [S(i, :), F] = pmusic(R, p(j), [ ], 1);
        % plot realisation
        plot(F, S(i, :), 'Color', COLORS(6, :), 'LineWidth', 0.5);
        hold on;

    end

    % plot mean
    plot(F, mean(S), 'Color', COLORS(1, :));
    title(sprintf("MUSIC estimate (different realisations and mean)\n$\\mathbf{n = %d}$ and $\\mathbf{p = %d}$", length(n), p(j)));
    xlabel("Frequency ($\pi$ radians)");
    ylabel("Power Spectral Density");
    grid on; grid minor;
    [xmin, xmax, ymin, ~] = axis_range(F, min(S), 0.05);
    [~, ~, ~, ymax] = axis_range(F, max(S), 0.05);
    axis([0.25, 0.4, ymin, ymax]);
    saveas(fig_mean, sprintf("Assignment2/assets/2.1/e/MUSIC_mean-p_%d.eps", p(j)), "epsc");
    hold off;

    % plot standard deviation
    fig_std = figure("Name", "PSD observations & mean");
    plot(F, std(S), 'Color', COLORS(7, :));
    title(sprintf("Standard deviation of MUSIC estimate\n$\\mathbf{n = %d}$ and $\\mathbf{p = %d}$", length(n), p(j)));
    xlabel("Frequency ($\pi$ radians)");
    ylabel("Power Spectral Density");
    grid on; grid minor;
    [xmin, xmax, ymin, ymax] = axis_range(F, std(S), 0.05);
    axis([0.25, 0.4, ymin, ymax]);
    saveas(fig_std, sprintf("Assignment2/assets/2.1/e/MUSIC_std-p_%d.eps", p(j)), "epsc");
    hold off;

end