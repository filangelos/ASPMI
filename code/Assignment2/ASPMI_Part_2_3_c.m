%% init script
close all;
clear;
% environment settings
startup;

%% PCR vs OLS

% fetch data
pcr = load('data/PCR/PCAPCR.mat');

% -- OLS --
% weigts
B_OLS = pcr.Xnoise' * pcr.Xnoise \ pcr.Xnoise' * pcr.Y;
% targets
Y_OLS = pcr.Xnoise * B_OLS;
Ytest_OLS = pcr.Xtest * B_OLS;
% errors
e_OLS_train = norm(pcr.Y - Y_OLS, 'fro');
e_OLS_test = norm(pcr.Ytest - Ytest_OLS, 'fro');

% -- PCR --
% data dimensions
[m, n] = size(pcr.Xnoise);

% rank of low-rank approximation
r = 1:10;

% errors
e_PCR_train = zeros(length(r), 1);
e_PCR_test = zeros(length(r), 1);

for i = 1:length(r)
    
    % SVD
    [Unoise, Snoise, Vnoise] = svd(pcr.Xnoise);
    [Utest, Stest, Vtest] = svd(pcr.Xtest);
    
    % approximations
    Xnoise_tilda = Unoise(1:m, 1:r(i)) * Snoise(1:r(i), 1:r(i)) * Vnoise(1:n, 1:r(i))';
    Xtest_tilda = Utest(1:m, 1:r(i)) * Stest(1:r(i), 1:r(i)) * Vtest(1:n, 1:r(i))';

    % weights
    B_PCR = Vnoise(1:n, 1:r(i)) / Snoise(1:r(i), 1:r(i)) * Unoise(1:m, 1:r(i))' * pcr.Y;
    % targets
    Y_PCR = Xnoise_tilda * B_PCR;
    Ytest_PCR = Xtest_tilda * B_PCR;
    % errors
    e_PCR_train(i) = norm(pcr.Y - Y_PCR, 'fro');
    e_PCR_test(i) = norm(pcr.Ytest - Ytest_PCR, 'fro');
    
end

% figure
fig_train = figure("Name", "OLS vs PCR: Training Error");
plot(r, e_PCR_train, "DisplayName", "PCR");
hold on;
plot([r(1) r(end)], [e_OLS_train e_OLS_train], "LineStyle", "--", "DisplayName", "OLS")
title("\textbf{OLS \& PCR}: Training Error");
xlabel("Low-Rank Approximation, $r$");
ylabel("$\|\textbf{Y} - \tilde{\textbf{Y}}\|_{F}$");
xticks(r);
[xmin, xmax, ymin, ymax] = axis_range(r, e_PCR_train, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
legend("show");
saveas(fig_train, "Assignment2/assets/2.3/c/ols_vs_pcr_train.eps", "epsc");


% figure
fig_test= figure("Name", "OLS vs PCR: Testing Error");
plot(r, e_PCR_test, "DisplayName", "PCR");
hold on;
plot([r(1) r(end)], [e_OLS_test e_OLS_test], "LineStyle", "--", "DisplayName", "OLS")
title("\textbf{OLS \& PCR}: Testing Error");
xlabel("Low-Rank Approximation, $r$");
ylabel("$\|\textbf{Y}_{test} - \tilde{\textbf{Y}}_{test}\|_{F}$");
xticks(r);
[xmin, xmax, ymin, ymax] = axis_range(r, e_PCR_test, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
legend("show");
saveas(fig_test, "Assignment2/assets/2.3/c/ols_vs_pcr_test.eps", "epsc");