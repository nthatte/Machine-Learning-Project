%Author: Aravindh Mahendran
function [priorSegmentation, dist] = getBaselineDistributionImage(name)
% Get the prior probability distribution for the test image base name name
% Example of input - priorSeg = getBaselineDistributionImage('1_1_s');
% Assumes that test files are located at 

global TESTIMAGES

calculateTrainingHistograms(name);

I = imread(fullfile(TESTIMAGES,[name '.bmp']));
Iseg = imread(['meanshift_baseline/meanshift_images/', name, '.bmp.pnms40r10.seg.pnm']);
Iseg = rgb2gray(Iseg);

load('TextonLibrary.mat', 'TextonLibrary');
load('trainingHistogramMatrix.mat', 'trainingHistogramMatrix');
load('trainingLabelVector.mat', 'trainingLabelVector');
load('fb.mat', 'fb');
[textonmap, confmap] = compute_textons(I, fb, TextonLibrary);

	imsize = [3 4];

%original image
figure(1)
subplot(111)
imshow(I);
title(['Test Image: ', name],'Interpreter','none')
axis image
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', imsize);
set(gcf, 'PaperPosition', [0, 0, imsize]);
print('-dpng',['./Results/', name, '.original.png'])

%meanshift
imshow(Iseg);
colormap('jet')
title(['meanshift segmentation'])
axis image
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', imsize);
set(gcf, 'PaperPosition', [0, 0, imsize]);
print('-dpng',['./Results/', name, '.meanshift.png'])

%texton
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
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', imsize);
set(gcf, 'PaperPosition', [0, 0, imsize]);
print('-dpng',['./Results/', name, '.texton.png'])

%confidence
imagesc(reshape(val, size(I,1), size(I,2)));
title('Confidence')
colorbar('SouthOutside')
set(gca, 'YTick', []);
set(gca, 'XTick', []);
axis image
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', imsize);
set(gcf, 'PaperPosition', [0, 0, imsize]);
print('-dpng',['./Results/', name, '.conf.png'])

%prior
priorSegmentation = reshape(maplabels, size(I, 1), size(I,2));
imagesc(priorSegmentation);
title('Prior Labels')
set(gca, 'YTick', []);
set(gca, 'XTick', []);
axis image
colorbar('SouthOutside')
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', imsize);
set(gcf, 'PaperPosition', [0, 0, imsize]);
print('-dpng',['./Results/', name, '.prior.png'])
