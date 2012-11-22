%driver code
%Author: Aravindh Mahendran (amahend1@andrew.cmu.edu)
function feats=getFeatsAll(imageFilenames)
%feats = getFeatsAll(imageFilenames) - get features for all the images
%  imagesFilenames - cellarray containing strings of file paths
%  feats - cell array of cell arrays containing the features for each
%  images
load TextonLibrary.mat TextonLibrary;
load fb.mat fb;
feats = cell(numel(imageFilenames),1);
for i=1:numel(imageFilenames)
    I = imread(imageFilenames{i});
    [textonmap, confmap] = compute_textons(I, fb, TextonLibrary);
    Idouble = im2double(I);
    Iseg = imread([imageFilenames{i} '.seg.ppm']);
    Iseggray = rgb2gray(Iseg);
    v = unique(Iseggray(:));
    feats{i} = cell(size(v,1),1);
    for j=1:size(v,1)
        mask = (Iseggray == v(j));
        feats{i}{j} = get14feats(mask,textonmap, Idouble);
    end
end
end
 