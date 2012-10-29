%loads training samples and generates gist discriptor feature matrix if not already generated
function gist = trainingData(param,Nimages,dirlist)

	global HOMEIMAGES, HOMEGIST
	
	% Pre-allocate gist:
	Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
	gist = zeros([Nimages Nfeatures]); 

	%load first image
	if ~dirListing(1).isdir
		% use full path because the folder may not be the active path
		fileName = fullfile(HOMEIMAGES,dirListing(d).name); 	
		gist(1,:) = LMgist(fileName, HOMEIMAGES, param, HOMEGIST);
	end

	%loop
	for i = 2:Nimages
		%check that file is not actually a directory
		if ~dirListing(i).isdir 
			% use full path because the folder may not be the active path
			fileName = fullfile(HOMEIMAGES,dirListing(d).name);		
			gist(i,:) = LMgist(fileName, HOMEIMAGES, param, HOMEGIST);
		end
	end
