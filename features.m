function [f_abs, f_real, f_imag] = features(image, normalize, shift)
    % Compute the 2D FFT
    f=fft2(image); 
    
    % Compute magnitude of complex numbers using abs.
    f_abs = abs(f);    
    if normalize
        f_abs = shift_freq_display(f_abs, shift);   
    end

    f_real = real(f); 
    if normalize
        f_real = shift_freq(f_real, shift);     
    end

    f_imag = imag(f);
    if normalize
        f_imag = shift_freq(f_imag, shift); 
    end
end