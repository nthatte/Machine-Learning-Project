function [cmask,bbextent,npix] = feats14_shape(mask,newsize)
% Compute shape of segment features
% Tomasz Malisiewicz (tomasz@cmu.edu)

% center the mask
if ~exist('newsize','var')
  newsize = [32 32];
end

%handle null mask
if sum(mask(:))==0
  cmask = zeros(prod(newsize),1);
  bbextent = [0; 0];
  npix = 0;
  return
end

oldsize = size(mask);
cent = (oldsize+1)/2;

[uu,vv] = find(mask);

npix = length(uu);
bbextent = [max(uu)-min(uu); max(vv)-min(vv)];

meanpos = [(mean([min(uu) max(uu)])) ...
           (mean([min(vv) max(vv)])) ];

%meanpos = [mean(uu) mean(vv)];
offset = round(cent - meanpos);

uu = uu + offset(1);
vv = vv + offset(2);

cmask = zeros(oldsize);
cmask(sub2ind(oldsize,uu,vv))=1;

cmask = imresize(cmask,newsize);
cmask = min(1,max(cmask(:),0));


