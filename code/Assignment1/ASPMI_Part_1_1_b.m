%% init script
close all;
clear;
% environment settings
startup;

%% DFT Spectra of 20Hz Sampled Sine Wave - (K-N) Zero-Padding

% number of DFT samples K
for K = [100, 1000]
    % sinewave frequency
    f0 = 20;
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
    % stem plot
    fig = figure("Name", sprintf("DFT K=%i", K));
    stem(f, X);
    title(sprintf("Sampled 20Hz Sine Wave Spectrum\n$Fs=%d$Hz, $N=%d$, $\\mathbf{K=%d}$", Fs, N, K));
    xlabel("Frequency (Hz)");
    ylabel("Magnitude");
    axis([-50 50 0 60]);
    yticks([0, 25, 50])
    xticks([-2*f0, -f0, 0, f0, 2*f0])
    grid on; grid minor;
    saveas(fig, sprintf("Assignment1/assets/1.1/b/dft-sampled-K_%d.eps", K), "epsc");
end