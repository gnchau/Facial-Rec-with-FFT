% Used to shift the 0 frequency to the center
function freq = shift_freq(freq, shift)
    freq = freq - min(freq(:)); 
    freq = freq/max(freq(:));
    if shift
        freq = fftshift(freq);
    end
end