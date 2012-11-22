function SVMstruct = findBestSVM(testImgName)

global ALL ALLIMAGES ALLLABELS ALLSUPIX ALLWORDS TEST TESTIMAGES TESTLABELS TESTSUPIX TESTWORDS TESTFEATURES TESTADJMATS TRAIN TRAINIMAGES TRAINLABELS TRAINSUPIX TRAINWORDS TRAININTERPLABELS TRAINFEATURES TRAINADJMATS

if exist(['Test/SVMstructs/', testImgName, '.SVM.mat'])
	SVMstruct = load(['Test/SVMstructs/', testImgName, '.SVM.mat']);
	SVMstruct = SVMstruct.SVMstruct;
else
	k = 5;
	Cvals = 10.^[-2:2];
	ratios = 1.0:0.1:2;

	knnImgNums = findkNN(testImgName,k);

		SVMparamScores = zeros(length(Cvals),length(ratios));
	for trainImgNum = knnImgNums
		trainImgNum
		SVMstats = zeros(length(Cvals),length(ratios),3);
		i = 1;
		for C = Cvals 
			j = 1;
			for ratio = ratios
				ratio
				C
				SVMstruct = trainSVM(knnImgNums(knnImgNums ~= trainImgNum), ratio, C);
				[precision, recall, specificty] = calcCrossSVMStats(SVMstruct, trainImgNum)
				SVMstats(i,j,:) = [precision, recall, specificty];
				j = j + 1;
			end
			i =i + 1;
		end
		SVMparamScores = SVMparamScores+ sum(SVMstats,3);
	end
	highScore = max(max(SVMparamScores));
	[i, j] = find(SVMparamScores == highScore);
	disp 'The best parameters are':
	ratio = ratios(j), 
	C = Cvals(i)
	SVMstruct = trainSVM(knnImgNums, ratio, C);

	save(['Test/SVMstructs/', testImgName, '.SVM.mat'],'SVMstruct')
end
calcSVMStats(SVMstruct, testImgName);

if 1
	pic = imread(['Test/images/', testImgName, '.bmp']);
	susu = dlmread(['Test/superPixels/', testImgName, '.S2.csv']);
	su = dlmread(['Test/superPixels/', testImgName, '.S3.csv']);

	figure(1)
	subplot(3,2,3)
	[susugx, susugy]= gradient(susu);
	susug = susugx.^2 + susugy.^2;
	bord = ones(size(susug));
	bord(susug ~= 0) = 0;
	h = imagesc(su);
	title('Superpixel Segmentation')
	%set(h,'AlphaData',bord)
	%colorbar
	colormap jet
	set(gca, 'YTick', []);
	set(gca, 'XTick', []);
	axis image

end
