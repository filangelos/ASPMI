%% init script
close all;
clear;
% environment settings
startup;

%% low-rank approximation

% fetch data
pcr = load('data/PCR/PCAPCR.mat');

% data dimensions
[m, n] = size(pcr.Xnoise);

% SVD
[Unoise, Snoise, Vnoise] = svd(pcr.Xnoise);

% rank of low-rank approximation
r = 1:10;

% Frobenius Norm: (Xnoise_tilda - X)^{F}
f_norm = zeros(length(r), 1);

% power of remaining singular values
power = zeros(length(r), 1);

for i = 1:length(r)

    % approximation
    Xnoise_tilda = Unoise(1:m, 1:r(i)) * Snoise(1:r(i), 1:r(i)) * Vnoise(1:n, 1:r(i))';

    % error
    f_norm(i) = norm(Xnoise_tilda-pcr.X, 'fro');
    
    % singular values
    sigma = diag(Snoise);
    
    % squared sum of singular values
    power(i) = sum(sum(sigma(r(i)+1:end).^2));

end

% figure
fig = figure("Name", "low-rank approximation");
plot(r, f_norm);
% hold on;
% plot(power);
title("Low Rank Approximation Error");
xlabel("Low-Rank Approximation, $r$");
ylabel("$\|\mathbf{X} - \tilde{\mathbf{X}}_{noise}\|_{F}$");
xticks(r);
[xmin, xmax, ymin, ymax] = axis_range(r, f_norm, 0.05);
axis([xmin, xmax, ymin, ymax]);
grid on; grid minor;
saveas(fig, "Assignment2/assets/2.3/b/low-rank_X.eps", "epsc");