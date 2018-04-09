%% init script
close all;
clear;
% environment settings
startup;

%% ANC for EEG

% fetch data
eeg = load('data/EEG_Data/EEG_Data_Assignment2.mat');

% sampling frequency
Fs = eeg.fs;
% time-series
s = eeg.POz;
% number of observations
N = length(s);
% synthetic noise
A = 1;
f0 = 50;
t = 1:N;
sigma_2 = 0.01;
sine = A * sin(2*pi*(f0/Fs)*t);
epsilon = sine + random('Normal', 0, sigma_2, 1, N);

% spectrogram parameters
K = 16382;
L = 4096;
% overlap as a percentage
overlap=0.8;

% step-size
mu = [0.1 0.001 0.005];
% model order
M = [1 5 10 25];

% figure - reference spectrogram
fig = figure("Name", sprintf("Original"));
spectrogram(s, rectwin(L), round(overlap * L), K, Fs, 'yaxis');
title(sprintf("\\textbf{EEG}: \\texttt{POz} Original Spectrogram"));
yticks(0:10:60);
ylim([0 60]);
c = colorbar;
c.Label.String = "Power (dB)";
saveas(fig, sprintf("Assignment3/assets/3.3/d/original.eps"), "epsc");

% varying model order
for i = 1:length(M)

    % ANC - data preprocessing
    [X, ~] = XyDelta(epsilon, 1, M(i));
    d = [0 s(1:end-1)'];
    
    % varying step-size
    for j = 1:length(mu)
    
        % ANC - LMS
        eta_hat = LMS(X, d, mu(j), 0);
        x_hat = d - eta_hat;
        
        % figure - ANC spectrogram
        fig = figure("Name", sprintf("M_%d and mu_%.3f", M(i), mu(j)));
        spectrogram(x_hat, rectwin(L), round(overlap * L), K, Fs, 'yaxis');
        title(sprintf("\\textbf{EEG}: \\texttt{POz} \\textbf{ANC} Spectrogram\n$\\mathbf{M=%d}$ and $\\mathbf{\\mu=%.3f}$", M(i), mu(j)));
        yticks(0:10:60);
        ylim([0 60]);
        c = colorbar;
        c.Label.String = "Power (dB)";
        saveas(fig, sprintf("Assignment3/assets/3.3/d/M_%d-mu_%.3f.eps", M(i), mu(j)), "epsc");
    end
    
end

% best parameters
M = 10;
mu = 0.001;

% ANC - data preprocessing
[X, ~] = XyDelta(epsilon, 1, M);
d = [0 s(1:end-1)'];

% ANC - LMS
eta_hat = LMS(X, d, mu, 0);
x_hat = d - eta_hat;

% reference
[Pxx, wx] = periodogram(s, rectwin(N), K, Fs, 'onesided');
% denoised
[Pzz, wz] = periodogram(x_hat, rectwin(N), K, Fs, 'onesided');

% figure - periodogram
fig = figure("Name", sprintf("Periodogram"));
plot(wx, pow2db(Pxx), "DisplayName", "\texttt{POz}");
hold on;
plot(wz, pow2db(Pzz), "DisplayName", "ANC");
title(sprintf("\\textbf{EEG}: \\texttt{POz} Original and \\textbf{ANC} Periodogram"));
xlabel("Frequency (Hz)");
ylabel("Power Density (dB)");
xticks(0:10:60);
grid on; grid minor;
xlim([0 60]);
legend("show", "Location", "SouthWest");
saveas(fig, sprintf("Assignment3/assets/3.3/d/periodogram.eps"), "epsc");

% figure - periodogram error
fig = figure("Name", sprintf("Periodogram"));
plot(wx, pow2db(abs(Pxx - Pzz)), "Color", COLORS(3, :))
title(sprintf("\\textbf{EEG}: \\texttt{POz} \\textbf{ANC} Periodogram Error"));
xlabel("Frequency (Hz)");
ylabel("Power Density (dB)");
xticks(0:10:60);
grid on; grid minor;
xlim([0 60]);
saveas(fig, sprintf("Assignment3/assets/3.3/d/periodogram-error.eps"), "epsc");