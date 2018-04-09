%% init script
close all;
clear;
% environment settings
startup;

%% FM: DFT-CLMS

% fetch data
eeg = load('data/EEG_Data/EEG_Data_Assignment1.mat');
% limit length
start = 1000;
eeg.POz = eeg.POz(start:1200+start);

% sampling frequency
fs = eeg.fs;
% number of observations
N = length(eeg.POz);
% length of DFT: 5 DFT samples per Hz
K = 1024;
w = (0:(K-1)) .* (fs / K);

% centered data
y = eeg.POz - mean(eeg.POz);

% time index
t = 1:N;

% noise
sigma_2 = 0.05;
rng(0);
eta = wgn(N, 1, pow2db(0.05), 'complex');

% CLMS step-size
mu = 1;
% CLMS leakage parameter
gamma = [0 0.001];

% data preprocessing
X = (1 / K) * exp(1j * (1:N)' * pi * (0:(K-1)) / K)';

for i = 1:length(gamma)
    % CLMS
    [~, ~, H] = CLMS(X, y', mu, gamma(i));

    % remove outliers
    H = abs(H).^2;
    medianH = 50 * median(median(H));
    H(H > medianH) = medianH;

    % figure - time-frequency plot
    fig = figure("Name", sprintf("Time Frequency, gamma=%.3f", gamma(i)));
    surf(1:N, w, H, "LineStyle", "none");
    view(2);
    % c = colorbar;
    % c.Label.String = "Power Spectral Density (dB)";
    title(sprintf("\\textbf{EEG} \\texttt{POz}: DFT-CLMS Time-Frequency, $\\mathbf{\\gamma=%.3f}$", gamma(i)));
    xlabel("Time Index, $n$");
    yticks(0:20:100);
    ylabel("Frequency (Hz)");
    grid on; grid minor;
    axis([0 N 0 100]);
    saveas(fig, sprintf("Assignment4/assets/4.3/d/dft_clms-gamma_%.3f.eps", gamma(i)), "epsc");
end