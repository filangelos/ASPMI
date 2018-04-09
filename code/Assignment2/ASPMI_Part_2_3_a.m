%% init script
close all;
clear;
% environment settings
startup;

%% SVD

% fetch data
pcr = load('data/PCR/PCAPCR.mat');

% SVD: noiseless matrix
S = svd(pcr.X);
% SVD: noisy matrix
Snoise = svd(pcr.Xnoise);
% root squared error of singular values
error = (S - Snoise).^2;

% figure
fig = figure("Name", "SVD for pure & noise signals");
bar([S, Snoise]);
legend(["original", "noisy"], "Location", "NorthEast");
title(sprintf("Singular Values: $\\mathbf{X}$ and $\\mathbf{X}_{noise}$"));
ylabel("Singular Values Magnitude");
xlabel("Singular Value Index");
grid on; grid minor;
saveas(fig, "Assignment2/assets/2.3/a/svd.eps", "epsc");

% figure
fig = figure("Name", "SVD squared error");
bar(error, 'FaceColor', COLORS(3, :));
title(sprintf("Singular Values: Squared Prediction Error"));
xlabel("Singular Value Index");
ylabel("Squared Error, $\|x-\hat{x}\|^{2}$");
grid on; grid minor;
saveas(fig, "Assignment2/assets/2.3/a/error.eps", "epsc");