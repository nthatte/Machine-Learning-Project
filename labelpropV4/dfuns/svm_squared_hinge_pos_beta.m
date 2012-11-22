function [beta,d,params] = svm_squared_hinge_pos_beta(z,y,betastart,lam)
%Learn the linear decision boundary by solving a squared hinge loss
%SVM problem with positive constraints on the decision boundary
% Tomasz Malisiewicz (tomasz@cmu.edu)

%We solve for the decision boundary, if any of the coefficients are
%negative we remove those variables from consideration and repeat
%on the subset of the non-negative variables until no more
%variables are negative

%TODO: the ideal thing to do is gradient descent on the betas with
%projections on the positive set at each iteration

lambda = lam*length(y);

DFEATS = size(z,2);
curfeats = ones(DFEATS,1);

nevals = 0;

wreal = zeros(DFEATS,1);
b0real = 1;
while 1
  
  if sum(curfeats)==0 %% all feats were thrown out
    break
  end
  
  [w,b0,obj] = primal_svm(1,y,lambda,z(:,find(curfeats)),betastart([1; ...
                    find(curfeats)+1]));
  nevals = nevals + 1;
  if sum(w<0) == 0
    %% we are done
    wreal = zeros(DFEATS,1);
    wreal(find(curfeats))=w;
    b0real = b0;
    break
  else
    curfeats(find(curfeats)) = (w>=0);
  end
 
end

w = wreal;
b0 = b0real;

beta = [b0; w];
d = z*w + b0;

params.lambda = lambda;
params.nevals = nevals;
