function [y, e, W] = GASS(X, d, mu_0, rho, gamma, algo, alpha)
% GASS	Gradient Adaptive Step-Size (GASS) Least Mean Square (LMS) adaptive filter.
%       - X: design matrix, size(X)=[M N]
%       - d: target vector, size(d)=[1 N]
%       - mu_0: initial step size, scalar
%       - rho: learning rate, scalar
%       - gamma: leakage coefficient, scalar
%       - algo: algorithm name, string from
%               {'benvenist', 'ang_farhang', 'matthews_xie'}
%       - alpha: Ang & Farhang learning parameter, scalar
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
    % check if algorithm type is string
    if ~isstring(algo)
        error("algorithm type parameter must be string");
    end
    % check if Ang & Farhang learning parameter is scalar
    if ~isscalar(alpha)
        error("Ang & Farhang learning parameter must be scalar");
    end

    % sizes
    [M, N] = size(X);
    % filter output: init
    y = zeros(size(d));
    % prediction error: init
    e = zeros(size(d));
    % GASS filter weights: init
    W = zeros(M, N+1);
    % step-size: init
    mu = zeros(1, N+1);
    mu(1) = mu_0;
    % phi term init:
    phi = zeros(M, N+1);
    
    % iterate over time
    for n=1:N
        % filter output n, y(n)
        y(n) = W(:, n)' * X(:, n);
        % prediction error n, e(n)
        e(n) = d(n) - y(n);
        % weights update rule
        W(:, n+1) = (1 - mu(n) * gamma) * W(:, n) + mu(n) * e(n) * X(:, n);
        % step-size update rule
        mu(n+1) = mu(n) + rho * e(n) * X(:, n)' * phi(:, n);
        % update phi
        switch algo
            case "benvenist"
                phi(:, n+1) = (eye(M) - mu(n) * X(:, n) * X(:, n)') * phi(:, n) + e(n) * X(:, n);
            case "ang_farhang"
                phi(:, n+1) = alpha * phi(:, n) + e(n) * X(:, n);
            case "matthews_xie"
                phi(:, n+1) = e(n) * X(:, n);
        end
    end
    
    % discard first weight
    W = W(:, 2:end);
end