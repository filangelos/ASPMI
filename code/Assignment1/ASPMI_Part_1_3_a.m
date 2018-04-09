%% init script
close all;
clear;
% environment settings
startup;

%% Bartlett Window: 3dB width & sidelobes peak against N

% zero-pad window to increase frequency resolution
K = 2.^12;
% Bartlett window points number
N = 2.^(3:10);
% window width
I = zeros(1,length(N));
% sidelobes peak
P = zeros(1,length(N));

for i = 1:length(N)
    
    % N-point Bartlett window
    w = bartlett(N(i));
    % FFT of window
    W = abs(fftshift(fft([w' zeros(1, K-N(i))])));
    % normalisation
    W_norm = W./max(W);
    % frequency linespace
    f = -1:2/K:1-1/K;
    % generate curve of threshold
    % needed by InterX function
    % shipped with "Curve intersections"
    % contributors package
    x = ones(1,length(f))./sqrt(2);
    % plot figures
    fig_lin = figure("Name", sprintf("Linear Bartlett %d", N(i)));
    plot(f, W_norm, "DisplayName", "$W_{B}(w)$");
    hold on;
    plot(f, x, "DisplayName", "$1/\sqrt{2}$");
    title(sprintf("Bartlett $\\mathbf{N=%d}$: Linear Scaling", N(i)));
    xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)");
    ylabel("Magnitude, $W_{B}(w)$");
    legend("show");
    [xmin, xmax, ymin, ~] = axis_range(f, W_norm, 0.05);
    axis([xmin, xmax, ymin, 1.1]);
    grid on; grid minor;
    saveas(fig_lin, sprintf("Assignment1/assets/1.3/a/bartlett-linear-N_%d.eps", N(i)), "epsc");
    fig_log = figure("Name", sprintf("Log Bartlett %d", N(i)));
    plot(f, mag2db(W_norm), "DisplayName", "$W_{B}(w)$");
    hold on;
    plot(f, mag2db(x), "DisplayName", "$-3dB$");
    title(sprintf("Bartlett $\\mathbf{N=%d}$: Logarithmic Scaling", N(i)));
    xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)");
    ylabel("Magnitude (dB), $W_{B}(w)$");
    legend("show");
    [xmin, xmax, ymin, ~] = axis_range(f, mag2db(W_norm), 0.05);
    axis([xmin, xmax, ymin, 11]);
    grid on; grid minor;
    saveas(fig_log, sprintf("Assignment1/assets/1.3/a/bartlett-log-N_%d.eps", N(i)), "epsc");
    % get intersections
    j = InterX([f; mag2db(W_norm)], [f; mag2db(x)]);
    % width = arg(3db) - arg(max)
    % width = j(:, 1) - 0 = j(:, 1)
    I(:,i) = j(1, 2);
    % find sidelobes peaks & sort them
    peaks = sort(findpeaks(mag2db(W)), 'descend');
    % first side lobe => second lobe
    P(:, i) = peaks(2) - peaks(1);

end

% 3dB width vs N figure
fig1 = figure("Name", "Bartlett Window width against N");
plot(N, I, '.-');
title("Empirical 3dB against N");
xlabel("Length of Window, $N$");
ylabel({"Window Width ($\frac{\pi\ rad}{sample}$)"});
[xmin, xmax, ymin, ymax] = axis_range(N, I, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
saveas(fig1, "Assignment1/assets/1.3/a/bartlett-3db-vs-N.eps", "epsc");

% 3dB width vs 1/N figure
fig2 = figure("Name", "Bartlett Window width against 1/N");
plot(1./N, I, '.-');
title("Proportional 3dB Width to $\frac{1}{N}$");
xlabel("Inverse of Length of Window, $\frac{1}{N}$");
ylabel({"Window Width ($\frac{\pi\ rad}{sample}$)"});
[xmin, xmax, ymin, ymax] = axis_range(1./N, I, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
saveas(fig2, "Assignment1/assets/1.3/a/bartlett-3db-vs-1_over_N.eps", "epsc");

% sidelobes peak vs N figure
fig3 = figure("Name", "Bartlett Window sidelobes peak against N, Linear");
plot(N, db2mag(P), '.-');
title("Sidelobes Peak against $N$");
xlabel("Length of Window, $N$");
ylabel({"Sidelobes Peak"});
[xmin, xmax, ymin, ymax] = axis_range(N, db2mag(P), 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
saveas(fig3, "Assignment1/assets/1.3/a/bartlett-3db-peak-vs-N-linear.eps", "epsc");

% sidelobes peak vs N figure
fig4 = figure("Name", "Bartlett Window sidelobes peak against N, Logarithmic");
plot(N, P, '.-');
title("Sidelobes Peak against $N$");
xlabel("Length of Window, $N$");
ylabel({"Sidelobes Peak (dB)"});
[xmin, xmax, ymin, ymax] = axis_range(N, P, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
saveas(fig4, "Assignment1/assets/1.3/a/bartlett-3db-peak-vs-N-log.eps", "epsc");

