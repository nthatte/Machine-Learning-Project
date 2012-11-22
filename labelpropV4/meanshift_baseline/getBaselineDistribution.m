%Author: Aravindh Mahendran
function [dist] = getBaselineDistribution(I, Iseg, textonmap, dictionarysize, training_textonhists, training_labels, numLabels)
%dist = getBaselineDistribution(I, Iseg, textonmap) - return pixelwise distribution of label probabilities
% inputs: I(2D matrix) -> The actual image (I only need the size really)
%         Iseg(Integer 2D matrix) -> Segmentation info. A integer matrix containing per pixel segment ID
%         textonmap(Integer 2D matrix) -> textonmap of the image
%         dictionarysize(integer scalar) -> the vocabulary size used for textonifying this image
%         training_textonhists(double 2D matrix) -> texton histograms for the training images (each row is a histogram)
%         training_labels(integer vector) -> labels for the training segments. One label corresponding to each row in the textonhistogram matrix
%         numLabels(integer scalar) -> number of labels in our dataset
%         other than the void label
% output: returns the distribution corresponding to each pixel in a
% numLabels + 1 by number of pixels matrix
v = unique(Iseg(:));
numSegs = size(v,1);
K = 14; %number of nearest neighbor histograms to look for
%Compute the histograms for each segment in Iseg
segment_textonhists = zeros(numSegs, dictionarysize);
for i=1:numSegs
    mask = (Iseg == v(i));
    segment_textons = textonmap(mask);
    segment_textonhists(i,:) = hist(segment_textons, 1:dictionarysize);
    segment_textonhists(i,:) = segment_textonhists(i,:)./sum(segment_textonhists(i,:));
end
%Find the K nearest histograms per segment histogram and copy the labels for each nearest neighbor
[D,nearestHistogramIndices] = pdist2(training_textonhists, segment_textonhists, 'cityblock', 'Smallest', K);
nearestHistogramLabels = training_labels(nearestHistogramIndices(:));
nearestHistogramLabels = reshape(nearestHistogramLabels, K, numSegs);
%The normalized histogram of labels is the probability mass distribution across the labels for each segment
perSegmentDistribution = hist(nearestHistogramLabels, 0:numLabels);
perSegmentDistribution = perSegmentDistribution / K;
if(size(perSegmentDistribution,1) == 1)  %To handle the case where we have only one segment
    perSegmentDistribution = perSegmentDistribution';
end
dist = zeros(numLabels + 1, size(I,1)*size(I,2));
for i=1:numSegs
    segment_indices = find(Iseg == v(i));
    dist(:, segment_indices) = repmat(perSegmentDistribution(:,i), 1, size(segment_indices,1));
end
end