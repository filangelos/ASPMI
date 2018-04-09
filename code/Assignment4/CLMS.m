function [y, e, H] = CLMS(X, d, mu, gamma)
% CLMS	Complex Least Mean Square (CLMS) adaptive filter.
%       - X: design matrix, size(X)=[M N]
%       - d: target vector, size(d)=[1 N]
%       - mu: step size, scalar
%       - gamma: leakage coefficient, scalar
%       * y: filter output, size(y)=[1 N]
%       * e: prediction error, d(n) - y(n)
%       * H: filter weights, size(W)=[M N]
%   [y, e, H] = CLMS(X, d, mu) train CLMS filter on Xd data.
    
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
    % check if step-size is scalar
    if ~isscalar(mu)
        error("step-size parameter must be scalar");
    end
    % check if leakage coefficient is scalar
    if ~isscalar(gamma)
        error("leakage coefficient parameter must be scalar");
    end
    
    % sizes
    [M, N] = size(X);
    % filter output: init
    y = complex(zeros(size(d)));
    % prediction error: init
    e = complex(zeros(size(d)));
    % CLMS filter weights: init
    H = complex(zeros(M, N));
    
    % iterate over time
    for n=1:N
        % filter output n, y(n)
        y(n) = H(:, n)' * X(:, n);
        % prediction error n, e(n)
        e(n) = d(n) - y(n);
        % weights update rule
        H(:, n+1) = (1 - gamma * mu) * H(:, n) + mu * conj(e(n)) * X(:, n);
    end
    
    % discard first weight
    H = H(:, 2:end);
end