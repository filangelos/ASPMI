%% init script
close all;
clear;
% environment settings
startup;

%% Three Phase Power Systems: Circularity

% number of phases
m = 3;
% number of samples
N = 1000;
% time index
t = 1:N;

% nominal frequency
f0 = 50;
% sampling frequency
fs = 10000;
% initial phase
phi = [0; 2*pi/3; -2*pi/3];

%%% Balances Complex Voltages

% voltage amplitudes
V = ones(m, 1);
% voltage phase shift
Delta = zeros(m, 1);

% voltages
v = V .* cos(2 * pi * (f0 / fs) * t + Delta + phi);
% Clarke voltages
u = clarke(v);

fig = figure("Name", sprintf("Balanced"));
scatter(real(u), imag(u), 30, COLORS(1, :), 'filled');
title(sprintf("\\textbf{Complex Voltage}: Balanced, $\\mathbf{\\rho = %.3f}$", circularity(u)));
xlabel("Real Part, $\Re$");
ylabel("Imaginary Part, $\Im$");
grid on; grid minor;
axis([-2 2 -2 2]);
saveas(fig, sprintf("Assignment4/assets/4.1/c/balanced.eps"), "epsc");

%%% Unbalanced Complex Voltages

% voltage amplitudes
V = [0.1; 1; 1.9];
% voltage phase shift
Delta = [0; 2; 0.5];

% voltages
v = V .* cos(2 * pi * (f0 / fs) * t + Delta + phi);
% Clarke voltages
u = clarke(v);

fig = figure("Name", sprintf("Unbalanced"));
scatter(real(u), imag(u), 30, COLORS(2, :), 'filled');
title(sprintf("\\textbf{Complex Voltage}: Unbalanced Phase \\& Magnitude, $\\mathbf{\\rho = %.3f}$ \n$\\Delta_{b} = %d, \\Delta_{c} = %.1f$ and $V_{a} = %.1f, V_{c} = %.1f$", circularity(u), Delta(2), Delta(3), V(1), V(3)));
xlabel("Real Part, $\Re$");
ylabel("Imaginary Part, $\Im$");
grid on; grid minor;
axis([-2 2 -2 2]);
saveas(fig, sprintf("Assignment4/assets/4.1/c/unbalanced.eps"), "epsc");

%%% Unbalanced Complex Voltages - Magnitude

% voltage phase shift
Delta = zeros(m, 1);

fig = figure("Name", sprintf("Unbalanced Magnitude"));

for dv = [0.25 0.4 0.6 0.8]

    % voltage amplitudes
    V = ones(m, 1) + [-dv; 0; +dv];
    % voltages
    v = V .* cos(2 * pi * (f0 / fs) * t + Delta + phi);
    % Clarke voltages
    u = clarke(v);
    scatter(real(u), imag(u), 30, 'filled', "DisplayName", sprintf("$V_{a} = %.1f$", V(1)));
    hold on;
    
end

title(sprintf("\\textbf{Complex Voltage}: Unbalanced Magnitude"));
xlabel("Real Part, $\Re$");
ylabel("Imaginary Part, $\Im$");
grid on; grid minor;
lgd = legend("show");
lgd.NumColumns = 4;
axis([-2 2 -2 2]);
saveas(fig, sprintf("Assignment4/assets/4.1/c/unbalanced_magnitude.eps"), "epsc");

%%% Unbalanced Complex Voltages - Angle

% voltage amplitudes
V = ones(m, 1);

fig = figure("Name", sprintf("Unbalanced Angle"));

for dD = [0.25 0.4 0.6 0.8]

    % voltage phase shift
    Delta = zeros(m, 1) + [0; dD; -dD];
    % voltages
    v = V .* cos(2 * pi * (f0 / fs) * t + Delta + phi);
    % Clarke voltages
    u = clarke(v);
    scatter(real(u), imag(u), 30, 'filled', "DisplayName", sprintf("$\\Delta_{b} = %.1f$", dD));
    hold on;
    
end

title(sprintf("\\textbf{Complex Voltage}: Unbalanced Angle"));
xlabel("Real Part, $\Re$");
ylabel("Imaginary Part, $\Im$");
grid on; grid minor;
lgd = legend("show");
lgd.NumColumns = 4;
axis([-2 2 -2 2]);
saveas(fig, sprintf("Assignment4/assets/4.1/c/unbalanced_angle.eps"), "epsc");