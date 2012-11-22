function model = findBestForest(testImgName)

global ALL ALLIMAGES ALLLABELS ALLSUPIX ALLWORDS TEST TESTIMAGES TESTLABELS TESTSUPIX TESTWORDS TESTFEATURES TESTADJMATS TRAIN TRAINIMAGES TRAINLABELS TRAINSUPIX TRAINWORDS TRAININTERPLABELS TRAINFEATURES TRAINADJMATS

if exist(['Test/Forests/', testImgName, '.forest.mat'])
	model = load(['Test/Forests/', testImgName, '.forest.mat']);
	model = model.model;
else
	k = 5;
	Mtrys = 4:4:40;
	Mtrys = [Mtrys, floor(sqrt(39))];
	ratios = 1.3:0.1:1.6;

	knnImgNums = findkNN(testImgName,k);

	forestParamScores = zeros(length(Mtrys),length(ratios));
	for trainImgNum = knnImgNums
		trainImgNum
		Foreststats = zeros(length(Mtrys),length(ratios),3);
		i = 1;
		for M = Mtrys
			j = 1;
			for ratio = ratios
				ratio
				M
				model = trainForest(knnImgNums(knnImgNums ~= trainImgNum), ratio, M);
				[precision, recall, specificty] = calcCrossForestStats(model, trainImgNum)
				forestStats(i,j,:) = [precision, 0.5*recall, 3*specificty];
				j = j + 1;
			end
			i =i + 1;
		end
		forestParamScores = forestParamScores+ sum(forestStats,3);
	end
	highScore = max(max(forestParamScores));
	[i, j] = find(forestParamScores == highScore);
	disp 'The best parameters are':
	ratio = ratios(j), 
	M = Mtrys(i)
	model = trainForest(knnImgNums, ratio, M);

	save(['Test/Forests/', testImgName, '.forest.mat'],'model')
end
calcForestStats(model, testImgName);
