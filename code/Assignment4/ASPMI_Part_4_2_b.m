%% init script
close all;
clear;
% environment settings
startup;

%% FM: CLMS

% number of samples
N = 1500;
% time index
t = 1:N;
% sampling frequency
fs = 1500;
% AR model order
p = 1;
% segment length
K = 1024;

% noise
sigma_2 = 0.05;
rng(0);
eta = wgn(N, 1, pow2db(0.05), 'complex');

% frequency
f = arrayfun(@frequency, t)';
% phase
phi = cumtrapz(f);

% signal
y = exp(1j * (2 * pi * phi / fs)) + eta;

% CLMS step-size
mu = [0.1 0.05 0.01 0.001];
% CLMS leakage parameter
gamma = 0;

% data preprocessing
[X, d] = XyDelta(y, 1, p);

for i = 1:length(mu)

    % CLMS
    [~, ~, h_CLMS] = CLMS(X, d, mu(i), gamma);
    
    % spectrum estimate cache
    H = zeros(K, N);
    
    % power spectrum estimation
    for n = 1:N
        
        % estimation
        [h, w] = freqz(1, [1; -conj(h_CLMS(n))], K, fs);
        % storage
        H(:, n) = abs(h).^2;
    
    end
    
    % remove outliers
    medianH = 50 * median(median(H));
    H(H > medianH) = medianH;
    
    % figure - time-frequency plot
    fig = figure("Name", sprintf("Time Frequency, mu=%.3    f", mu(i)));
    surf(1:N, w, H, "LineStyle", "none");
    view(2);
    c = colorbar;
    c.Label.String = "Power Spectral Density (dB)";
    title(sprintf("\\textbf{FM}: CLMS-AR(%d) Spectrogram, $\\mathbf{\\mu=%.3f}$", p, mu(i)));
    xlabel("Time Index, $n$");
    ylabel("Frequency (Hz)");
    grid on; grid minor;
    ylim([0 600]);
    saveas(fig, sprintf("Assignment4/assets/4.2/b/time_frequency-mu_%.3f.eps", mu(i)), "epsc");
    
end