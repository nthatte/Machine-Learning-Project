global ALL ALLIMAGES ALLLABELS ALLSUPIX ALLWORDS TEST TESTIMAGES TESTLABELS TESTSUPIX TESTWORDS TESTFEATURES TESTADJMATS TESTINTERPLABELS TRAIN TRAINIMAGES TRAINLABELS TRAINSUPIX TRAINWORDS TRAININTERPLABELS TRAINFEATURES TRAINADJMATS

ALL = 'allData';
ALLIMAGES = 'allData/images';
ALLLABELS = 'allData/labels';
ALLSUPIX  = 'allData/superPixels';
ALLWORDS  = 'allData/wordMaps';

TEST = 'Test';
TESTIMAGES = 'Test/images';
TESTLABELS = 'Test/labels';
TESTSUPIX  = 'Test/superPixels';
TESTWORDS  = 'Test/wordMaps';
TESTFEATURES = 'Test/featureMats';
TESTADJMATS = 'Test/adjMats';
TESTINTERPLABELS = 'Test/labels_interp';

TRAIN = 'Train';
TRAINIMAGES = 'Train/images';
TRAINLABELS = 'Train/labels';
TRAINSUPIX  = 'Train/superPixels';
TRAINWORDS  = 'Train/wordMaps';
TRAININTERPLABELS = 'Train/labels_interp';
TRAINFEATURES = 'Train/featureMats';
TRAINADJMATS = 'Train/adjMats';

%test image
testImgName = '7_28_s'

%trains random forest
model = findBestForest(testImgName);

%load data files
adjMat = dlmread(fullfile(TESTADJMATS,[testImgName, '.adj23.csv']));
adjMatU = triu(adjMat);
testList = dir(TESTIMAGES);
testList = testList(3:end);
testImg = imread(fullfile(TESTIMAGES,[testImgName '.bmp']));
testImageNum = find(strcmp([testImgName, '.bmp'],{testList.name}));
supix = dlmread(fullfile(TESTSUPIX,[testImgName '.S3.csv']));
featureStruct = load('Test/colorfeats.mat');
features = featureStruct.features;
featMat = features{testImageNum};

%gets a prior distribution for labels for each superpixel in test image
[priorSeg, priorDist] = getBaselineDistributionImage(testImgName);
distStack = reshape(priorDist',size(testImg,1),size(testImg,2),14);

%for each superpixel in image, find entropy of probability distribution of its label and sort superpixels  by entropy

supixInfo = zeros(max(unique(supix)),5); %supixNum, label, entropy, visited, changed

for su = unique(supix)'
	sumask = supix ~= su;
	%sulabels = priorSeg(sumask);
	sumaskStack = repmat(sumask,[1,1,14]);
	sudist = distStack;
	sudist(sumaskStack) = 0;
	%sulabelDist = hist(sulabels,[1:14])/length(sulabels);
	
	sulabelDist = sum(sudist,1);
	sulabelDist = sum(sulabelDist,2);
	sulabelDist = sulabelDist/sum(sulabelDist,3);
	sulabelDist = sulabelDist(:);
	
	[prob, label] = max(sulabelDist);
	supixInfo(su,:) = [su, label, entropy(sulabelDist), 0, 0];
end

sortedSupixInfo = sortrows(supixInfo,3);

for su = sortedSupixInfo'
	%mark as visited
	sortedSupixInfo(sortedSupixInfo(:,1) == su(1),4) = 1;
	
	%get neighbors with different labels
	su;
	allNeighbors = find(adjMatU(su(1),:) == 1);
	neighborLabels = supixInfo(allNeighbors,2);
	neighbors = allNeighbors(neighborLabels ~= su(2));

	%query forest and propogate labels
	featDiff = abs(repmat(featMat(su(1),:),length(neighbors),1) - featMat(neighbors,:));
	tf = classRF_predict(featDiff,model);
	i = 1;
	for neighbor = neighbors
		%if visited do nothing if not visited mark visited and propagate label
		if  sortedSupixInfo(sortedSupixInfo(:,1) == neighbor,4);
			i = i+1;
			continue;
		elseif tf(i)
			%sortedSupixInfo(sortedSupixInfo(:,1) == neighbor,4) = 1;
			sortedSupixInfo(sortedSupixInfo(:,1) == neighbor,2) = su(2);
			sortedSupixInfo(sortedSupixInfo(:,1) == neighbor,5) = 1;
		end
		i = i + 1;
	end
end

supixInfo = sortrows(sortedSupixInfo,1);
newImgLabel = zeros(size(supix));
for su = unique(supix)'
	if supixInfo(su,5) == 1
		sumask = supix == su;
		newImgLabel(sumask) = supixInfo(su,2);
	end
end
finalImgLabels = priorSeg;
finalImgLabels(newImgLabel ~=0) = newImgLabel(newImgLabel ~= 0);

figure(1)
subplot(3,2,3)
imagesc(supix);
title('Superpixel Segmentation')
colormap jet
set(gca, 'YTick', []);
set(gca, 'XTick', []);
axis image

figure(2)
subplot(1,2,1)
imagesc(finalImgLabels)
axis image
colorbar
subplot(1,2,2)
imagesc(priorSeg)
axis image
colorbar
