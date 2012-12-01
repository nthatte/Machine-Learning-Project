%driver code
%Author: Aravindh Mahendran (amahend1@andrew.cmu.edu)
function feats=getColorFeats(imageFilenames)
%feats = getFeatsAll(imageFilenames) - get features for all the images
%  imagesFilenames - cellarray containing strings of file paths
%  feats - cell array of cell arrays containing the features for each
%  images
load TextonLibrary.mat TextonLibrary;
load fb.mat fb;
imgList = dir('Train/images')
imgList = imgList(3:end); %remove . and .. from list
imageFilenames = {imgList(:).name}
%imageFilenames = {'1_12_s.bmp'}
feats = cell(numel(imageFilenames),1);
colorfeats = cell(3,1);
for i=1:numel(imageFilenames)
    i
    I = imread(['Train/images/',imageFilenames{i}]);
    Idouble = im2double(I);
    Iseg = dlmread(['Train/superPixels/', imageFilenames{i}(1:end-4), '.S3.csv']);
    v = unique(Iseg(:));
    feats{i} = zeros(size(v,1),39);
    for j=1:size(v,1)
        mask = (Iseg == v(j));
		[colorfeats{1},colorfeats{2},colorfeats{3}]=feats14_color(mask,Idouble);
		feats{i}(j,1:3) = colorfeats{1}';
		feats{i}(j,4:6) = colorfeats{2}';
		feats{i}(j,7:39) = colorfeats{3}';
    end
end

end


