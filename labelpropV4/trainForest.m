function model = trainForest(trainimgs, ratio, M);

global TRAININTERPLABELS TRAINADJMATS

trainSize = length(trainimgs);

labelList = dir(TRAININTERPLABELS);
labelList = labelList(3:end); %remove . and .. from list

adjList = dir(TRAINADJMATS);
adjList = adjList(3:end);     %remove . and .. from list

featureStruct = load('Train/colorfeats.mat');
features = featureStruct.features;

%make forest feature matrix of  = total num superpixels width = length of features
numedges = 0;
for i = trainimgs
	adjMat = dlmread(fullfile(TRAINADJMATS,adjList(i).name));
	numedges = numedges + length(find(triu(adjMat == 1 )));
end

forestfeatMat = zeros(numedges,39);
forestgroupvect = zeros(1,numedges);

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
			forestgroupvect(edgenum) = 2;
		else
		%}
			feat = abs(featMat(suPair(1),:) - featMat(suPair(2),:));
			forestgroupvect(edgenum) = labelvect(suPair(1)) == labelvect(suPair(2));
		%end
		forestfeatMat(edgenum,:) = feat;
	end
end
%disp 'assembled data'
%{
notzero = find(forestgroupvect ~= 2);
length(forestgroupvect)
size(forestfeatMat)
length(forestgroupvect(notzero))
size(forestfeatMat(notzero,:))
%}

%sample true points to balance number of true and false points
where1 = find(forestgroupvect ==1);
randindex = randperm(length(where1));

warning('off','MATLAB:colon:nonIntegerIndex')
totrain = [find(forestgroupvect == 0), where1(randindex(1:ratio*sum(forestgroupvect == 0)))];

%disp 'start training'
model = classRF_train(forestfeatMat(totrain,:),forestgroupvect(totrain)', 500, M);
%disp 'done training'
