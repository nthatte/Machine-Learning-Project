global  TRAIN TRAINLABELS TRAINSUPIX TRAINWORDS TRAININTERPLABELS

trainSupixList = dir(TRAINSUPIX);
trainSupixList = trainSupixList(3:end);

trainLabelList = dir(TRAINLABELS);
trainLabelList = trainLabelList(3:end);

trainWordsList = dir(TRAINWORDS);
trainWordsList = trainWordsList(3:end);

histmatlen = 0;
%loop over training image for size of hist mat
for supixnum = 3:3:length(trainSupixList)
	su3name = trainSupixList(supixnum).name;
	supiximg = dlmread(fullfile(TRAINSUPIX,su3name));
	histmatlen = histmatlen + max(unique(supiximg));
end
histmatlen
numWords = 200
histMat = zeros(numWords,histmatlen);
labelvector = zeros(1,histmatlen);

%loop over all superpixels in all images to generate histogram matrix
imgnum = 1
i = 1 %global supix number
for supixnum = 3:3:length(trainSupixList)
	su3name = trainSupixList(supixnum).name
	supiximg = dlmread(fullfile(TRAINSUPIX,su3name));

	wordmapname = trainWordsList(imgnum).name
	wordmap = load(fullfile(TRAINWORDS,wordmapname));
	wordmap = wordmap.wordMap;
	
	labelname = trainLabelList(imgnum).name;
	labelimg = imread(fullfile(TRAINLABELS,labelname));
	labelimgR = labelimg(:,:,1);
	labelimgG = labelimg(:,:,2);
	labelimgB = labelimg(:,:,3);

	imgLabelVector = zeros(1,max(unique(supiximg)));
	%{
	figure(1)
	imagesc(supiximg)
	colorbar
	colormap('jet')
	figure(2)
	imshow(labelimg)
	colorbar
	%}

	for supix = 1:max(unique(supiximg))
		supixmask = supiximg == supix;
		histMat(:,i) = hist(wordMap(supixmask),1:numWords);
		i = i +1;
		R = double(labelimgR(supixmask));
		G = double(labelimgG(supixmask));
		B = double(labelimgB(supixmask));
		modeR = mode(R);
		modeG = mode(G);
		modeB = mode(B);
		
		if [modeR, modeG, modeB] == [0 0 0]
			label = 0;
		elseif [modeR, modeG, modeB] == [128 0 0 ]
			label = 1;
		elseif [modeR, modeG, modeB] ==[ 0 128 0]
			label = 2;
		elseif [modeR, modeG, modeB] == [128 128 0]
			label = 3;
		elseif [modeR, modeG, modeB] == [0 0 128]
			label = 4;
		elseif [modeR, modeG, modeB] == [128 0 128]
			label = 5;
		elseif [modeR, modeG, modeB] == [0 128 128]
			label = 6;
		elseif [modeR, modeG, modeB] ==  [128 128 128]
			label = 7;
		elseif [modeR, modeG, modeB] ==  [64 0 0 ]
			label = 8;
		elseif [modeR, modeG, modeB] ==  [192 0 0]
			label = 9;
		elseif [modeR, modeG, modeB] ==  [64 128 0]
			label = 10;
		elseif [modeR, modeG, modeB] ==  [192 128 0]
			label = 11;
		elseif [modeR, modeG, modeB] ==  [64 0 128]
			label = 12;
		elseif [modeR, modeG, modeB] ==  [ 192 0 128]
			label = 13;
		end
		
		labelvector(i) = label;
		imgLabelVector(supix) = label;
	end
	i
	imgnum = imgnum +  1
	su3name(1:end-7)
	save([TRAININTERPLABELS,'/',su3name(1:end-7),'.labvec.mat'],'imgLabelVector')
end

save(fullfile(TRAIN,'histmat.mat'),'histMat')
save(fullfile(TRAIN,'labelvect.mat'),'labelvector')
