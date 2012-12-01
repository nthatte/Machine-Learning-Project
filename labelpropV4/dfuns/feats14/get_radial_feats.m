function [curfeat,nowmask] = get_radial_feats(mask,textonmap)
% Compute texton features over interior of segment as well along
% boundaries
% Tomasz Malisiewicz (tomasz@cmu.edu)


%bug when logical
mask = double(mask);

NREGIONS = 5;
curfeat = zeros(100*NREGIONS,1);


outer = bwmorph(bwmorph(full(mask),'remove'),'dilate',2);
bigmask = bwmorph(full(mask),'dilate',2);



[u,v] = find(bigmask);
cx = (mean(u));
cy = (mean(v));

x = u - cx;
y = v - cy;

angles = atan2(x,y) + pi/4;
angles(angles>pi) = angles(angles>pi)-2*pi;
radial = mask;
normang = (angles+pi)/(pi/2);
radial(find(bigmask)) = 1+floor(normang);
nowmask = radial.*outer;
size(nowmask)
cur = 1;
for i = 1:4
  curfeat(cur:(cur+99)) = hist(textonmap(nowmask==i),1:100);
  cur = cur+100;
end

curfeat(cur:(cur+99)) = hist(textonmap(logical(mask)),1:100);

if 0
  %debug visualize regions
  figure(1), subplot(1,4,1), imagesc(textonmap), subplot(1,4,2), ...
      imagesc(outer), subplot(1,4,3), imagesc(radial), subplot(1,4,4), ...
      imagesc(nowmask)
  keyboard
end

