function getPriorLabelProbability(imageFilename, suppix_offset)
%Computes the distribution of labels for each superpixel and dumps
%predicates for it
load labelvect.mat labelvector;
load histmat.mat histMat;
load([imageFilename 'wordMap.mat'], 'wordMap');
suppix_l1 = dlmread([imageFilename '.S3.csv']);
superPixelIDs = unique(suppix_l1(:));
r = size(suppix_l1,1); %rows
c = size(suppix_l1,2); %cols
fileID = fopen([imageFilename '.prior.mln'], 'w');
for i=1:size(superPixelIDs,1)
    %code here to build the histogram
    suppix_mask = (suppix_l1 == i*ones(size(suppix_l1)));
    viswords = wordMap(suppix_mask);
    bow_hist = histc(viswords,1:200);
    p = getLabelProbabilityDistribution(bow_hist, histMat, labelvector);
    for j=1:size(p,2)
        fprintf(fileID, '%f IsLabel(%d,%d)\n', p(j), suppix_offset + i, j);
    end
end
end