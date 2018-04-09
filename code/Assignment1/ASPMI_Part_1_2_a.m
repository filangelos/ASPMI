%% init script
close all;
clear;
% environment settings
startup;

%% Approximation in the Definition of PSD - Simulations

M = [10 128];
L_coefs = [2 12];

for i = 1:length(M)
    % Length of samples of x signal
    L = [2*M(i) 256 1024];
    for j = 1:length(L)
        % index
        k = linspace(0, M(i)-1, M(i));
        % autocorrelation function
        rho = zeros(1, M(i));
        rho(abs(k) <= M(i)-1) = (M(i) - abs(k))/M(i);
        % x signal
        x = [rho zeros(1, L(j)-2*M(i)+1) fliplr(rho(2:end))];
        % magnitude DFT spectrum
        X = abs(fftshift(fft(x)));
        % frequency index
        df = 2*pi/L(j);
        f = linspace(-L(j)/2, L(j)/2 - 1, L(j)) * df;
        % stem plot
        fig = figure("Name", sprintf("DFT L=%i, M=%d", L(j), M(i)));
        stem(f, X, "COLOR", COLORS(i, :));
        if L(j) == 2*M(i)
            title(sprintf("\\textbf{No} Zero-Padding, $L=%d$, $\\mathbf{M=%d}$", L(j), M(i)));
        else
            title(sprintf("\\textbf{With} Zero-Padding, $L=%d$, $\\mathbf{M=%d}$", L(j), M(i)));
        end
        xlabel("Frequency (rad/sample)");
        ylabel("Magnitude");
        axis([-1.5 1.5 0 M(i)*1.25]);
        grid on; grid minor;
        saveas(fig, sprintf("Assignment1/assets/1.2/a/zero-pad-L_%d-M_%d.eps", L(j), M(i)), "epsc");
    end
end