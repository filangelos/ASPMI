%% init script
close all;
clear;
% environment settings
startup;

%% Ideal Magnitude Spectrum of 20Hz Sine Wave

% sinewave frequency
f0 = 20;
% frequency linspace
f = -50:0.001:50;
% magnitude spectrum
X = zeros(1, length(f));
X(abs(f)==f0) = pi;

fig1 = figure("Name", "FT Idea Sine Wave");
plot(f, X)
title("20Hz Sine Wave Spectrum");
xlabel("Frequency (Hz)");
ylabel("Magnitude");
axis([-2*f0-(f0/2) 2*f0+(f0/2) 0 3.5]);
yticks([0, 1, 2, 3]);
xticks([-2*f0, -f0, 0, f0, 2*f0]);
grid on; grid minor;
saveas(fig1, "Assignment1/assets/1.1/a/sine-ideal-spectrum.eps", "epsc");

%% Theoretical Continuous frequency DTFT Spectrum for a Windowed Sine Wave at 20 Hz

% sinewave frequency
f0 = 20;
% frequency linspace
f = -50:0.001:50;
% magnitude spectrum
X = zeros(1, length(f));
X(abs(f)==f0) = pi;

fig2 = figure("Name", "Theoretical DTFT Windowed Sine Wave");
% rectangular filter width
width = [9, 6, 3];
for w = width
    % window width
    tau = w/f0;
    % magnitude spectrum of window (rect)
    H = tau*pi*sinc(tau*f);
    % mumtiplication in time -> convolution in frequency
    Y = conv(X, H);
    % more samples, elimate extra ones
    extra = (length(Y)-length(f))/2;
    Y = Y(extra+1:end-extra);
    plot(f, abs(Y))
    hold on;
end
legend('Location','north')
legend(arrayfun(@(w) sprintf("$\\tau=\\frac{%d}{20Hz}$", w), width));
title("20Hz Windowed Sine Wave DTFT");
xlabel("Frequency (Hz)");
ylabel("Magnitude");
yticks([-1, 0, 1, 2, 3, 4, 5]);
xticks([-2*f0, -f0, 0, f0, 2*f0]);
grid on; grid minor;
saveas(fig2, "Assignment1/assets/1.1/a/dtft-theoretical-window.eps", "epsc");
