function [textonmap,confmap] = compute_textons(I,fb,TextonLibrary)
%compute textons for this image
%WARNING: pixels must be in range [0 255], do not run im2double first


centers = TextonLibrary';
fprintf(1,'Textonifying: ');
%compute fb responses
if size(I,3)>1
  Igray = rgb2gray(I);
else
  Igray = I;
end

[w,h] = size(Igray);

fb_response = fbRun(fb,Igray);
d2 = distSqr_fast(fb_response,centers);

[confmap,textonmap] = min(d2,[],2);
textonmap = reshape(textonmap,w,h);
confmap = reshape(confmap,w,h);
fprintf(1,' done\n');