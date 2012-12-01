function [beta,d,params] = svm_squared_hinge(z,y,betastart,lam)
%learn the linear decision boundary by solving a squared hinge loss
%SVM problem with no constraints on the beta
% Tomasz Malisiewicz (tomasz@cmu.edu)

lambda = lam*length(y);

[w,b0,obj] = primal_svm(1,y,lambda,z,betastart);

beta = [b0; w];
d = z*w + b0;

