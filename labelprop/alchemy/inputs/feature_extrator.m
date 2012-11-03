function [x] = feature_extractor(imgFileName)
img = imread([imgFileName '.bmp']);
figure;
imshow(img)
suppix_filename = [imgFileName '.S3.csv'];
suppix_l1= dlmread(suppix_filename);
%suppix_l2= dlmread(strcat(img, '.S2.csv'));
%suppix_l3= dlmread(strcat(img, '.S3.csv'));
%mask of superpixel shape over its bounding box
size(suppix_l1(:))
superPixelIDs = unique(suppix_l1(:));
r = size(suppix_l1,1); %rows
c = size(suppix_l1,2); %cols
indices = 1:(r*c);
x = zeros(210,size(superPixelIDs,1));
for i=1:size(superPixelIDs,1)
    suppix_mask = (suppix_l1 == i*ones(size(suppix_l1)));
    suppix_locationmask = extract_location_mask(suppix_mask);
    suppix_relativearea = sum(suppix_mask(:))/(r*c);
    suppix_occupancy_indices = indices(suppix_mask(:));
    [I,J] = ind2sub(size(suppix_mask), suppix_occupancy_indices);
    I_min = min(I(:));
    I_max = max(I(:));
    J_min = min(J(:));
    J_max = max(J(:));
    suppix_bbox = [I_min J_min I_max J_max];
    suppix_extracted = suppix_mask(I_min:I_max, J_min:J_max);
    suppix_bbmask = imresize(suppix_extracted, [8 8]);
    suppix_bbrratio = (I_max - I_min + 1)/r;
    suppix_bbcratio = (J_max - J_min + 1)/c;
    suppix_thbbrih = (r - I_min)/r;
    rimg = img(suppix_occupancy_indices);
    gimg = img(r*c + suppix_occupancy_indices);
    bimg = img(2*r*c + suppix_occupancy_indices);
    suppix_rhist = histc(rimg, 1:10:250);
    suppix_ghist = histc(gimg, 1:10:250);
    suppix_bhist = histc(bimg, 1:10:250);
    suppix_rmean = mean(rimg);
    suppix_gmean = mean(gimg);
    suppix_bmean = mean(bimg);
%     size(reshape(suppix_bbmask, 1, 64))
%     size(suppix_bbrratio)
%     size(suppix_bbcratio)
%     size(suppix_relativearea)
%     size(reshape(suppix_locationmask,1,64))
%     size(suppix_thbbrih)
%     size(suppix_rmean)
%     size(suppix_gmean)
%     size(suppix_bmean)
%     size(suppix_rhist')
%     size(suppix_ghist')
%     size(suppix_bhist')
    x(:,i) = [reshape(suppix_bbmask, 1, 64) suppix_bbrratio suppix_bbcratio ...
        suppix_relativearea reshape(suppix_locationmask,1,64) suppix_thbbrih ...
        suppix_rmean suppix_gmean suppix_bmean...
        suppix_rhist suppix_ghist suppix_bhist]';
end
dlmwrite([imgFileName '.features.csv'], x);
