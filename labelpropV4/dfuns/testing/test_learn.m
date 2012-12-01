function [results]=test_learn
% learn some distance functions on synthetic dataset...
% Tomasz Malisiewicz (tomasz@cmu.edu)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DEFINE THE LEARNING FUNCTIONAL AND PARAMETERS

%if we want to write our learned distance functions, 
%a good idea for a large dataset, then define the BETASDIR
%parameter
%learning_params.BETASDIR = '/tmp/betasdir/';

%Define the Regularization Parameter
%ORIGINAL CVPR submission ONE is .00001
learning_params.lam = .00001;

learning_params.learning_function = @learn_single_dfun;

%Define the Function we are optimizing such as squared_hinge or 
%squared_hinge_pos

% Without positive constraint
%learning_params.learn_beta = @(z,y,b0) ...
%    svm_squared_hinge(z,y,b0,learning_params.lam);  

%% With positive constraint (distance weights *should* be positive)
learning_params.learn_beta = @(z,y,b0) ...
    svm_squared_hinge_pos_beta(z,y,b0,learning_params.lam);  

%The number of samples we force to be similar during each iteration
learning_params.TOPK = 20;

%Maximum number of interations.  An iteration is (learn weights
%given distance, learn distance given weights).  Empirically this
%always converged in 4-5 iterations or less on CVPR08 data.
learning_params.MAXNITERS = 20;

%Distance Function display function
%1 or 0 depending whether we show something during distance-function
%learning
%NOTE: leave at 0 unless you know what you are doing!
learning_params.SHOW = 0;

%The distance pre-computation chunk size (see learn_all_dfuns.m)
learning_params.PSIZE = 100;

if 1
  fprintf(1,'Generating Synthetic Data...\n');
  [data,labels,centers] = generate_data(2,4,200);
  
  %only 3 unique labels
  labels = (mod(labels,3)+1);
  
  N = length(labels);
  feats{1} = data(1,:);
  feats{2} = data(2,:);

  Csuper = labels';
  
  K = 2;
  
  initialbetas = ones(N,K+1);

  gtinds = 1:N;
  
  %gtinds = 1:100;
  
  plot2dclusters(data,labels);
  drawnow
  pause(.1)

end

%%%%% END GENERATE SOME DATA

[parts,learning_res_list] = ...
    learn_all_dfuns(feats,Csuper,initialbetas,gtinds, ...
                    learning_params);


%%% concatenate the betas
results.betas = zeros(length(gtinds),length(feats)+1);
results.exdists = sparse(length(Csuper),length(gtinds));

for i = 1:length(gtinds)

  if mod(i,100)==0
    fprintf(1,'.');
  end
  if mod(i,1000) == 0
    fprintf(1,'\n');
  end
  
  res = learning_res_list{i};
  b = res.beta;
  d = res.dfull;
  results.exdists(:,i) = d.*(d<0);
  results.betas(i,:) = b;

end

results.exdists = results.exdists';

results.feats = feats;
results.Csuper = Csuper;
results.gtinds = gtinds;

%Apply the distance functions to some new data points
if 0

testxs = linspace(min(results.feats{1})-2,max(results.feats{1})+2,30);
testys = linspace(min(results.feats{2})-2,max(results.feats{2})+2,30);
NTEST = length(testxs)*length(testys);

results.testfeats{1} = zeros(1,NTEST);
results.testfeats{2} = zeros(1,NTEST);
counter = 1;
for xxx = 1:length(testxs)
  for yyy = 1:length(testys)
    results.testfeats{1}(counter) = testxs(xxx);
    results.testfeats{2}(counter) = testys(yyy);
    counter = counter+1;
  end
end

results.distmat = getdistmatrix_parts(results.testfeats,results.feats, ...
                                                results.betas');

%sparsify the distances
results.distmat = sparse( results.distmat .* (results.distmat<0) );

for i = 1:NTEST
  retclass(i) = mode(results.Csuper(results.distmat(i,:)<0));
end

figure(2)
clf
colors = colorcube(10);

for kkk = 1:3
  plot(results.testfeats{1}(retclass==kkk),results.testfeats{2}(retclass==kkk),'.','Color',colors(kkk,:));
  hold on;
end

end