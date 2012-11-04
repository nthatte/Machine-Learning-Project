global ALL ALLIMAGES ALLLABELS ALLSUPIX ALLWORDS TEST TESTIMAGES TESTLABELS TESTSUPIX TESTWORDS TRAIN TRAINIMAGES TRAINLABELS TRAINSUPIX TRAINWORDS TRAININTERPLABELS 

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

TRAIN = 'Train';
TRAINIMAGES = 'Train/images';
TRAINLABELS = 'Train/labels';
TRAINSUPIX  = 'Train/superPixels';
TRAINWORDS  = 'Train/wordMaps';
TRAININTERPLABELS = 'Train/labels_interp'
testImgName = '2_22_s.bmp'
k = 3;

calcGist()
knnImgs = findkNN(testImgName,k)
%{genSp(testImgName,knnImgs)
    
	
%'MSRC/5_26_s.bmp'    'MSRC/5_20_s.bmp'    'MSRC/5_23_s.bmp'    'MSRC/1_15_s.bmp'
%}
