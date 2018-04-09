%% init script
close all;
clear;
% environment settings
startup;

%% EEG: Standard vs Averaged Periodogram

% fetch data
ecg = load('data/ECG_Data/ecg.mat');

% raw ECG
x_raw = {ecg.xRRI1; ecg.xRRI2; ecg.xRRI3};

% signal length (after zero-padding)
K = 2048;
% frequency index
fs = -1:(2/K):1-(1/K);

% segment length
L = [200 100 50];

for i = 1:size(x_raw, 1)
    % trial
    x = detrend(x_raw{i});
    % size
    N = length(x);
    % window
    x = x.*hann(N)';
    % DFT
    X = abs(fftshift(fft([x zeros(1, K-N)])));
    % PSD: standard
    Pxx = pow2db(X.^2 / (N * 2 * pi));
    % figure object: standard
    fig = figure("Name", sprintf("Standard Periodogram: %d", i));
    plot(fs * ecg.fsRRI ./ 2, Pxx, "DisplayName", "Standard");
    axis([0 2 -100 0]);
    title(sprintf("\\textbf{Standard} Periodogram: Trial %d", i));
    xlabel("Frequency (Hz)");
    ylabel("Power Spectral Density (dB)");
    grid on; grid minor;
    saveas(fig, sprintf("Assignment2/assets/2.4/a/standard-trial%d.eps", i), "epsc");
    % figure object: averaged
    fig = figure("Name", sprintf("Averaged Periodogram: %d", i));
    for j = 1:length(L)
        hold on;
        % PSD: averaged
        [Pxx_aver, w] = pwelch(x, rectwin(L(j)), 0, K, ecg.fsRRI, 'onesided');
        % plot
        plot(w, pow2db(Pxx_aver), "DisplayName", sprintf("$L=%d$", L(j)), "Color", COLORS(1+j, :));
    end
    axis([0 2 -75 0]);
    title(sprintf("\\textbf{Averaged} Periodogram: Trial %d", i));
    xlabel("Frequency (Hz)");
    ylabel("PSD (dB)");
    grid on; grid minor;
    legend("show");
    saveas(fig, sprintf("Assignment2/assets/2.4/a/averaged-trial%d.eps", i), "epsc");
    
end
