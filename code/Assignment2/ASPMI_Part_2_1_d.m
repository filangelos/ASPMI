%% init script
close all;
clear;
% environment settings
startup;

%% Complex Exponentials

% length of signal
K = 512;
% frequencies
f0 = 0.3;
f1 = 0.32;
% number of observations
nmax = [[20 25 30]; [35 40 45]];

for j = 1:size(nmax, 1)
    
    fig = figure("Name", sprintf("Complex Exponentials %d", j));
    h = zeros(1, length(nmax));

    % maximum number of observations
    for i = 1:size(nmax, 2)

        % linspace
        n = 0:nmax(j, i);
        % noise
        noise = 0.2/sqrt(2)*(randn(size(n))+1j*randn(size(n)));
        % signal
        x = exp(1j*2*pi*f0*n) + exp(1j*2*pi*f1*n) + noise;

        % PSD
        Pxx = fft([x zeros(1, K-length(x))]) ./ length(n);
        % normalised frequency axis
        fs = 0:(1/K):1-(1/K);
        h(i) = plot(fs, pow2db(abs(Pxx)), 'DisplayName', sprintf("$n=%d$", nmax(j, i)), "Color", COLORS((j-1) * size(nmax, 2)+i, :));
        hold on;

    end

    [xmin, xmax, ymin, ymax] = axis_range(fs, pow2db(abs(Pxx)), 0.05);
    plot([f0, f0], [ymin, 5], 'LineWidth', 6, 'Color', [0 0 0 0.5], 'DisplayName', sprintf('$f_{0}=%.2f$Hz', f0));
    plot([f1, f1], [ymin, 5], 'LineWidth', 6, 'Color', [0 0 0 0.5], 'DisplayName', sprintf('$f_{1}=%.2f$Hz', f1));
    axis([0.2, 0.5, ymin, 5]);
    title(sprintf("\\textbf{Periodogram}: Two Complex Exponentials"));
    xlabel("Frequency (Hz)");
    ylabel('Power Spectal Density (dB)');
    legend(h);
    grid on; grid minor;
    saveas(fig, sprintf("Assignment2/assets/2.1/d/complex_exponentials-%d.eps", j), "epsc");

end