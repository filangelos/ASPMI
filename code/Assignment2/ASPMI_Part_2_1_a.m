%% init script
close all;
clear;
% environment settings
startup;

%% Correlogram

% number of signal samples
N = 1024;

% signals
WGN = wgn(N, 1, 1);
SIN = sin(linspace(0, N, N))' + random('Normal', 0, 1, N, 1);
FIL = filter([1/4 1/4 1/4 1/4], 1, WGN);
signal = [WGN, SIN, FIL];
name = {'WGN', 'Noisy Sinewave', 'Filtered WGN'};

for i = 1:length(name)

    % ACF & PSD
    [acf_biased, acf_unbiased, lags, Pxx_biased, Pxx_unbiased, fs] = correlation(signal(:, i));
    
    % ACF figure
    fig1 = figure("Name", sprintf("%s ACF", name{i}));
    plot(lags, acf_unbiased, 'DisplayName', 'unbiased');
    hold on;
    plot(lags, acf_biased, 'DisplayName', 'biased');
    title(sprintf("\\textbf{%s}: Autocorrelation Function", name{i}));
    xlabel("Lags, $k$");
    ylabel("ACF, $r(k)$");
    grid on; grid minor;
    [xmin, xmax, ymin, ymax] = axis_range(lags, acf_unbiased, 0.05);
    axis([xmin, xmax, ymin, ymax]);
    legend('show');
    saveas(fig1, sprintf("Assignment2/assets/2.1/a/acf-%s.eps", replace(name{i}, ' ', '_')), "epsc");
    
    % PSD figure
    fig2 = figure("Name", sprintf("%s PSD", name{i}));
    plot(fs, Pxx_unbiased, 'DisplayName', 'unbiased');
    hold on;
    plot(fs, Pxx_biased, 'DisplayName', 'biased');
    title(sprintf("\\textbf{%s}: Correlogram", name{i}));
    xlabel("Normalised Frequency, $\omega$");
    ylabel("PSD, $P(\omega)$");
    grid on; grid minor;
    [xmin, xmax, ymin, ymax] = axis_range(fs, Pxx_unbiased, 0.05);
    axis([xmin, xmax, ymin, ymax]);
    legend('show');
    saveas(fig2, sprintf("Assignment2/assets/2.1/a/psd-%s.eps", replace(name{i}, ' ', '_')), "epsc");
    
end