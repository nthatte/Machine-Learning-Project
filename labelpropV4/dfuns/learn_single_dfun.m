function learning_res = learn_single_dfun(zfull, ...
                                          beta,labels,index,otherparams)
%Learn a single distance function
% Tomasz Malisiewicz (tomasz@cmu.edu)
%
%Iterative learning procedure that given distance function
%estimates the active neighbors, and then given active neighbors
%learns a new distance function.  This procedure is repeated until
%the active neighbors don't change (convergence).

%N: the number of data points
%K: the number of elementary distances
%zfull: the matrix of elementary distances: [K x N]
%beta: the initial distance function [(K+1) x 1]
%labels: the labels of data points [N x 1]
%index: the index of the current data point [1 x 1]
%otherparams: the learning parameters including obj-fun [struct]
%learning_res:results of learning

%Tomasz Malisiewicz 2008
%Carnegie Mellon University

%get the label of the current point
mylabel = labels(index);

%apply distance function to get all distances
%here the distances can be negative (on similar side) or positive
%(on dis-similar side)
dfull = zfull * beta(2:end) + beta(1);

%if otherparams.SHOW == 1
%  otherparams.showfun(index,beta,dfull,mylabel,[11 12 13]);
%end

%get the positive support set
[pos_support,all_support_inds,all_support_classes] = ...
    get_support_set(dfull,mylabel,labels,otherparams);

pos_support_initial = pos_support;

for iterations = 1:otherparams.MAXNITERS

  %if otherparams.SHOW == 1
  %  otherparams.showfun(i,beta,dfull,mylabel,[1 2 3]);
  %  pause
  %end

  oldbeta = beta;

  %learn distance function given the active neighbors
  [beta] = ...
      otherparams.learn_beta(zfull(all_support_inds,:), ...
                             all_support_classes,beta);
  
  %apply distance function to all data
  dfull = zfull * beta(2:end) + beta(1);

  old_pos_support = pos_support;

  %get the positive support set given current distance function
  [pos_support,all_support_inds,all_support_classes] = ...
      get_support_set(dfull,mylabel,labels,otherparams);   
  
  %% stop iterating if the support set doesn't change
  if sum(~ismember(pos_support,old_pos_support))==0
    break
  end
  

  old_pos_support = pos_support;
end


if otherparams.SHOW == 1
  otherparams.showfun(index,beta,dfull,mylabel,[1 2 3]);
  pause
end

%return struct with results of distance function learning
learning_res.dfull = dfull;
learning_res.beta = beta;
learning_res.pos_support = pos_support;
learning_res.pos_support_initial = pos_support_initial;
learning_res.iterations = iterations;
