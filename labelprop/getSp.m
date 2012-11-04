function getSp(testImgName,kNNImgNames)

	global TESTIMAGE TESTSUPIX TRAINIMAGE TRAINSUPIX

	testImageList = dir(TESTIMAGES);
	testImageList = testImageList(3:end);
	trainImageList = dir(TRAINIMAGES);
	trainImageList = trainImageList(3:end);

	testSupixList = dir(TESTSUPIXS);
	testSupixList = testSupixList(3:end);
	trainSupixList = dir(TRAINSUPIXS);
	trainSupixList = trainSupixList(3:end);
	
	su1name = [testImgName(1:end-3),'S1.csv'];
	su2name = [testImgName(1:end-3),'S2.csv'];
	su3name = [testImgName(1:end-3),'S3.csv'];
	S1 = imread(fullfile(TESTSUPIX,su1name))
	S2 = imread(fullfile(TESTSUPIX,su2name))
	S3 = imread(fullfile(TESTSUPIX,su3name))

	
