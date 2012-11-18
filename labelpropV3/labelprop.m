global ALL ALLIMAGES ALLLABELS ALLSUPIX ALLWORDS TEST TESTIMAGES TESTLABELS TESTSUPIX TESTWORDS TESTFEATURES TRAIN TRAINIMAGES TRAINLABELS TRAINSUPIX TRAINWORDS TRAININTERPLABELS TRAINFEATURES TRAINADJMATS

ALL = 'allData';
ALLIMAGES = 'allData/images';
ALLLABELS = 'allData/labels';
ALLSUPIX  = 'allData/superPixels';
ALLWORDS  = 'allData/wordMaps';

TEST = 'Test';
TESTIMAGES = 'Test/images';
TESTLABELS = 'Test/labels';
TESTSUPIX  = 'Test/superPixels';
TESTWORDS  = 'Test/wordMaps';
TESTFEATURES = 'Test/featureMats';
TESTADJMATS = 'Test/adjMats';
TESTINTERPLABELS = 'Test/labels_interp';

TRAIN = 'Train';
TRAINIMAGES = 'Train/images';
TRAINLABELS = 'Train/labels';
TRAINSUPIX  = 'Train/superPixels';
TRAINWORDS  = 'Train/wordMaps';
TRAININTERPLABELS = 'Train/labels_interp';
TRAINFEATURES = 'Train/featureMats';
TRAINADJMATS = 'Train/adjMats';

testImgName = '7_2_s'
k = 5;

calcGist()
knnImgs = findkNN(testImgName,k);
SVMstruct = trainSVM(knnImgs);

adjMat = dlmread(['Test/adjMats/', testImgName, '.adj23.csv']);
labelvect = load(['Test/labels_interp/', testImgName, '.labvec.mat']);
labelvect = labelvect.imgLabelVector;

[I, J] = find(triu(adjMat == 1));
suPairs = [I, J];
i = 1;
fp = 0;
tp = 0;
fn = 0;
actualTF = labelvect(suPairs(:,1)) == labelvect(suPairs(:,2));
actualTF = actualTF';
SVMTF = testSVM(SVMstruct,testImgName, suPairs);

tp = sum(SVMTF(SVMTF == 1) == actualTF(SVMTF == 1))
fp = sum(SVMTF(SVMTF == 1) ~= actualTF(SVMTF == 1))
tn = sum(SVMTF(SVMTF == 0) == actualTF(SVMTF == 0))
fn = sum(SVMTF(SVMTF == 0) ~= actualTF(SVMTF == 0))

precision = tp/(tp + fp)
recall = tp/(tp + fn)
specificity = tn/(tn + fp)
accuracy = (tp + tn)/(tp + fp + tn + fn)

pic = imread(['Test/images/', testImgName, '.bmp']);
susu = dlmread(['Test/superPixels/', testImgName, '.S2.csv']);
su = dlmread(['Test/superPixels/', testImgName, '.S3.csv']);
if 1
%{
	figure(1)
	imshow(pic)
	axis image
%}
	figure(2)
	[susugx, susugy]= gradient(susu);
	susug = susugx.^2 + susugy.^2;
	bord = ones(size(susug));
	bord(susug ~= 0) = 0;
	h = imagesc(su);
	set(h,'AlphaData',bord)
	colorbar
	colormap jet
	set(gca, 'YTick', []);
	set(gca, 'XTick', []);
	axis image

end
