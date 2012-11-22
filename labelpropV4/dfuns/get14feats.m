function feats = get14feats(mask,textons,I)
% return the 14 feats as described in CVPR2008
% Tomasz Malisiewicz (tomasz@cmu.edu)

%  --- shape ---
%1: centered mask
%2: bb extent
%3: area

% --- texture ---
%4: hist1
%5: hist2
%6: hist3
%7: hist4
%8: hist_all

% --- color ---
%9: mean color
%10: std color
%11: color hist

% --- position ---
%12: abs mask
%13: top-height
%14: bot-height

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%  --- shape ---
%1: centered mask
%2: bb extent
%3: area (number of pixels)

centered_masksize = [32 32];
[feats{1},feats{2},feats{3}]=feats14_shape(mask,centered_masksize);

% --- texture ---
%4: hist1
%5: hist2
%6: hist3
%7: hist4
%8: hist_all

[feats{4},feats{5},feats{6},feats{7},feats{8}]=feats14_texture(mask,textons);

% --- color ---
%9: mean color
%10: std color
%11: color hist

[feats{9},feats{10},feats{11}]=feats14_color(mask,I);

% --- position ---
%12: abs mask
%13: top-height
%14: bot-height

abs_masksize = [8 8];
[feats{12},feats{13},feats{14}]=feats14_position(mask,abs_masksize);

for i = 4:8
  feats{i} = feats{i} ./ sum(feats{i},1);
  feats{i}(isnan(feats{i}))=0;
end
    