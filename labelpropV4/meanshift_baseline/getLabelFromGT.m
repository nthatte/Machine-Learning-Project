%Author: Aravindh Mahendran
function [label] = getLabelFromGT(Iseg, mask)
%label = getLabelFromGT(ground truth image, mask)
%    ground truth image -> color image of the ground truth 
%    mask -> binary mask matrix of the region we are interested in
labelimgR = Iseg(:,:,1);
labelimgG = Iseg(:,:,2);
labelimgB = Iseg(:,:,3);

R = double(labelimgR(mask));
G = double(labelimgG(mask));
B = double(labelimgB(mask));

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
end
