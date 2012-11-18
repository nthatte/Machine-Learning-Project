global  TEST TESTLABELS TESTINTERPLABELS TESTSUPIX

testSupixList = dir(TESTSUPIX);
testSupixList = testSupixList(3:end);

testLabelList = dir(TESTLABELS);
testLabelList = testLabelList(3:end);

%loop over all superpixels in all images to generate labelvectors
imgnum = 1;
for supixnum = 3:3:length(testSupixList)
	imgnum
	su3name = testSupixList(supixnum).name
	supiximg = dlmread(fullfile(TESTSUPIX,su3name));

	labelname = testLabelList(imgnum).name;
	labelimg = imread(fullfile(TESTLABELS,labelname));
	labelimgR = labelimg(:,:,1);
	labelimgG = labelimg(:,:,2);
	labelimgB = labelimg(:,:,3);

	imgLabelVector = zeros(1,max(unique(supiximg)));

	for supix = 1:max(unique(supiximg))
		supixmask = supiximg == supix;
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
		
		imgLabelVector(supix) = label;
	end
	imgnum = imgnum +  1;
	su3name(1:end-7)
	save(fullfile(TESTINTERPLABELS,[su3name(1:end-7),'.labvec.mat']),'imgLabelVector')
end
