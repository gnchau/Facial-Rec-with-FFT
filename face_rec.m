function face_rec(path_to_data, path_to_images, test_curr)

real_max = 0.65;
imag_max = 0.05;

intensities = read_images(path_to_images);

% Pad the arrays to be the same size. In this case, 128 x 128 pixels
intensities = cellfun(@(x) padarray(x, [8,18], 'replicate'), intensities, 'UniformOutput', false);

% Compute the absolute, real, and imaginary frequencies and store them in
% cells; arguments are the intensities, 1 to normalize, and 1 to shift the
% origin to the center
[fft_abs, fft_real] = cellfun(@(x) features(x,1,1), intensities, 'UniformOutput',false);

% figure;
% subplot(2, 1, 1)
% imshow(get_vars(fft_abs, 1));
% title('Variance of the Database'); 

% vars_real = get_vars(fft_real, 1);
% subplot(2, 1, 2)
% imshow(vars_real);
% title("Most Important Feature Frequencies (Real Space)")

% display the inputted image
input = double(imread(test_curr))/255;
input = padarray(input,[8,18],'replicate');

figure;
subplot(2, 1, 1)
imshow(input);
title("Input Image");

input_fft = fft2(input);

subplot(2, 1, 2)
imshow(real(input_fft));
title("FFT of the Input");

[~, fft_real, fft_imag] = cellfun(@(x) features(x, 1, 0), intensities, 'UniformOutput', false);
vars_real = get_vars(fft_real, 1);
vars_imag = get_vars(fft_imag, 1);

% Store the largest variances in real and imaginary parts.
real_max_idx = vars_real > real_max;
imag_max_idx = vars_imag > imag_max;
input_real = real(input_fft);
input_imag = imag(input_fft);

% Zero everything except these points out.
input_real(real_max_idx) = 0;
input_imag(imag_max_idx) = 0;

% Convert from Fourier space to [x, y].
input_deletions = complex(input_real, input_imag);
filtered_input = ifft2(input_deletions);

% Display the image.
% figure;
% imshow(filtered_input);
% title("Inverse FFT of Input Without Features");

% Bring out the variant frequencies.
real_var = real(input_fft);
real_var(~real_max_idx) = 0;

path = dir(path_to_data);
folders = length(path);
% store the feature frequency for each person, devided into real and imag
frequency_real = [];

% For each person in the database, store the average real and imaginary
% frequencies.
for i = 1:folders
    path_to_images = strcat(path(i).folder, '\s', string(i),'\*.pgm');
    data = read_images(path_to_images);
    intensities = cellfun(@(x) padarray(x,[8,18],'replicate'), data, 'UniformOutput',false);
    
    % Perform fft once again on preprocessed data. Store the frequencies in
    % cell arrays.
    [~, img_real] = cellfun(@(x) features(x,0,0), intensities,'UniformOutput', false);
    
    % Compute the average of the real part.
    img_real =  cat(3, img_real{:});
    real_avg = mean(img_real,3);

    % Extract the most variant parts from when I zeroed them out earlier.
    real_avg(~ real_max_idx) = 0;
    frequency_real = cat(3, frequency_real, real_avg);
end

feature_real_dis = [];

% For each person, compute the difference between the input image's feature 
% vector and the average feature vector of that person's data.
for i = 1:folders
   real_distance = feature_distance(real_var, frequency_real(:,:,i));
   feature_real_dis = [feature_real_dis, real_distance];
end

% Compute the minimum distance of all faces in the database.
[match_real, match_indx] = min(feature_real_dis);

% Print the prediction.
fprintf('The best match is s%i.\n', match_indx);

% Show the prediction alongside the input.
i = randi([1,10]);
predicted = strcat('database/s', string(match_indx), '/', string(i), '.pgm');
match = double(imread(char(predicted)))/255;
match = padarray(match, [8, 18], 'replicate');

figure;
subplot(1,2,1)
imshow(input);
title('Input Image'); 

subplot(1,2,2)
imshow(match);
title('Output Prediction');

fprintf('==== Distance Between Input Features and Average Feature of a Person ====\n%g \n', feature_real_dis);

end