function [p] = getLabelProbabilityDistribution(hist, histMat, labelvector)
%Uses the histograms from the training data and returns a distribution over
%the labels indicating the probability of label given histogram
[D,I] = pdist2(histMat', hist', 'cityblock', 'Smallest', 130);
label_list = label_vector(I');
p = hist(label_list, 0:12);
end