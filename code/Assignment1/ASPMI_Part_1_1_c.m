%% init script
close all;
clear;
% environment settings
startup;

%% DFT Spectra Sampled Sine Wave - (K-N) Zero-Padding

cache = {};

% sinewave frequency
for f0 = [20, 24]
    % number of DFT samples K
    for K = [100, 1000, 500, 250]
        % sampling frequency
        Fs = 1000;
        % number of samples
        N = 100;
        % time index
        t = linspace(0, N-1, N) * (1/Fs);
        % sinewave - (K-N) zero-padded
        x = [sin(2*pi*f0*t) zeros(1, K-N)];
        % magnitude DFT spectrum
        X = abs(fftshift(fft(x)));
        % frequency index
        df = Fs/K;
        f = linspace(-K/2, K/2 - 1, K) * df;
        % append to cache if K=100
        if K == 100
            cache.f = f;
            cache.X = X;
        end
        % stem plot
        fig = figure("Name", sprintf("DFT K=%i", K));
        stem(f, X);
        % super-impose plot if K~=100
        if K ~= 100
            hold on;
            scatter(cache.f, cache.X, 30, "filled");
        end
        title(sprintf("$\\mathbf{f_{0}=%d}$Hz Sine Wave DFT Spectrum\n$Fs=%d$Hz, $N=%d$, $\\mathbf{K=%d}$", f0, Fs, N, K));
        xlabel("Frequency (Hz)");
        ylabel("Magnitude");
        axis([-50 50 0 60]);
        yticks([0, 25, 50])
        xticks([-2*f0, -f0, 0, f0, 2*f0])
        grid on; grid minor;
        saveas(fig, sprintf("Assignment1/assets/1.1/c/dft-f0_%d-K_%d.eps", f0, K), "epsc");
    end
end