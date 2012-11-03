img1_adj13=dlmread('5_20_s.adj13.csv');
offsetFor2 = size(img1_adj13,1);
img2_adj13=dlmread('5_23_s.adj13.csv');
offsetFor3 = size(img2_adj13,1) + offsetFor2;
img3_adj13=dlmread('1_15_s.adj13.csv');
fileID = fopen('train_neighbor.db','w');
'm1'
for i=1:size(img1_adj13,1)
    for j=1:size(img1_adj13,2)
        if(img1_adj13(i,j) == 1)
            fprintf(fileID,'isNeighbor(%d,%d)\n', i,j);
        end
    end
end
'm2'
offsetFor2
for i=1:size(img2_adj13,1)
    for j=1:size(img2_adj13,2)
        if(img2_adj13(i,j) == 1)
            fprintf(fileID,'isNeighbor(%d,%d)\n', offsetFor2 + i, offsetFor2 + j);
        end
    end
end
'm3'
offsetFor3
for i=1:size(img3_adj13,1)
    for j=1:size(img3_adj13,2)
        if(img3_adj13(i,j) == 1)
            fprintf(fileID,'isNeighbor(%d,%d)\n', offsetFor3 + i, offsetFor3 + j);
        end
    end
end
fclose(fileID)

fileID = fopen('train_labels.db','w')
img1_GT = imread('5_20_s_GT.bmp');
img2_GT = imread('5_23_s_GT.bmp');
img3_GT = imread('1_15_s_GT.bmp');

img1_S3 = dlmread('5_20_s.S3.csv');
img2_S3 = dlmread('5_23_s.S3.csv');
img3_S3 = dlmread('1_15_s.S3.csv');

superPixelIDs = unique(img1_S3(:));
for i=1:size(superPixelIDs,1)
    suppix_mask = (img1_S3 == i*ones(size(img1_S3)));
    GT_mask = img1_GT(suppix_mask);
    GT_label = mode(GT_mask(:));
    fprintf(fileID, 'IsLabel(%d,%d)\n', i, GT_label);
end
superPixelIDs = unique(img2_S3(:));
for i=1:size(superPixelIDs,1)
    suppix_mask = (img2_S3 == i*ones(size(img2_S3)));
    GT_mask = img2_GT(suppix_mask);
    GT_label = mode(GT_mask(:));
    fprintf(fileID, 'IsLabel(%d,%d)\n', offsetFor2 + i, GT_label);
end