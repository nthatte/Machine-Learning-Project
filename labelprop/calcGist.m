function gist = calcGist(dirList,param)
%loads training samples and generates gist discriptor feature matrix if not already generated

global HOMEIMAGES

% Pre-allocate gist:
Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
gist = zeros([size(dirList,1), Nfeatures]); 

%loop
for i = 1:size(dirList,1)
	i
	% use full path because the folder may not be the active path
	fileName = fullfile(HOMEIMAGES,dirList(i).name);		
	gist(i,:) = LMgist(imread(fileName),[], param);
end

dlmwrite('gist.csv', gist)
