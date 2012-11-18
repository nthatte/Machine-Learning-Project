function SVMstruct = trainSVM(trainimgs);

global TRAININTERPLABELS TRAINADJMATS

trainSize = length(trainimgs);

labelList = dir(TRAININTERPLABELS);
labelList = labelList(3:end); %remove . and .. from list

adjList = dir(TRAINADJMATS);
adjList = adjList(3:end);     %remove . and .. from list

featureStruct = load('Train/colorfeats.mat');
features = featureStruct.features;

%make SVM feature matrix of  = total num superpixels width = length of features
numedges = 0;
for i = trainimgs
	adjMat = dlmread(fullfile(TRAINADJMATS,adjList(i).name));
	numedges = numedges + length(find(triu(adjMat == 1 )));
end

SVMfeatMat = zeros(numedges,39);
SVMgroupvect = zeros(1,numedges);

edgenum = 0;
for i = trainimgs
	adjList(i).name;
	labelList(i).name;

	adjMat = dlmread(fullfile(TRAINADJMATS,adjList(i).name));
	featMat = features{i};
	labelvect = load(fullfile(TRAININTERPLABELS,labelList(i).name));
	labelvect = labelvect.imgLabelVector;
	
	[I, J] = find(triu(adjMat == 1));
	suPairs = [I, J];
	for suPair = suPairs'
		edgenum = edgenum + 1;
		%{
		if labelvect(suPair(1)) == 0 || labelvect(suPair(2)) == 0
			SVMgroupvect(edgenum) = 2;
		else
		%}
			feat = abs(featMat(suPair(1),:) - featMat(suPair(2),:));
			SVMgroupvect(edgenum) = labelvect(suPair(1)) == labelvect(suPair(2));
		%end
		SVMfeatMat(edgenum,:) = feat;
	end
end
disp 'assembled data'

%{
notzero = find(SVMgroupvect ~= 2);
length(SVMgroupvect)
size(SVMfeatMat)
length(SVMgroupvect(notzero))
size(SVMfeatMat(notzero,:))
%}

%sample true points to balance number of true and false points
where1 = find(SVMgroupvect ==1);
randindex = randperm(length(where1));

warning('off','MATLAB:colon:nonIntegerIndex')
totrain = [find(SVMgroupvect == 0), where1(randindex(1:1.6*sum(SVMgroupvect == 0)))];

%options = statset('Display','iter');
options = statset();
disp 'start training'
SVMstruct = svmtrain(SVMfeatMat(totrain,:),SVMgroupvect(totrain)','method','SMO','boxconstraint', 1,'kernel_function','rbf','options',options);
disp 'done training'
