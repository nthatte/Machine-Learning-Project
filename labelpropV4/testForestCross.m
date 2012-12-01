function tf = testForestCross(model, testImageNum, supairs)

global TRAINIMAGES

testList = dir(TRAINIMAGES);
testList = testList(3:end);

featureStruct = load('Train/colorfeats.mat');
features = featureStruct.features;
featMat = features{testImageNum};

featDiff = abs(featMat(supairs(:,1),:) - featMat(supairs(:,2),:));
tf =  classRF_predict(featDiff,model);
