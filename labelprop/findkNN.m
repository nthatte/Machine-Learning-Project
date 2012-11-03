function imgs = findkNN(testImgName,k)

	global HOMEIMAGES
	
	%get and list of images 
	dirList = dir(HOMEIMAGES);
	dirList = dirList(3:end); %remove . and .. from list
	testImageNum = find(strcmp(testImgName,{dirList.name}));
	NtrainImages = length(dirList) - 1;

	%gist feature parameters and get gist features for all images
	param.orientationsPerScale = [8 8 8 8];
	param.numberBlocks = 4;
	param.fc_prefilt = 4;
	param.imageSize = [320 213];
	if ~exist('gist.csv')
		gist = calcGist(dirList,param);
	else
		gist = dlmread('gist.csv');
	end

	%load a test image
	% use full path because the folder may not be the active path
	testImg = imread(fullfile(HOMEIMAGES,testImgName));		
	gistTest = gist(testImageNum,:);

	%find k nearest images excluding testImage
	gist(testImageNum,:) = nan;
	[imgs,D] = knnsearch(gist,gistTest,'K',k);
	%plot k nearest images
	scrsz = get(0,'ScreenSize');
	figure(1)
	set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)/2])
	subplot(4,3,1), imshow(testImg)
	title(strcat('test image: ',testImgName),'Interpreter','none')
	i = 2;
	for img=imgs
		subplot(4,3,i), imshow(imread(fullfile(HOMEIMAGES,dirList(img).name)))
		title(strcat(int2str(i-1),': ',dirList(img).name),'Interpreter','none')
		i = i + 1;
	end
