global HOMEIMAGES HOMEGIST

HOMEIMAGES = 'data'; 

NtrainImages = 239;
k = 9;

%get and ramomize images data split into training and test
dirList = dir(HOMEIMAGES);
dirList = dirList(3:end);	
randindex = randperm(size(dirList,1));
dirListRand = dirList(randindex);
trainDirList = dirListRand(1:NtrainImages);
testDirList = dirListRand(NtrainImages+1:end);

%gist feature parameters and get gist features for all images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
param.imageSize = [320 213];
if ~exist('gist.csv')
	gist = calcGist(dirList,param);
else
	gist = dlmread('gist.csv');
end

gistshuffle = gist(randindex,:);
gistTrain = gistshuffle(1:NtrainImages,:);

%load a test image
% use full path because the folder may not be the active path
testImg = imread(fullfile(HOMEIMAGES,testDirList(1).name));		
gistTest = gistshuffle(NtrainImages+1,:);

%find k nearest images
[IDX,D] = knnsearch(gistTrain,gistTest,'K',k)

%plot k nearest images
scrsz = get(0,'ScreenSize');
figure(1)
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2])
subplot(4,3,1), imshow(testImg)
title('test image')
i = 2;
for img=IDX
	subplot(4,3,i), imshow(imread(fullfile(HOMEIMAGES,trainDirList(img).name)))
	title(strcat(int2str(i-1),'th closest image'))
	i = i + 1;
end
