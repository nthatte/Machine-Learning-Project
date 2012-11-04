%Connect supersuperpixel borders

imgName = '/usr0/home/nitisht/Documents/MLProject/labelprop/Toy/2_22_s'
tic;
%load susu: coarse superpixels and su: fine superpixels
susu   = dlmread(strcat(imgName,'.S2.csv'));
su = dlmread(strcat(imgName,'.S3.csv'));

%make copies
sucx = su;
sucy = su;

numSupix = max(su(:));


%find edges of coarse
diffsusuy = diff(susu);
diffsusuy(end + 1,:) = 0;

diffsusux = diff(susu,1,2);
diffsusux(:,end + 1) = 0;

%find edges of fine
diffsuy = diff(su);
diffsuy(end + 1,:) = 0;

diffsux = diff(su,1,2);
diffsux(:,end + 1) = 0;

%mask edges of fine with edges of coarse
diffsux(diffsux == 0) = 0;
diffsuy(diffsuy == 0) = 0;

%find relative change in superpixels between supersuper pixels
sucx(diffsux == 0) = 0;
sucy(diffsuy == 0) = 0;

%find absolute change
transx = sucx + diffsux;
transy = sucy + diffsuy;

%generate adjacency matrix
adjMat = zeros(numSupix);
adjMat(sub2ind(size(adjMat),transx(transx ~= 0), sucx(sucx ~= 0))) = 1;
adjMat(sub2ind(size(adjMat),transy(transy ~= 0), sucy(sucy ~= 0))) = 1;
adjMat = adjMat + adjMat';
adjMat(adjMat > 0) = 1;
time = toc;
fprintf('connecting supersuperpixels done in %f seconds \n',time)

%Connect superpixels within supersuperpixel
susus = unique(susu);
for susuNum = susus'
	susuMask = susu == susuNum;
	uniquein = unique(su(susuMask));
	adjMat(uniquein,uniquein) = 1;
end	

adjMat(1:length(adjMat)+1:length(adjMat)^2) = 0;

dlmwrite(strcat(imgName,'.adj23.csv'),adjMat);

%{plot stuff
figure(1)
[susugx, susugy]= gradient(susu);
susug = susugx.^2 + susugy.^2;
bord = ones(size(susug));
bord(susug ~= 0) = 0;
h = imagesc(su);
set(h,'AlphaData',bord)
colorbar
colormap jet

set(gca, 'YTick', []);
set(gca, 'XTick', []);
axis image
print -dpdf './adjmat_tests/su.pdf'

figure(2)
imagesc(adjMat)
axis image
print -dpdf './adjmat_tests/adj.pdf'
%}
