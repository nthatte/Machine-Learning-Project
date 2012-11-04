function calcGist()
%loads training samples and generates gist discriptor feature matrix if not already generated

global TEST TESTIMAGES TRAIN TRAINIMAGES

testList = dir(TESTIMAGES);
testList = testList(3:end);
trainList = dir(TRAINIMAGES);
trainList = trainList(3:end);

%gist feature parameters and get gist features for all images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
param.imageSize = [320 213];

% Pre-allocate test gist:
Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
gistTrain = zeros([length(testList), Nfeatures]); 
gistTest = zeros([length(trainList), Nfeatures]); 

%loop
if ~exist(fullfile(TRAIN,'gist.csv'))
	for i = 1:length(trainList)
		i
		% use full path because the folder may not be the active path
		fileName = fullfile(TRAINIMAGES,trainList(i).name)
		gistTrain(i,:) = LMgist(imread(fileName),'', param);
		dlmwrite(fullfile(TRAIN,'gist.csv'), gistTrain);
	end
end
if ~exist(fullfile(TEST,'gist.csv'))
	for i = 1:length(testList)
		i
		% use full path because the folder may not be the active path
		fileName = fullfile(TESTIMAGES,testList(i).name)		
		gistTest(i,:) = LMgist(imread(fileName),'', param);
		dlmwrite(fullfile(TEST,'gist.csv'), gistTest);
	end
end


