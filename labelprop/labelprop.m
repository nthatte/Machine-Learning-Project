global HOMEIMAGES = '../CBCL/Images/'; 
global HOMEGIST = '../CBCL/GIST';

Ntrainimages = 100;
k = 10

%get and ramomize images data split into training and test
dirList = dir(HOMEIMAGES);
dirList = dirList(randperm(size(dirList,1)))
trainDirList = dirList(1:NtrainImages)
testDirList = dirList(101:NtrainImages)

param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4

gistTrain = trainingData(param,Nimages)

if ~testDirList.isdir 
	% use full path because the folder may not be the active path
	fileName = fullfile(HOMEIMAGES,testDirList(1).name);		
	gistTest = LMgist(fileName, HOMEIMAGES, param, HOMEGIST);
end

[IDX,D] = knnsearch(gistTrain,gistTest,k)
