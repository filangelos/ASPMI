function [r_biased, r_unbiased, lag, Pxx_biased, Pxx_unbiased, fs] = correlation(x)

    % autocorrelation
    [r_biased, lag] = xcorr(x, 'biased');
    [r_unbiased, ~] = xcorr(x, 'unbiased');
    % shift/center ACF
    acf_biased = ifftshift(r_biased);
    acf_unbiased = ifftshift(r_unbiased);
    % PSD using FFT
    Pxx_biased = real(fftshift(fft(acf_biased))) ./ (2*pi);
    Pxx_unbiased = real(fftshift(fft(acf_unbiased))) ./ (2*pi);
    % normalised frequency
    fs = lag ./ max(lag);
    
end