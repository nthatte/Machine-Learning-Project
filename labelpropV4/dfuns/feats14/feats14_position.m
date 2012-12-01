function [absmask,top,bot] = feats14_position(mask,newsize)
% Compute Absolute Position Features for a segment
% Tomasz Malisiewicz (tomasz@cmu.edu)
if ~exist('newsize','var')
  newsize = [8 8];
end

if sum(mask(:))==0
  absmask = zeros(prod(newsize),1);
  top = 0;
  bot = 0;
  return
end

oldsize = size(mask);
[u,v] = find(mask);

top = min(u) / oldsize(1);
bot = max(u) / oldsize(1);


%have to make the mask double or else it will give me nearest
%neighbor interpolation
absmask = imresize(double(mask),newsize);
absmask = min(1,max(absmask(:),0));

