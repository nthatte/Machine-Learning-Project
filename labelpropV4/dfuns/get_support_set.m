function [pos_support,all_support_inds,classes] = get_support_set(dfull,curC,Csuper, ...
                                                                        otherparams,isinitial)
%% take the TOPK things from the same class, do not use remaining
%examplars from same class and call everything else the 'not same'
%class
% Tomasz Malisiewicz (tomasz@cmu.edu)

if ~exist('isinitial','var')
  isinitial = 0;
end
  
if isinitial == 1
  mytopk = 10000000;
else
  mytopk = otherparams.TOPK;
end

oks = find(Csuper==curC);    
mylen = min(length(oks),mytopk);

[aaa,bbb] = sort(dfull(oks));

%Positive support is the top mylen things of same class
pos_support = oks(bbb(1:mylen));

%killers are the ones we neglect (the remaining ones of same class)
killers = [oks(bbb((mylen+1):end))];

all_support_inds = ones(length(Csuper),1);
all_support_inds(killers)=0;
all_support_inds = find(all_support_inds);

classes = (1-double(Csuper(all_support_inds) == curC)*2)';
