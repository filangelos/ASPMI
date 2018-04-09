function rho = circularity(x)

    rho = abs(mean((x).^2)/mean(abs(x).^2));

end