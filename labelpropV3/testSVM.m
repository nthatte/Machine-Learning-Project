function tf = testSVM(SVMstruct, testim, supairs)

global TESTIMAGES

testList = dir(TESTIMAGES);
testList = testList(3:end);

testImageNum = find(strcmp([testim, '.bmp'],{testList.name}));

featureStruct = load('Test/colorfeats.mat');
features = featureStruct.features;
featMat = features{testImageNum};

featDiff = abs(featMat(supairs(:,1),:) - featMat(supairs(:,2),:));
tf = svmclassify(SVMstruct,featDiff);
