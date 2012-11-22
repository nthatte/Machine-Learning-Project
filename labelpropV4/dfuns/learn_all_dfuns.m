function [parts,learning_res_list]=learn_all_dfuns(feats,labels,betas,traininds, ...
                                                  otherparams)
%Main Driver For Distance Function Learning
% Tomasz Malisiewicz (tomasz@cmu.edu)
%
%Big For-loop driver that computes elementary distances
%cleverly and inputs those into the independent learning module

%Given features

%N: the number of data points
%K: the number of elementary distances

%feats: the feature cell matrix of length K
%feats{i}: i-th feature [Dim_i x N]
%labels: the labels of data points [N x 1]
%betas: the initial distance functions [(K+1) x N]
%traininds: the indices of the distance functions to-learn [T x 1]
%otherparams: the learning parameters including obj-fun [struct]

%Speed up based on processing chunks at a time
%Rather than computing INFEASIBLE elementary distance matrix of
%size [N x N x K], only compute dists as [PSIZE x N x K]

%chunk the data into chunks of size PSIZE to speed up computations
parts = do_partition(traininds,otherparams.PSIZE);

DOSAVE = isfield(otherparams,'BETASDIR');

counter = 1;
for ppp = 1:length(parts)
  fprintf(1,'Processing Part %d/%d\n',ppp,length(parts));

  %Compute Elementary Distance between chunk and all of data
  %to create [PSIZE x N x K] sized matrix
  tic
  zfull = getzfull_parts(feats,feats,parts{ppp});
  toc

  %Process each sample inside chunk independently
  for iii = 1:length(parts{ppp})
    
    index = parts{ppp}(iii);
    
    %fprintf(1,'EXEMPLAR: %d  ',index);
    
    if DOSAVE==1
      curbetafilename = sprintf([otherparams.BETASDIR ...
                    '%.5d.mat'],index);
      
      if exist(curbetafilename,'file')
        fprintf(1,'Already done!\n');
        continue
      end
    end

    %Learn distance function for this data point
    learning_res = otherparams.learning_function(zfull(:,:,iii), ...
                                                 betas(index,:)',labels,index,otherparams);
    %fprintf(1,'\n');
    
    if DOSAVE==1
      save(curbetafilename,'learning_res');
    end
    
    learning_res_list{counter}=learning_res;
    counter = counter+1;
    
  end
end


function z = getzfull_parts(testfeats,trainfeats,parts)
%Compute elementary distances between chunk and all of data

z = zeros(length(parts),size(testfeats{1},2),length(testfeats));
for i = 1:length(testfeats)
  d = distSqr_fast(trainfeats{i}(:,parts),testfeats{i});
  d(d<0)=0;
  z(:,:,i) = sqrt(d);
end
z = permute(z,[2 3 1]);
