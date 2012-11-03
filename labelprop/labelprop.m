global HOMEIMAGES HOMESP

HOMEIMAGES = 'MSRC'; 
HOMESP = 'MSRC_SP'
testImgName = '5_26_s.bmp';
k = 3;

knnImgs = findkNN(testImgName,k);
genSp(testImgName,knnImgs)
    
	
%'MSRC/5_26_s.bmp'    'MSRC/5_20_s.bmp'    'MSRC/5_23_s.bmp'    'MSRC/1_15_s.bmp'

