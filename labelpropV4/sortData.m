ALLIMAGES = 'allData/images';
ALLLABELS = 'allData/labels';
ALLSUPIX  = 'allData/superPixels';
ALLWORDS  = 'allData/wordMaps';

TESTIMAGES = 'Test/images';
TESTLABELS = 'Test/labels';
TESTSUPIX  = 'Test/superPixels';
TESTWORDS  = 'Test/wordMaps';

TRAINIMAGES = 'Train/images';
TRAINLABELS = 'Train/labels';
TRAINSUPIX  = 'Train/superPixels';
TRAINWORDS  = 'Train/wordMaps';

dirList = dir(ALLIMAGES);
dirList = dirList(3:end); %remove . and .. from list
randIndex = randperm(length(dirList));

i = 1;
for imgname = {dirList(randIndex).name}
	imgname = imgname{1}
	labelname = [imgname(1:end-4),'_GT.bmp'];
	su1name = [imgname(1:end-3),'S1.csv'];
	su2name = [imgname(1:end-3),'S2.csv'];
	su3name = [imgname(1:end-3),'S3.csv'];
	wordname = [imgname(1:end-3),'wordmap.mat'];
	if i <= length(dirList)/2
		system(['cp ',fullfile(ALLIMAGES,imgname),' ',fullfile(TESTIMAGES,imgname)])
		system(['cp ',fullfile(ALLLABELS,labelname),' ',fullfile(TESTLABELS,labelname)])
		system(['cp ',fullfile(ALLSUPIX,su1name),' ',fullfile(TESTSUPIX,su1name)])
		system(['cp ',fullfile(ALLSUPIX,su2name),' ',fullfile(TESTSUPIX,su2name)])
		system(['cp ',fullfile(ALLSUPIX,su3name),' ',fullfile(TESTSUPIX,su3name)])
		system(['cp ',fullfile(ALLWORDS,wordname),' ',fullfile(TESTWORDS,wordname)])
	else
		system(['cp ',fullfile(ALLIMAGES,imgname),' ',fullfile(TRAINIMAGES,imgname)])
		system(['cp ',fullfile(ALLLABELS,labelname),' ',fullfile(TRAINLABELS,labelname)])
		system(['cp ',fullfile(ALLSUPIX,su1name),' ',fullfile(TRAINSUPIX,su1name)])
		system(['cp ',fullfile(ALLSUPIX,su2name),' ',fullfile(TRAINSUPIX,su2name)])
		system(['cp ',fullfile(ALLSUPIX,su3name),' ',fullfile(TRAINSUPIX,su3name)])
		system(['cp ',fullfile(ALLWORDS,wordname),' ',fullfile(TRAINWORDS,wordname)])
	end
	i = i + 1;
end
