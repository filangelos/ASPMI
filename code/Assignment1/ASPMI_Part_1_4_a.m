%% init script
close all;
clear;
% environment settings
startup;

%% Sunspots Data Periodogram

load sunspot.dat

% Hypeparameters
%
% length of total (zero-padded) signal
K = 2.^12;

% raw sunspots
x = sunspot(:, 2);
t = sunspot(:, 1);
% number of samples
N = length(x);

% preprocessing
z = detrend(x-mean(x));

% log preprocessed signal
l_ = log(x + eps);
l = l_ - mean(l_);

% time series plot
fig = figure("Name", "Sunspots Time Seires");
plot(t, x);
hold on;
g = plot(t, z);
hold on;
plot(t, l);
title("Sunpots Time Series");
xlabel("Time (years)");
ylabel("Number of Sunspots");
legend(["raw sunspots", "$\mathtt{mean}$ \& $\mathtt{detrend}$", "$\mathtt{log}$ \& $\mathtt{mean}$"]);
% ylim([-20 60]);
grid on; grid minor;
saveas(fig, "Assignment1/assets/1.4/a/sunspots-raw.eps", "epsc");

% windows used for periodogram method
windows = [ones(N, 1), chebwin(N)];
% legend labels
labels = ["Rectangular", "Chebyshev"]';

for i = 1:size(windows, 2)
    
    % window function
    h = windows(:, i);
    % window name
    label = labels(i, 1);
    
    % PSD
    %
    % raw version
    Y = abs(fftshift(fft([(x .* h)' zeros(1, K-N)])));
    Pyy = pow2db(Y.^2 / (N * 2 * pi))';
    % one-side periodogram
    Pyy_one = Pyy((length(Pyy)/2 + 1):end, 1);

    % preprocessed
    Z = abs(fftshift(fft([(z .* h)' zeros(1, K-N)])));
    Pzz = pow2db(Z.^2 / (N * 2 * pi))';
    % one-side periodogram
    Pzz_one = Pzz((length(Pzz)/2 + 1):end, 1);
    
    % log
    L = abs(fftshift(fft([(l .* h)' zeros(1, K-N)])));
    Pll = pow2db(L.^2 / (N * 2 * pi))';
    % one-side periodogram
    Pll_one = Pll((length(Pll)/2 + 1):end, 1);

    % frequency linespace
    f = 0:2/K:1-1/K;
    
    % figure object
    fig = figure("Name", sprintf("Sunspots Periodogram %s", label));
    plot(f, Pyy_one);
    hold on;
    g = plot(f, Pzz_one);
    hold on;
    plot(f, Pll_one);
    title(sprintf("\\textbf{%s} Window: Sunpots Periodogram ", label));
    xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)");
    ylabel("Power Density (dB)");
    legend(["raw sunspots", "$\mathtt{mean}$ \& $\mathtt{detrend}$", "$\mathtt{log}$ \& $\mathtt{mean}$"]);
    ylim([-20 60]);
    grid on; grid minor;
    saveas(fig, sprintf("Assignment1/assets/1.4/a/sunspots-%s.eps", label), "epsc");
    
end








