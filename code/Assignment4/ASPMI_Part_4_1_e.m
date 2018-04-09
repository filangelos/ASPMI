%% init script
close all;
clear;
% environment settings
startup;

%% Three Phase Power Systems: (A)CLMS

% number of phases
m = 3;
% number of samples
N = 1000;
% time index
t = 1:N;

% nominal frequency
f0 = 50;
% sampling frequency
fs = 5000;
% initial phase
phi = [0; 2*pi/3; -2*pi/3];

% (A)CLMS parameters
mu = 0.05;
M = 1;
gamma = 0;

%%% Balances Complex Voltages

% voltage amplitudes
V = ones(m, 1);
% voltage phase shift
Delta = zeros(m, 1);

% voltages
v = V .* cos(2 * pi * (f0 / fs) * t + Delta + phi);
% Clarke voltages
u = clarke(v);

% data preprocessing
[X, d] = XyDelta(u, 1, M);

% CLMS
[~, error_CLMS, h_CLMS] =  CLMS(X, d, mu, gamma);
fo_CLMS = fs/(2*pi) * atan( imag(h_CLMS) ./ real(h_CLMS) );
% ACLMS
[~, error_ACLMS, h_ACLMS, g_ACLMS] = ACLMS(X, d, mu);
fo_ACLMS = fs/(2*pi) * atan( sqrt( imag(h_ACLMS).^2 - abs(g_ACLMS).^2 ) ./ real(h_ACLMS) );

% figure - error curves
fig = figure("Name", sprintf("Balanced Error"));
plot(pow2db(abs(error_CLMS).^2), "DisplayName", "CLMS")
hold on
plot(pow2db(abs(error_ACLMS).^2), "DisplayName", "ACLMS")
title(sprintf("\\textbf{Complex Voltage}: Error Curves"));
xlabel("Time Index, $t$");
ylabel("Squared Error (dB)");
legend("show")
grid on; grid minor;
saveas(fig, sprintf("Assignment4/assets/4.1/e/balanced_error.eps"), "epsc");

% figure - frequency estimation
fig = figure("Name", sprintf("Balanced Frequency"));
plot(fo_CLMS, "DisplayName", "CLMS")
hold on;
plot(abs(fo_ACLMS), "DisplayName", "ACLMS")
hold on
plot([0 N], [50 50], "DisplayName", "$50\ Hz$", "LineStyle", "--", "Color", "black");
title(sprintf("\\textbf{Complex Voltage}: Nominal Frequency Estimation"));
xlabel("Time Index, $t$");
ylabel("Frequency, $\hat{f}_{o}$");
legend("show")
ylim([25 100]);
grid on; grid minor;
saveas(fig, sprintf("Assignment4/assets/4.1/e/balanced_frequency.eps"), "epsc");

%%% Unbalanced Complex Voltages

% voltage amplitudes
V = [0.1; 1; 1.9];
% voltage phase shift
Delta = [0; 2; 0.5];

% voltages
v = V .* cos(2 * pi * (f0 / fs) * t + Delta + phi);
% Clarke voltages
u = clarke(v);

% data preprocessing
[X, d] = XyDelta(u, 1, M);

% CLMS
[~, error_CLMS, h_CLMS] =  CLMS(X, d, mu, gamma);
fo_CLMS = fs/(2*pi) * atan( imag(h_CLMS) ./ real(h_CLMS) );
% ACLMS
[~, error_ACLMS, h_ACLMS, g_ACLMS] = ACLMS(X, d, mu);
fo_ACLMS = fs/(2*pi) * atan( sqrt( imag(h_ACLMS).^2 - abs(g_ACLMS).^2 ) ./ real(h_ACLMS) );

% figure - error curves
fig = figure("Name", sprintf("Unbalanced Error"));
plot(pow2db(abs(error_CLMS).^2), "DisplayName", "CLMS")
hold on
plot(pow2db(abs(error_ACLMS).^2), "DisplayName", "ACLMS")
title(sprintf("\\textbf{Complex Voltage}: Error Curves"));
xlabel("Time Index, $t$");
ylabel("Squared Error (dB)");
legend("show")
grid on; grid minor;
saveas(fig, sprintf("Assignment4/assets/4.1/e/unbalanced_error.eps"), "epsc");

% figure - frequency estimation
fig = figure("Name", sprintf("Unbalanced Frequency"));
plot(fo_CLMS, "DisplayName", "CLMS")
hold on;
plot(abs(fo_ACLMS), "DisplayName", "ACLMS")
hold on
plot([0 N], [50 50], "DisplayName", "$50\ Hz$", "LineStyle", "--", "Color", "black");
title(sprintf("\\textbf{Complex Voltage}: Nominal Frequency Estimation"));
xlabel("Time Index, $t$");
ylabel("Frequency, $\hat{f}_{o}$");
legend("show")
ylim([0 100]);
grid on; grid minor;
saveas(fig, sprintf("Assignment4/assets/4.1/e/unbalanced_frequency.eps"), "epsc");
