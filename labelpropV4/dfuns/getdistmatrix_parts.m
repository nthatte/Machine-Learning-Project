function distmat = getdistmatrix_parts(testfeats,trainfeats,betas,CHUNKSIZEgoal)
% Computes Distance Matrix According to Distance Functions which
% are linear combinations of elementary distances
% Tomasz Malisiewicz (tomasz@cmu.edu)
% Input:  
% testfeats  : 1 X D cell array where testfeats{i} is [idim x Ntest]
% trainfeats: 1 x D cell array where trainfeats{i} is [idim x Ntrain]
% betas: [D+1 x Ntrain] coefficient matrix where betas(1,:) are the offsets
% ChunkSizeGoal: the maximum chunk size so that we only process
%                reduced distance matrices in memory
% Output: 
% distmat : A Ntest x Ntrain distance matrix where the following
% formula is satisified
% distmat(i,j) = betas(1,j) + sum_{k=1}^D [ betas(k+1,j) *
% L2dist(testfeats{k}(:,i),trainfeats{k}(:,j)) ]


b0 = betas(1,:);
betas = betas(2:end,:);

F = length(trainfeats);
SOUPSIZE = size(testfeats{1},2);
E = size(trainfeats{1},2);
distmat = zeros(SOUPSIZE,E);

if ~exist('CHUNKSIZEgoal','var')
  maxsize = 2000*2000;
  CHUNKSIZEgoal = maxsize / SOUPSIZE;
  possibles = floor(E./(1:1000));
  CHUNKSIZEgoal = possibles(find(possibles<CHUNKSIZEgoal,1,'first'));

  if length(CHUNKSIZEgoal) == 0
    fprintf(1,'something very big was input here, check out problem!\n');
    CHUNKSIZEgoal = 500;
  end
end



partitioninds = do_partition(1:E,CHUNKSIZEgoal);
fprintf(1,'#partitions: %d\n',length(partitioninds));
for i = 1:length(partitioninds)
  fprintf(1,'.');
  inds = partitioninds{i};
  CHUNKSIZE = length(inds);

  allzBIG = zeros(SOUPSIZE,CHUNKSIZE,F);

  for j = 1:F
    z = sqrt(distSqr_fast(testfeats{j},trainfeats{j}(:,inds)));
    allzBIG(:,:,j) = z;
  end

  allzBIG = reshape(allzBIG,[],F);
  betaBIG = reshape(repmat(betas(:,inds),[SOUPSIZE 1]),F,[])';

  kern=sum(allzBIG .* betaBIG,2);
  pmat = reshape(kern,SOUPSIZE,CHUNKSIZE);

  pmat = pmat + repmat(b0(inds),SOUPSIZE,1);

  distmat(:,inds) = pmat;
end
fprintf(1,'\n');
