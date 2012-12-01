function [precision, recall, specificity] = calcForestStats(model, testImgName)

global TESTINTERPLABELS TESTADJMATS TESTIMAGES

INTERPLABELS = TESTINTERPLABELS;
ADJMATS = TESTADJMATS;

testList = dir(TESTIMAGES);
testList = testList(3:end);

labelList = dir(INTERPLABELS);
labelList = labelList(3:end); %remove . and .. from list

adjList = dir(ADJMATS);
adjList = adjList(3:end);

testImgNum = find(strcmp([testImgName, '.bmp'],{testList.name}));

adjList(testImgNum).name;
labelList(testImgNum).name;
adjMat = dlmread(fullfile(ADJMATS,adjList(testImgNum).name));
labelvect = load(fullfile(INTERPLABELS,labelList(testImgNum).name));
labelvect = labelvect.imgLabelVector;

[I, J] = find(triu(adjMat == 1));
suPairs = [I, J];

actualTF = labelvect(suPairs(:,1)) == labelvect(suPairs(:,2));
actualTF = actualTF';


ForestTF = testForest(model,testImgNum, suPairs);

tp = sum(ForestTF(ForestTF == 1) == actualTF(ForestTF == 1))
fp = sum(ForestTF(ForestTF == 1) ~= actualTF(ForestTF == 1))
tn = sum(ForestTF(ForestTF == 0) == actualTF(ForestTF == 0))
fn = sum(ForestTF(ForestTF == 0) ~= actualTF(ForestTF == 0))

precision = tp/(tp + fp)
recall = tp/(tp + fn)
specificity = tn/(tn + fp)
accuracy = (tp + tn)/(tp + fp + tn + fn)
