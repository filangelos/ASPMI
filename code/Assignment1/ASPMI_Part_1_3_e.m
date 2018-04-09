%% init script
close all;
clear;
% environment settings
startup;

%% Explanation using Bartlett Window

% number of window samples
N = 256;
% length of total (zero-padded) signal
K = 2.^12;

% bartlett window
w = bartlett(N)';
% FFT
W = abs(fftshift(fft([w zeros(1, K-N)])));
% periodogram
Pww = pow2db(W.^2/(N*2*pi))';
% half periodogram
Pww_half = Pww((length(Pww)/2 + 1):end, 1);
% frequency linespace
f = 0:2/K:1-1/K;

% plot half side periodogram
fig = figure("Name", "Half Periodogram");
plot(f, Pww_half, "DisplayName", "$W_{B}(w)$");
for alpha = [4 12]
    
    hold on;
    plot([alpha/N alpha/N], [-80 25], "DisplayName", sprintf("%d/N", alpha));
    
end
axis([0 0.1 -80 15]);
title(sprintf("\\textbf{Bartlett} Window: Periodogram and Zeros"));
xlabel("Normalised Frequency ($\frac{\pi\ rad}{sample}$)")
ylabel("Power Density (dB)")
grid on; grid minor;
legend("show");
saveas(fig, "Assignment1/assets/1.3/e/bartlett-zeros-alpha.eps", "epsc");