%% init script
close all;
clear;
% environment settings
startup;

%% EEG Standard Periodogram

% fetch data
eeg = load('data/EEG_Data/EEG_Data_Assignment1.mat');

% sampling frequency
Fs = eeg.fs;
% number of observations
N = length(eeg.POz);
% length of DFT: 5 DFT samples per Hz
K = Fs * 10;
% duration of each segment
dt = [10 5 1];

% centered data
POz = eeg.POz - mean(eeg.POz);

% Periodograms
%
% standard
[Pxx, wx] = periodogram(POz, rectwin(N), K, Fs, 'onesided');
% figure
fig1 = figure("Name", "EEG Standard Periodogram");
plot(wx, pow2db(Pxx), "Color", COLORS(6, :));
title("\textbf{Rectangular} Window: EEG Periodogram");
xlabel("Frequency (Hz)");
ylabel("Power Density (dB)");
xticks(0:10:60);
grid on; grid minor;
axis([0 60 -150 -100]);
saveas(fig1, "Assignment1/assets/1.4/b/eeg-periodogram-standard.eps", "epsc");

% Bartlett Averaged Periodogram
fig2 = figure("Name", "EEG Standard Periodogram");
for i = 1:length(dt)

    % segment samples length
    L = Fs * dt(i);
    % periodogram
    [Pzz, wz]= pwelch(POz, rectwin(L), 0, K, Fs, 'onesided');
    % figure
    plot(wx, pow2db(Pzz), "DisplayName", sprintf("$\\Delta t = %d s$", dt(i)));
    hold on;
    
end
title("\textbf{Bartlett} Method: EEG Periodogram");
xlabel("Frequency (Hz)");
ylabel("Power Density (dB)");
xticks(0:10:60);
grid on; grid minor;
axis([0 60 -135 -90]);
legend("show", "Location", "north");
saveas(fig2, "Assignment1/assets/1.4/b/eeg-periodogram-averaged-bartlett.eps", "epsc");

for i = 1:length(dt)

    fig3 = figure("Name", sprintf("EEG Standard vs Bartlett Periodogram dt=%d", dt(i)));
    % segment samples length
    L = Fs * dt(i);
    % periodogram
    [Pzz, wz]= pwelch(POz, rectwin(L), 0, K, Fs, 'onesided');
    % figure
    plot(wx, pow2db(Pxx), "Color", COLORS(6, :), "DisplayName", "Standard");
    hold on;
    plot(wx, pow2db(Pzz), "Color", COLORS(i, :), "DisplayName", sprintf("$\\Delta t = %d s$", dt(i)));
    title(sprintf("EEG Periodograms"));
    xlabel("Frequency (Hz)");
    ylabel("Power Density (dB)");
    xticks(0:10:60);
    grid on; grid minor;
    axis([0 60 -135 -90]);
    legend("show", "Location", "North");
    saveas(fig3, sprintf("Assignment1/assets/1.4/b/eeg-periodogram-averaged-bartlett-dt_%d.eps", dt(i)), "epsc");
    
end
