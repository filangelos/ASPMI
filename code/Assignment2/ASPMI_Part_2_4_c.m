%% init script
close all;
clear;
% environment settings
startup;

%% EEG: Standard vs AR Periodogram

% fetch data
ecg = load('data/ECG_Data/ecg.mat');

% raw ECG
x_raw = {ecg.xRRI1; ecg.xRRI2; ecg.xRRI3};

% signal length (after zero-padding)
K = 2048;
% frequency index
fs = -1:(2/K):1-(1/K);

% segment length
q = 1:5:25;

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
    % figure
    fig = figure("Name", sprintf("AR Periodogram: %d", i));
    % plot
    plot(fs * ecg.fsRRI ./ 2, Pxx, "DisplayName", "Standard");
    
    % PSD: AR
    for j = 1:length(q)
        hold on;
        % model fitting
        [a_hat, sigma_w] = aryule(x, q(j));
        % PSD: AR
        [PSD_AR, w] = freqz(sqrt(sigma_w), a_hat, N, ecg.fsRRI);
        % plot
        plot(w, pow2db(abs(PSD_AR).^2), "DisplayName", sprintf("$p=%d$", q(j)));
    end
    lgd = legend("show");
    lgd.NumColumns = 2;
    axis([0 2 -100 0]);
    title(sprintf("\\textbf{AR} Periodogram: Trial %d", i));
    xlabel("Frequency (Hz)");
    ylabel("Power Spectral Density (dB)");
    grid on; grid minor;
    saveas(fig, sprintf("Assignment2/assets/2.4/c/standard_ar-trial%d.eps", i), "epsc");
    
end
