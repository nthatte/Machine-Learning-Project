%loads training samples and generates gist discriptor feature matrix if not already generated

global HOMEIMAGES

% Pre-allocate gist:
Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
gist = zeros([Nimages Nfeatures]); 

%load first image
if ~dirList(1).isdir
	% use full path because the folder may not be the active path
	fileName = fullfile(HOMEIMAGES,dirList(1).name)
	gist(1,:) = LMgist(imread(fileName), param);
end

%loop
for i = 2:Nimages
	i
	%check that file is not actually a directory
	if ~dirList(i).isdir 
		% use full path because the folder may not be the active path
		fileName = fullfile(HOMEIMAGES,dirList(i).name);		
		gist(i,:) = LMgist(imread(fileName), param);
	end
end

dlmwrite('gist.csv', gist)
