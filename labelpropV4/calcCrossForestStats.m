function [precision, recall, specificity] = calcCrossForestStats(model, testImgNum)

global TRAININTERPLABELS TRAINADJMATS 	

INTERPLABELS = TRAININTERPLABELS;
ADJMATS = TRAINADJMATS;

labelList = dir(INTERPLABELS);
labelList = labelList(3:end); %remove . and .. from list

adjList = dir(ADJMATS);
adjList = adjList(3:end);

adjList(testImgNum).name;
labelList(testImgNum).name;
adjMat = dlmread(fullfile(ADJMATS,adjList(testImgNum).name));
labelvect = load(fullfile(INTERPLABELS,labelList(testImgNum).name));
labelvect = labelvect.imgLabelVector;

[I, J] = find(triu(adjMat == 1));
suPairs = [I, J];

actualTF = labelvect(suPairs(:,1)) == labelvect(suPairs(:,2));
actualTF = actualTF';

forestTF = testForestCross(model,testImgNum, suPairs);

tp = sum(forestTF(forestTF == 1) == actualTF(forestTF == 1));
fp = sum(forestTF(forestTF == 1) ~= actualTF(forestTF == 1));
tn = sum(forestTF(forestTF == 0) == actualTF(forestTF == 0));
fn = sum(forestTF(forestTF == 0) ~= actualTF(forestTF == 0));

precision = tp/(tp + fp);
recall = tp/(tp + fn);
specificity = tn/(tn + fp);
accuracy = (tp + tn)/(tp + fp + tn + fn);
