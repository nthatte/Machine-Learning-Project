function [mser_features]=feats_mser(mask,I)

%I is the image
%mask determines the regiion of the superpixel
count = 1;
img_gray = rgb2gray(I);

regions = detectMSERFeatures(img_gray);

[features, valid_points] = extractFeatures(img_gray, regions);


[m,n]=size(valid_points.Location);

for i = 1:m
    if(mask(round(valid_points.Location(m,:)))==1)
        mser_features(count,:) = features(m,:);
        count = count + 1;
    end
end

