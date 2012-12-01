function [corner_features]=feats_corner(mask,I)

%I is the image
%mask determines the regiion of the superpixel
count = 1;
img_gray = rgb2gray(I);

hcornerdet = vision.CornerDetector;
points = step(hcornerdet, img_gray);

[features, valid_points] = extractFeatures(img_gray, points);

[m,n]=size(valid_points);

for i = 1:m
    if(mask(round(valid_points(m,:)))==1)
        corner_features(count,:) = features(m,:);
        count = count + 1;
    end
end

