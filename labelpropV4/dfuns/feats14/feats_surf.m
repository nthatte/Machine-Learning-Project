function [surf_features]=feats_surf(mask,I)

%I is the image
%mask determines the regiion of the superpixel
count = 1;
img_gray = rgb2gray(I);
points = detectSURFFeatures(img_gray);
[features, valid_points] = extractFeatures(img_gray, points, 'Method', 'SURF');

[m,n]=size(valid_points.Location);

for i = 1:m
    if(mask(round(valid_points.Location(m,:)))==1)
        surf_features(count,:) = features(m,:);
        count = count + 1;
    end
end

