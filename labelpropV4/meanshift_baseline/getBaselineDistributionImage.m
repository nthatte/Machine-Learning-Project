%Author: Aravindh Mahendran
function [priorSegmentation, dist] = getBaselineDistributionImage(name)
% Get the prior probability distribution for the test image base name name
% Example of input - priorSeg = getBaselineDistributionImage('1_1_s');
% Assumes that test files are located at 

global TESTIMAGES

I = imread(fullfile(TESTIMAGES,[name '.bmp']));
Iseg = imread(['meanshift_baseline/meanshift_images/', name, '.bmp.pnms40r10.seg.pnm']);
Iseg = rgb2gray(Iseg);

figure(1)
subplot(3,2,1)
imshow(I);
title(['Test Image: ', name],'Interpreter','none')
axis image
subplot(3,2,2)
imshow(Iseg);
title(['meanshift segmentation'])
axis image

load('TextonLibrary.mat', 'TextonLibrary');
load('trainingHistogramMatrix.mat', 'trainingHistogramMatrix');
load('trainingLabelVector.mat', 'trainingLabelVector');
load('fb.mat', 'fb');
[textonmap, confmap] = compute_textons(I, fb, TextonLibrary);
subplot(3,2,4);
imagesc(textonmap);
title('Texton Map')
set(gca, 'YTick', []);
set(gca, 'XTick', []);
axis image
dictionarysize = size(TextonLibrary,1);
dist = getBaselineDistribution(I, Iseg, textonmap, dictionarysize, trainingHistogramMatrix,...
    trainingLabelVector, 13);
[val, maplabels] = max(dist);
maplabels = maplabels - 1;
priorSegmentation = reshape(maplabels, size(I, 1), size(I,2));
subplot(3,2,5);
colormap('Lines');
imagesc(priorSegmentation);
title('Prior Labels')
set(gca, 'YTick', []);
set(gca, 'XTick', []);
colormap('Lines');
axis image
colorbar;
subplot(3,2,6);
colormap('jet');
imagesc(reshape(val, size(I,1), size(I,2)));
title('Confidence')
colorbar
set(gca, 'YTick', []);
set(gca, 'XTick', []);
axis image
end
