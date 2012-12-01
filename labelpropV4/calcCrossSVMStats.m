function [precision, recall, specificity] = calcCrossForestStats(SVMstruct, testImgNum)

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

SVMTF = testSVMcross(SVMstruct,testImgNum, suPairs);

tp = sum(SVMTF(SVMTF == 1) == actualTF(SVMTF == 1));
fp = sum(SVMTF(SVMTF == 1) ~= actualTF(SVMTF == 1));
tn = sum(SVMTF(SVMTF == 0) == actualTF(SVMTF == 0));
fn = sum(SVMTF(SVMTF == 0) ~= actualTF(SVMTF == 0));

precision = tp/(tp + fp);
recall = tp/(tp + fn);
specificity = tn/(tn + fp);
accuracy = (tp + tn)/(tp + fp + tn + fn);
