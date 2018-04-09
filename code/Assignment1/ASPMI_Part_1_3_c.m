%% init script
close all;
clear;
% environment settings
startup;

%% Periodogram against "alpha" & Resolution Threshold - Hamming Window

% given hyperparameters
% number of signal samples
N = 256;
% fundamental frequency
f0 = 0.2;
% noise std
sigma = 0;
% sin 1 coef
a1 = 1;
% sin 2 coef
a2 = 1;
% sin 1 arg
phi1 = 0;
% sin 2 arg
phi2 = 0;

% length of total (zero-padded) signal
K = 2.^12;

% alpha parameter
alpha = 0.1:0.001:2;
% recoverable
recover = zeros(1, length(alpha));

for i = 1:length(alpha)
    
    % get time series
    x = x_func(alpha(i), N, f0, sigma, a1, a2, phi1, phi2);
    % multiple with hamming window
    y = x .* hamming(N)';
    % FFT
    Y = abs(fftshift(fft([y zeros(1, K-N)])));
    % periodogram
    Pyy = pow2db(Y.^2/(N*2*pi))';
    % half periodogram
    Pyy_half = Pyy((length(Pyy)/2 + 1):end, 1);
    % frequency linespace
    f = 0:2/K:1-1/K;
    % plot one out of ten figures
    if mod(alpha(i) * 100, 10) == 0
        % plot half side periodogram
        fig = figure("Name", sprintf("Half Periodogram alpha=%.1f", alpha(i)));
        plot(f, Pyy_half);
        title(sprintf("\\textbf{Hamming} Window: Periodogram with $\\alpha=%.1f$", alpha(i)));
        xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)")
        ylabel("Power Density (dB)")
        axis([0.35 0.45 -80 20]);
        grid on; grid minor;
        saveas(fig, sprintf("Assignment1/assets/1.3/c/periodogram-hamming-example-alpha_%.1f.eps", alpha(i)), "epsc");
    end
    % find sidelobes peaks & sort them
    peaks = sort(findpeaks(mag2db(Pyy_half)), 'descend');
    % check if repeated max peaks
    if length(peaks) > 1
        % the peaks are not exactly equal
        % difinite an error value, empirically found
        e = 0.2;
        recover(:, i) = abs(peaks(1) - peaks(2)) < e;
    end

end

fig = figure("Name", "Resolution Threshold against alpha");
plot(alpha, recover);
title("\textbf{Hamming} Window: Resolution Threshold and $\alpha$");
xlabel("$\alpha$");
ylabel("Number of Peaks");
yticks([0 1]);
yticklabels([1 2]);
xticks(alpha(1):0.2:alpha(end));
[xmin, xmax, ymin, ymax] = axis_range(alpha, recover, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
saveas(fig, "Assignment1/assets/1.3/c/periodogram-hamming-resolution-threshold-alpha.eps", "epsc");