% PLOT2DCLUSTERS Plots a set of differently colored point clusters.
%   PLOT32CLUSTERS( DATA, LABELS, MEANS ,msize) plots the 3D data DATA with each of
%   its different clusters as different colors. The cluster means and
%   labels are specified by LABELS and MEANS respectively.
%

function plot2dclusters( data, labels, means , msize)

if ~exist('msize','var')
  msize = 6;
end
clf
n = length(unique(labels));

colors = colorcube(10);
% plot each cluster
for label = 1:n

    % pick random color
    color = colors(label,:);
    cluster = data( :, find( labels == label ) );
    plot(cluster(1,:),cluster(2,:),'.','Color', ...
          color,'MarkerSize',msize); hold on;
    
    if exist('means','var')
      plot(means(1,label), means(2,label), 'ko', ...
           'MarkerSize', 30.0, 'LineWidth', 4.0);
      plot(means(1,label), means(2,label), 'kx', ...
           'MarkerSize', 24.0, 'LineWidth', 4.0);
    end
end

if exist('means','var')
  % plot each cluster
  for label = 1:size(means,2)
    
    plot(means(1,label), means(2,label), 'ko', ...
          'MarkerSize', 30.0, 'LineWidth', 4.0);
    plot(means(1,label), means(2,label), 'kx', ...
          'MarkerSize', 24.0, 'LineWidth', 4.0);
    
  end
end

grid on;
    
    
