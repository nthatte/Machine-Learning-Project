function [location_mask] = extract_location_mask(img)
% img is the binary image with ones for superpixel positions 0's elsewhere
% location_mask is the same thing rescaled to 8x8
rows = size(img, 1);
cols = size(img, 2);
block_rows = int32(floor(rows/8));
block_cols = int32(floor(cols/8));
location_mask = zeros(8);
for i=1:8
    for j=1:8
        location_mask(i,j) = max(max(img((block_rows * (i-1) + 1):(block_rows * i)...
            ,(block_cols * (j-1) + 1):(block_cols * j))));
    end
end
end