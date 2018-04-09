function [X, y] = XyDelta(s, Delta, M)
% XY	Convert time series to supervised learning (xi, yi) pairs, for ALE.
%       - s: input signal, size(s)=[1 N] or size(s)=[N 1]
%       - Delta: delay, scalar
%       - M: number of lags (AR model order), scalar
%       * X: design matrix, size(X)=[M N-1]
%       * y: target vector, size(d)=[1 N-1]
%   [X, y] = XyDelta(s, Delta, M) splits s to AR(M) features-target pairs,
%   with Delta delays.

    % check if input signal is 1D
    if ~isvector(s)
        error("input signal must be 1D");
    end
    % check if delay is scalar
    if ~isscalar(Delta)
        error("delay parameter must be scalar");
    end
    % check if lags is scalar
    if ~isscalar(M)
        error("lags parameter must be scalar");
    end
    
    % turn to column vector
    s = reshape(s, [], 1);
    N = size(s, 1);
    % append Delta+M-1 zeros
    s = [zeros(Delta+M-1, 1); s];
    % design matrix: init
    X = zeros(M, N-1);
    % target vector: init
    y = zeros(1, N-1);
    
    % rolling (overlapping) windows of size M
    for n=1:N
        % feature vector n, x(n)
        X(:, n) = s(n+(M-1):-1:n);
        % target value n, y(n)
        y(n) = s(n+(Delta+M-1));
    end
    
end
