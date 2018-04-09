%% init script
close all;
clear;
% environment settings
startup;

%% FM: aryule

% number of samples
N = 1500;
% time index
t = 1:N;
% sampling frequency
fs = 1500;

% noise
sigma_2 = 0.05;
eta = wgn(N, 1, pow2db(0.05), 'complex');

% frequency
f = arrayfun(@frequency, t)';
% phase
phi = cumtrapz(f);

% figure - frequency
fig = figure("Name", sprintf("Frequency"));
plot(t, f)
title(sprintf("\\textbf{FM}: Frequency, $f(n)$"));
xlabel("Time Index, $n$");
ylabel("Frequency (Hz)");
grid on; grid minor;
[xmin, xmax, ymin, ymax] = axis_range(t, f, 0.05);
axis([xmin, xmax, ymin, ymax]);
saveas(fig, sprintf("Assignment4/assets/4.2/a/frequency.eps"), "epsc");

% figure - phase
fig = figure("Name", sprintf("Phase"));
plot(t, wrapTo2Pi(phi), "Color", COLORS(2, :))
title(sprintf("\\textbf{FM}: Phase, $\\phi(n)$"));
xlabel("Time Index, $n$");
ylabel("Angle (rad)");
grid on; grid minor;
[~, ~, ymin, ymax] = axis_range(t, wrapTo2Pi(phi), 0.05);
axis([0, 500, ymin, ymax]);
saveas(fig, sprintf("Assignment4/assets/4.2/a/phase.eps"), "epsc");

% signal
y = exp(1j * (2 * pi * phi / fs)) + eta;

for p = [1 5 10]

    % AR(p)
    a = aryule(y, p);
    % power density estimate
    [h, w] = freqz(1, a, N, fs);
    
    % psd
    psd = mag2db(abs(h));

    % figure - AR(p)
    fig = figure("Name", sprintf("AR(%d)", p));
    plot(w, psd)
    title(sprintf("\\textbf{FM Complete}: AR(%d) using \\texttt{aryule}", p));
    xlabel("Freuqncy (Hz)");
    ylabel("Power Spectral Density (dB)");
    grid on; grid minor;
    [xmin, xmax, ymin, ymax] = axis_range(w, psd, 0.05);
    axis([xmin, xmax, ymin, ymax]);
    saveas(fig, sprintf("Assignment4/assets/4.2/a/complete_aryule_%d.eps", p), "epsc");

end

for i = 1:3

    for p = [1]
        
        % start index
        start = 1 + (i-1)*500;

        % AR(p)
        a = aryule(y(start:start+499), p);
        % power density estimate
        [h, w] = freqz(1, a, N, fs);

        % psd
        psd = mag2db(abs(h));

        % figure - AR(p)
        fig = figure("Name", sprintf("AR(%d)", p));
        plot(w, psd, "Color", COLORS(i, :))
        title(sprintf("\\textbf{FM Batch %d}: AR(%d) using \\texttt{aryule}", i, p));
        xlabel("Freuqncy (Hz)");
        ylabel("Power Spectral Density (dB)");
        grid on; grid minor;
        [xmin, xmax, ymin, ymax] = axis_range(w, psd, 0.05);
        axis([xmin, xmax, ymin, ymax]);
        saveas(fig, sprintf("Assignment4/assets/4.2/a/minibatch_%d_aryule_%d.eps", i, p), "epsc");

    end

end