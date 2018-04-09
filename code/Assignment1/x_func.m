function x = x_func(alpha, N, f0, sigma, a1, a2, phi1, phi2)
    n = 0:1:N-1;
    x = a1*sin(f0*2*pi*n+ones(1,N)*phi1)+a2*sin((f0+alpha/N)*2*pi*n+ones(1,N)*phi2)+randn(1,N)*sqrt(sigma);
end