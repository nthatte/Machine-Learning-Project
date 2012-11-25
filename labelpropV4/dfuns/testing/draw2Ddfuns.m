%Draw 2D distance functions
for i = 1:N
  d = -results.betas(i,1) ./ results.betas(i,2:3);
  cur = [results.feats{1}(i) results.feats{2}(i)];
  plot(cur(1)+[d(1) 0 -d(1) 0 d(1)],cur(2)+[0 d(2) 0 -d(2) 0],'k');
  hold on;
end
