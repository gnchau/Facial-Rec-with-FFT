function y = shift_freq_display(f_abs, shift)   
    f_abs = log(f_abs);
    f_abs = f_abs - min(f_abs(:));
    if shift
        f_abs = fftshift(f_abs);
    end
    % Scale to [0, 1]
    y = f_abs/max(f_abs(:));
end