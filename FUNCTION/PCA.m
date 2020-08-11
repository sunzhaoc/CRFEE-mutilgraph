function [eigvector, eigvalue,new_data,elapse] = PCA(data, options)
%PCA	Principal Component Analysis
%
%	Usage:
%       [eigvector, eigvalue] = PCA(data, options)
%       [eigvector, eigvalue] = PCA(data)
% 
%             Input:
%               data       - Data matrix. Each row vector of fea is a data
%                            point. ������*������
%
%     options.ReducedDim   - The dimensionality of the reduced subspace. If 0,
%                         all the dimensions will be kept. 
%                         Default is 0. ?
%
%             Output:
%               eigvector - Each column is an embedding function, for a new
%                           data point (row vector) x,  y = x*eigvector
%                           will be the embedding result of x.
%               eigvalue  - The sorted eigvalue of PCA eigen-problem. 
%
%	Examples:
% 			fea = rand(7,10);
% 			[eigvector,eigvalue] = PCA(fea,4);
%           Y = fea*eigvector;
% 
%   version 2.2 --Feb/2009 
%   version 2.1 --June/2007 
%   version 2.0 --May/2007 
%   version 1.1 --Feb/2006 
%   version 1.0 --April/2004 
%
%   Written by Deng Cai (dengcai2 AT cs.uiuc.edu)
%                                                   

if (~exist('options','var'))   %���options������ a variable in the workspace,optionsΪ�վ���
   options = [];
end

ReducedDim = 0;
if isfield(options,'ReducedDim')  %���options�Ƿ����ReducedDim����Ϊ1����Ϊ0
    ReducedDim = options.ReducedDim;
end

[nSmp,nFea] = size(data);
if (ReducedDim > nFea) || (ReducedDim <=0)  %��
    ReducedDim = nFea;
end

tmp_T = cputime;

if issparse(data)   %dataΪϡ����󷵻�1�����򷵻�0
    data = full(data);   %��ϡ�����ת��Ϊ��ϡ����
end
sampleMean = mean(data,1);  %ÿ��һ����ֵ
data = (data - repmat(sampleMean,nSmp,1));  %�����������

if nFea/nSmp > 1.0713
    % This is an efficient method which computes the eigvectors of
	% of A*A^T (instead of A^T*A) first, and then convert them back to
	% the eigenvectors of A^T*A.    
    ddata = data*data';   % Eigenvectors of A*A'
    ddata = max(ddata, ddata');
    dimMatrix = size(ddata,2);
    if dimMatrix > 1000 && ReducedDim < dimMatrix/10   % using eigs to speed up!
        option = struct('disp',0);
        [eigvector, eigvalue] = eigs(ddata,ReducedDim,'la',option);  %����ddata��ReducedDim������ֵ����Largest algebraic�£�
        eigvalue = diag(eigvalue);
    else
        [eigvector, eigvalue] = eig(ddata);
        eigvalue = diag(eigvalue);
        [junk, index] = sort(-eigvalue);
        eigvalue = eigvalue(index);
        eigvector = eigvector(:, index);
    end

    clear ddata;
    %ɾ��һЩ��С����ֵ
    maxEigValue = max(abs(eigvalue));
    eigIdx = find(abs(eigvalue)/maxEigValue < 1e-12);
    eigvalue (eigIdx) = [];
    eigvector (:,eigIdx) = [];

    eigvector = data'*eigvector;		% Eigenvectors of A^T*A
	eigvector = eigvector*diag(1./(sum(eigvector.^2).^0.5)); % Normalization
else     %ֱ����A'*A
    ddata= data'*data;
    ddata = max(ddata, ddata');
    dimMatrix = size(ddata,2);
    if dimMatrix > 1000 && ReducedDim < dimMatrix/10  % using eigs to speed up!
        option = struct('disp',0);
        [eigvector, eigvalue] = eigs(ddata,ReducedDim,'la',option);
        eigvalue = diag(eigvalue);
    else
        [eigvector, eigvalue] = eig(ddata);
        eigvalue = diag(eigvalue);
        [junk, index] = sort(-eigvalue);
        eigvalue = eigvalue(index);
        eigvector = eigvector(:, index);
    end
    
    clear ddata;
    maxEigValue = max(abs(eigvalue)); %ɾ��һЩ��С����ֵ
    eigIdx = find(abs(eigvalue)/maxEigValue < 1e-12);
    eigvalue (eigIdx) = [];
    eigvector (:,eigIdx) = [];
end

%  eigvalue (1:18) = [];  %ȥ��ǰ��������ֵ
%  eigvector (:,1:18) = [];

%����ReducedDim��ȷ��PCA�ӿռ�ά��
if ReducedDim < length(eigvalue)
    eigvalue = eigvalue(1:ReducedDim);   
    eigvector = eigvector(:, 1:ReducedDim);
end

%����PCARatio��ȷ��PCA�ӿռ�ά��
if isfield(options,'PCARatio')    %options����PCARatio����1�����򷵻�0
    sumEig = sum(eigvalue);
    sumEig = sumEig*options.PCARatio;
    sumNow = 0;
    for idx = 1:length(eigvalue)
        sumNow = sumNow + eigvalue(idx);
        if sumNow >= sumEig
            break;
        end
    end
    eigvalue = eigvalue(1:idx);
    eigvector = eigvector(:,1:idx);
end

if nargout == 4
    new_data = data*eigvector;
end
elapse = cputime - tmp_T;

