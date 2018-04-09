%% init script
close all;
clear;
% environment settings
startup;

%% FM: DFT-CLMS

% number of samples
N = 1500;
% time index
t = 1:N;
% sampling frequency
fs = 1500;
% segment length
K = 2048;

% noise
sigma_2 = 0.05;
rng(0);
eta = wgn(N, 1, pow2db(0.05), 'complex');

% frequency
f = arrayfun(@frequency, t)';
w = (0:(K-1)) .* (fs / K);
% phase
phi = cumtrapz(f);

% signal
y = exp(1j * (2 * pi * phi / fs)) + eta;

% CLMS step-size
mu = 1;
% CLMS leakage parameter
gamma = [0 0.01 0.05 0.1 0.5];

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
    fig = figure("Name", sprintf("Time Frequency, gamma=%.2f", gamma(i)));
    surf(1:N, w, H, "LineStyle", "none");
    view(2);
    % c = colorbar;
    % c.Label.String = "Power Spectral Density (dB)";
    title(sprintf("\\textbf{FM}: DFT-CLMS Time-Frequency, $\\mathbf{\\gamma=%.2f}$", gamma(i)));
    xlabel("Time Index, $n$");
    ylabel("Frequency (Hz)");
    grid on; grid minor;
    ylim([0 1000]);
    saveas(fig, sprintf("Assignment4/assets/4.3/c/dft_clms-gamma_%.2f.eps", gamma(i)), "epsc");
end