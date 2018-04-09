function [y, e, W] = NLMS(X, d, mu_0, gamma, rho)
% NLMS	Normalised Least Mean Square (NLMS) adaptive filter.
%       - X: design matrix, size(X)=[M N]
%       - d: target vector, size(d)=[1 N]
%       - mu_0: initial step size, scalar
%       - rho: learning rate, scalar
%       - gamma: leakage coefficient, scalar
%       * y: filter output, size(y)=[1 N]
%       * e: prediction error, d(n) - y(n)
%       * W: filter weights, size(W)=[M N]
%   [y, e, W] = GASS(X, d, mu_0, rho, gamma, algo, alpha) train Gass filter on Xd data.

    % check if design matrix is 2D
    if ~ismatrix(X)
        error("design matrix must be 2D");
    end
    % check if target vector is 1D
    if ~ismatrix(d)
        error("target vector must be 1D");
    end
    % check X-d size consistency
    if size(X, 2) ~= size(d, 2)
        error("design matrix and target vector sizes are inconsistent");
    end
    % check if initial step-size is scalar
    if ~isscalar(mu_0)
        error("initial step-size parameter must be scalar");
    end
    % check if learning rate is scalar
    if ~isscalar(rho)
        error("learning rate parameter must be scalar");
    end
    % check if leakage coefficient is scalar
    if ~isscalar(gamma)
        error("leakage coefficient parameter must be scalar");
    end

    % sizes
    [M, N] = size(X);
    % filter output: init
    y = zeros(size(d));
    % prediction error: init
    e = zeros(size(d));
    % NLMS filter weights: init
    W = zeros(M, N+1);
    % regularization factor: 1 / mu
    epsilon = ones(N+1, 1) ./ mu_0;
    
    % iterate over time
    for n=1:N
        % filter output n, y(n)
        y(n) = W(:, n)' * X(:, n);
        % prediction error n, e(n)
        e(n) = d(n) - y(n);
        % weights update rule
        W(:, n+1) = (1 - 1/epsilon(n) * gamma) * W(:, n) + (1 / (epsilon(n) + X(:, n)' * X(:, n))) * e(n) * X(:, n);
        if n > 1
            % epsilon update rule
            epsilon(n+1) = epsilon(n) - rho * mu_0 * ((e(n) * e(n-1) * X(:, n)' * X(:, n-1)) / (epsilon(n-1) + X(:, n)' * X(:, n))^2);
        end
    end
    
    % discard first weight
    W = W(:, 2:end);
end