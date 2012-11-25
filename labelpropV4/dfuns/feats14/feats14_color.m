function [m,s,h]=feats14_color(mask,I)
% Compute Color Features for a segment in an Image
% Tomasz Malisiewicz (tomasz@cmu.edu)
HISTDELTA = 0:.1:1;

IHSV = rgb2hsv(I);
Ih = IHSV(:,:,1);
Is = IHSV(:,:,2);
Iv = IHSV(:,:,3);

npix = sum(mask(:));

%handle null mask
if sum(mask(:))==0
  fprintf(1,'need to write null mask handler here\n');
  keyboard
end

    
h = [hist(Ih(mask),HISTDELTA) ...
     hist(Is(mask),HISTDELTA) ...
     hist(Iv(mask),HISTDELTA)]'/npix;

m = [mean(Ih(mask)); ... 
     mean(Is(mask)); ...
     mean(Iv(mask))];

s = [std(Ih(mask)); ...
     std(Is(mask)); ...
     std(Iv(mask))];

