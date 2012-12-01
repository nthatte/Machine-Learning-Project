%driver code
%Author: Aravindh Mahendran (amahend1@andrew.cmu.edu)
function feats=getTextonFeats(imageFilenames)
%feats = getFeatsAll(imageFilenames) - get features for all the images
%  imagesFilenames - cellarray containing strings of file paths
%  feats - cell array of cell arrays containing the features for each
%  images
load TextonLibrary.mat TextonLibrary;
load fb.mat fb;
imgList = dir('Test/images')
imgList = imgList(3:end); %remove . and .. from list
imageFilenames = {imgList(:).name}
%imageFilenames = {'1_12_s.bmp'}
feats = cell(numel(imageFilenames),1);
textonfeats = cell(5,1);
colorfeats = cell(3,1);
for i=1:numel(imageFilenames)
    I = imread(['Test/images/',imageFilenames{i}]);
    [textonmap, confmap] = compute_textons(I, fb, TextonLibrary);
    Idouble = im2double(I);
    Iseg = dlmread(['Test/superPixels/', imageFilenames{i}(1:end-4), '.S3.csv']);
    v = unique(Iseg(:));
    feats{i} = zeros(size(v,1),539);
    for j=1:size(v,1)
        mask = (Iseg == v(j));
        [textonfeats{1}, textonfeats{2},textonfeats{3},textonfeats{4},textonfeats{5}]=feats14_texture(mask,textonmap);
        for k = 1:5
           textonfeats{k} = textonfeats{k} ./ sum(textonfeats{k},1);
           textonfeats{k}(isnan(textonfeats{k}))=0;
           feats{i}(j,((k-1)*100 + 1):(k*100)) = textonfeats{k};
        end
		[colorfeats{1},colorfeats{2},colorfeats{3}]=feats14_color(mask,Idouble);
		feats{i}(j,501:503) = colorfeats{1}';
		feats{i}(j,504:506) = colorfeats{2}';
		feats{i}(j,507:539) = colorfeats{3}';
        %feats{i}{j} = get14feats(mask,textonmap, Idouble);
    end
end
end
