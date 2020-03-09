function data = read_images(image_path)
% Function to read all pgms and store them in an cell array.
path = dir(image_path);
num_files = length(path);
data = cell(1, num_files);

    for i = 1:num_files
        file_name = strcat(path(i).folder, '\', path(i).name);
        image = double(imread(file_name))/255;
        data{i} = image;
    end
end 