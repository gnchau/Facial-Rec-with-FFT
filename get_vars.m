function var_map = get_vars(freq_data, normalize) 
    % Convert the 2D image to a 3D matrix.
    image_array = cat(3, freq_data{:});
    % calculate the variance of each pixel
    var_map = var(image_array, 0, 3); 
    if normalize
        var_map = shift_freq(var_map, 0);
    end
end
