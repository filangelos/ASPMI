%% init script
close all;
clear;
% environment settings
startup;

%% Effect of Imaginary Part of DFT - Symmetric Signal (Negligible)

for M = [10 128]
    % Length of samples of x signal
    L = 256;
    % index
    k = linspace(0, M-1, M);
    % autocorrelation function
    rho = zeros(1, M);
    rho(abs(k) <= M-1) = (M - abs(k))/M;
    % x signal
    x = [rho zeros(1, L-2*M+1) fliplr(rho(2:end))];
    % magnitude DFT spectrum
    X_complex = fftshift(fft(x));
    % frequency index
    df = 2*pi/L;
    f = linspace(-L/2, L/2 - 1, L) * df;
    
    % figure object
    fig_real = figure("Name", sprintf("DFT abs M=%d", M));
    stem(f, real(X_complex), "color", COLORS(1, :))
    title(sprintf("\\textbf{Symmetric} ACF: Real Part"));
    xlabel("Frequency (rad/sample)");
    ylabel("$\mathtt{real(xf)}$");
    grid on; grid minor;
    xlim([-2 2]);
    saveas(fig_real, sprintf("Assignment1/assets/1.2/b/symmetric_real-M_%d.eps", M), "epsc");
    
    % figure object
    fig_imag = figure("Name", sprintf("DFT img M=%d", M));
    stem(f, imag(X_complex), "color", COLORS(2, :))
    title(sprintf("\\textbf{Symmetric} ACF: Imaginary Part"));
    xlabel("Frequency (rad/sample)");
    ylabel("$\mathtt{imag(xf)}$");
    grid on; grid minor;
    xlim([-2 2]);
    saveas(fig_imag, sprintf("Assignment1/assets/1.2/b/symmetric_imag-M_%d.eps", M), "epsc");
    
    % figure object
    fig_error = figure("Name", sprintf("DFT Error M=%d", M));
    % stem abs
    stem(f, abs(X_complex), 'filled', "color", COLORS(1, :), "marker", "o", "DisplayName", "$\mathtt{abs}$");
    hold on;
    % stem real
    stem(f, real(X_complex), "color", COLORS(2, :), "DisplayName", "$\mathtt{real}$");
    hold on;
    % stem error
    stem(f, abs(X_complex) - real(X_complex), "color", COLORS(3, :), "DisplayName", "error");
    legend("show");
    title(sprintf("\\textbf{Symmetric} ACF: Power Spectral Estimation, $\\mathbf{M=%d}$", M));
    xlabel("Frequency (rad/sample)");
    ylabel("PSD Estimate");
    if M == 10
        xo = 1.5;
    else
        xo = 0.15;
    end
    axis([-xo xo -M*0.075 M*1.25]);
    grid on; grid minor;
    saveas(fig_error, sprintf("Assignment1/assets/1.2/b/comparison-M_%d.eps", M), "epsc");
    
end
