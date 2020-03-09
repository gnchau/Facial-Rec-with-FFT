function x = feature_distance(A, B)
% The distances between the feature vectors
    M = abs(A - B);
    x = sum(sum(M));
end
