%% init script
close all;
clear;
% environment settings
startup;

%% Rectangular Window and varying (a2, alpha)

% given hyperparameters
% number of signal samples
N = 256;
% fundamental frequency
f0 = 0.2;
% noise std
sigma = 0;
% sin 1 coef
a1 = 1;
% sin 1 arg
phi1 = 0;
% sin 2 arg
phi2 = 0;

% length of total (zero-padded) signal
K = 2.^12;

% alpha parameter
alpha = [4 12];
% sin 2 coef
a2 = [1 0.1 0.01 0.001];

for i = 1:length(alpha)
    
    for j = 1:length(a2)
        
        % get time series
        x = x_func(alpha(i), N, f0, sigma, a1, a2(j), phi1, phi2);
        % FFT
        X = abs(fftshift(fft([x zeros(1, K-N)])));
        % periodogram
        Pxx = pow2db(X.^2/(N*2*pi))';
        % half periodogram
        Pxx_half = Pxx((length(Pxx)/2 + 1):end, 1);
        % frequency linespace
        f = 0:2/K:1-1/K;
        % plot half side periodogram
        fig = figure("Name", sprintf("Half Periodogram alpha=%.1f, a2=%.3f", alpha(i), a2(j)));
        plot(f, Pxx_half);
        title(sprintf("\\textbf{Rectangular} Window: Periodogram\n$\\alpha=%.1f$, $a_{2}=%.3f$", alpha(i), a2(j)));
        xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)")
        ylabel("Power Density (dB)")
        axis([0.25 0.55 -60 25]);
        grid on; grid minor;
        saveas(fig, sprintf("Assignment1/assets/1.3/d/periodogram-leakage-rect-alpha_%.1f-a2_%.3f.eps", alpha(i), a2(j)), "epsc");
    end
    
end
