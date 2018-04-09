%% init script
close all;
clear;
% environment settings
startup;

%% Chebyshev Window & Blackman-Tukey method and varying (a2, alpha)

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
% number of autocorrelation terms considered
M = N/4;

% alpha parameter
alpha = [4 12];
% sin 2 coef
a2 = [1 0.1 0.01 0.001];

% frequency linespace
f = 0:2/K:1-1/K;

for i = 1:length(alpha)
    
    for j = 1:length(a2)
        
        % Chebyshev Window
        %
        % get time series
        x = x_func(alpha(i), N, f0, sigma, a1, a2(j), phi1, phi2);
        % Chebyshev window
        h = chebwin(N)';
        % windowed signal
        y = x .* h;
        % FFT
        Y = abs(fftshift(fft([y zeros(1, K-N)])));
        % periodogram
        Pyy = pow2db(Y.^2/(N*2*pi))';
        % half periodogram
        Pyy_half = Pyy((length(Pyy)/2 + 1):end, 1);
        % plot Chebyshev Window
        fig1 = figure("Name", sprintf("Chebyshev Half Periodogram alpha=%.1f, a2=%.3f", alpha(i), a2(j)));
        plot(f, Pyy_half);
        title(sprintf("\\textbf{Chebyshev} Window: Periodogram\n$\\alpha=%.1f$ and $a_{2}=%.3f$", alpha(i), a2(j)));
        xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)")
        ylabel("Power Density (dB)")
        axis([0.25 0.55 -150 10]);
        grid on; grid minor;
        saveas(fig1, sprintf("Assignment1/assets/1.3/f/periodogram-leakage-chebyshev-alpha_%.1f-a2_%.3f.eps", alpha(i), a2(j)), "epsc");
    
        % Blackman-Tukey method
        %
        % get autocorrelation
        r_raw = xcorr(x, M, "biased");
        % get peak of autocorrelation
        [m, index] = max(r_raw);
        % shift & center to origin
        r = [r_raw(index:end) zeros(1, K-length(r_raw)) r_raw(1:index-1)];
        % Periodogram
        Pxx = pow2db(abs(fftshift(fft(r))) ./ 2*pi);
        % half periodogram
        Pxx_half = Pxx(1, (length(Pxx)/2 + 1):end);
        % plot Blackman-Tukey method
        fig1 = figure("Name", sprintf("Chebyshev Half Periodogram alpha=%.1f, a2=%.3f", alpha(i), a2(j)));
        plot(f, Pxx_half);
        title(sprintf("\\textbf{Blackman-Tukey} method: Periodogram\n$\\alpha=%.1f$ and $a_{2}=%.3f$", alpha(i), a2(j)));
        xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)")
        ylabel("Power Density (dB)")
        axis([0.25 0.55 -30 30]);
        grid on; grid minor;
        saveas(fig1, sprintf("Assignment1/assets/1.3/f/periodogram-leakage-blackman-alpha_%.1f-a2_%.3f.eps", alpha(i), a2(j)), "epsc");
        
    end
    
end
