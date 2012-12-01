function imgs = findkNN(testImg,k)
	
	global TRAIN TRAINIMAGES TEST TESTIMAGES
	

	testImgName = [testImg, '.bmp'];
	%get and list of images 
	testList = dir(TESTIMAGES);
	testList = testList(3:end);
	trainList = dir(TRAINIMAGES);
	trainList = trainList(3:end);

	trainGist = dlmread(fullfile(TRAIN,'gist.csv'));
	testGist = dlmread(fullfile(TEST,'gist.csv'));

	%load a test image
	% use full path because the folder may not be the active path
	testImg = imread(fullfile(TESTIMAGES,testImgName));		
	testImageNum = find(strcmp(testImgName,{testList.name}));
	gistTestVector = testGist(testImageNum,:);

	%find k nearest images excluding testImage
	[imgs,D] = knnsearch(trainGist,gistTestVector,'K',k);
	
	%plot k nearest images
	if 1
		figure(1)
		subplot(2,3,1), imshow(testImg)
		title(strcat('test image: ',testImgName),'Interpreter','none')
		i = 2;
		for img=imgs
			trainList(img).name;
			subplot(2,3,i), imshow(imread(fullfile(TRAINIMAGES,trainList(img).name)))
			title(strcat(int2str(i-1),': ',trainList(img).name),'Interpreter','none')
			i = i + 1;
		end
		
		imsize = [3 4];
		set(gcf, 'PaperUnits', 'inches');
		set(gcf, 'PaperSize', imsize);
		set(gcf, 'PaperPosition', [0, 0, imsize]);
		print('-dpng','-r300',['./Results/', testImgName(1:end-4), '.knn.png'])


	end
