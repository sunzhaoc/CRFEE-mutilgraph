function result = knnclassification(samples,labels,testsamples,Knn,type)

% Classify using the Nearest neighbor algorithm
% Usage:
% Inputs:
% 	samples: Train samples
%	labels: Train labels
%   testsamples: Test  samples
%	Knn: Number of nearest neighbors
%   type: Type of distance
%
% Outputs
%	result	- Predicted targets
%
% Author: Liefeng bo
% School of electronic engineering, Xidian University
% April, 2006

if nargin < 5
    type = '2norm';
end

L			= length(labels);
Uc          = unique(labels);

if (L < Knn),
    error('You specified more neighbors than there are points.')
end

N                   = size(testsamples, 1);
result              = zeros(N,1);
switch type
    case '2norm'
        a = sum(testsamples.*testsamples,2);%将testsamples.*testsamples的每一行加起来,.*表示每个数乘以每个数，不是矩阵的乘，相当于每个数平方
        b = sum(samples.*samples,2);
        dist = repmat(a,1,L) + repmat(b',N,1) - 2*testsamples*samples';
        [sdist,indices] = sort(dist,2);
        for i = 1:N,
            n            = hist(labels(indices(i,1:Knn)), Uc);
            [m, best]    = max(n);
            result(i)    = Uc(best);
        end
    case '1norm'
        for i = 1:N,
            dist            = sum(abs(samples - ones(L,1)*testsamples(i,:)),2);
            [m, indices]    = sort(dist);
            n               = hist(labels(indices(1:Knn)), Uc);
            [m, best]       = max(n);
            result(i)        = Uc(best);
        end
    case 'Inf'
        for i = 1:N,
            dist            = max(abs(samples - ones(L,1)*testsamples(i,:)),[],2);
            [m, indices]    = sort(dist);
            n               = hist(labels(indices(1:Knn)), Uc);
            [m, best]       = max(n);
            result(i)        = Uc(best);
        end
    case 'match'
        for i = 1:N,
            dist            = sum(samples == ones(L,1)*testsamples(i,:),2);
            [m, indices]    = sort(dist);
            n               = hist(labels(indices(1:Knn)), Uc);
            [m, best]       = max(n);
            result(i)        = Uc(best);
        end
    otherwise
        error('Unknown measure function');
end