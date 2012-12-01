function [data,labels,centers] = generate_data(NDIM,npeaks,npoints);
%generates synthetic data
%Author: Tomasz Malisiewicz (tomasz@cmu.edu)

if ~exist('NDIM')
  NDIM = 3;
end

if ~exist('npeaks')
  npeaks = 7;
end

if ~exist('npoints')
  npoints = 200;
end

%factor controls how evenly spaced the clumps are
factor = npeaks*1;


centers = factor*randn(NDIM,npeaks);

data = [];
labels = [];

for i = 1:npeaks
  curdata = randn(NDIM,npoints);
  matty = randn(NDIM,NDIM);
  [u,w,v] = svd(matty);
  w = diag(randn(NDIM,1)*.5+1);
  w(find(rand(size(w)))<.1)=0;
  matty = u*w*u';

  curdata = matty*curdata;
  curdata = curdata + repmat(centers(:,i),1,npoints);

  data = [data curdata];
  labels = [labels; i*ones(npoints,1)];
end
