clear; clc; close all;

path_to_data = 'database/s*';
path_to_images = 'database/s*/*.pgm';

% to store some tests
tests = ["test_aoun1.pgm", "test_aoun2.pgm", "test_31.pgm", "test_9.pgm"];
test_curr = tests(2);

face_rec(path_to_data, path_to_images, test_curr)