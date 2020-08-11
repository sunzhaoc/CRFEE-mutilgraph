% function [eigvector, eigvalue,me,Y] = DLA(data,options)
function [eigvector, eigvalue] = DLA(data,options)
% Patch alignment & Discriminative Locality Alignment (DLA)
%             Input:
%               data    - Data matrix
%               options - Struct value in Matlab. The fields in options
%                         that can be set:
%                            ReducedDim   -  The dimensionality of the
%                                            reduced subspace. If 0,
%                                            all the dimensions will be
%                                            kept. Default is 0.
%                            PCARatio     -  The percentage of principal
%                                            component kept in the PCA
%                                            step. The percentage is
%                                            calculated based on the
%                                            eigenvalue. Default is 1
%                                            (100%, all the non-zero
%                                            eigenvalues will be kept.
%                            gnd          -  Label information
%                            k1           -  number of Neighbour
%                                            Measurements of a Same Class
%                            k2           -  number of Neighbour
%                                            Measurements of Different Classes
%                            w            -  scaling factor
%             Output:
%               eigvector - Each column is an embedding function, for a new
%                           data point (row vector) x,  y = x*eigvector
%                           will be the embedding result of x.
%               eigvalue  - The eigvalue of DLA eigen-problem. sorted from
%                           smallest to largest.
%Reference: T.Zhang, D.Tao, X.Li, J.Yang, "Patch Alignment for Dimensionality
%Reduction", IEEE Transactions on Knowledge and Data Engineering, Vol. 21, No. 9, pp: 1299-1313,2009
%& T.Zhang, D.Tao, J.Yang, "Discriminative Locality Alignment", 
%In Proceeding of 10th European Conference on Computer Vision, Vol. 5302, pp. 725-738, 2008.


[N,D1]=size(data);   
gnd=options.gnd;
d=options.ReducedDim;
K=N-1;
k1=options.k1;k2=options.k2;w=options.w;%k1, k2 and the scaling factor

Label = unique(gnd);  
nLabel = length(Label);  
Ni_label=N/nLabel;

%%%%%%%%%%%%%%%%%%%%%%%%
%%the arbitrary point and its same class points
% neighborhood = ones(K,N);
for i=1:N
    classIdx = find(gnd==gnd(i));  
    classIdx(find(classIdx==i))=[];  
    NI2{i}=[i;classIdx];%%the label information; the given point and its same-class points
end;
%%%%%%%%%%%%%%%%%%%%%%%
%%the arbitrary point and its same class points
data=data';
[m,N] = size(data);  % m is the dimensionality of the input sample points.

% Step 0:  Neighborhood Index
if d>m  
    d = m;
end
if nargin<4 
    if length(K)==1 %
        K = repmat(K,[1,N]); 
    end;
    NI = cell(1,N);
    if m>N  
        a = sum(data.*data); 
        dist2 = sqrt(repmat(a',[1 N]) + repmat(a,[N 1]) - 2*(data'*data));
          
        for i=1:N  
            % Determine ki nearest neighbors of x_j
            [dist_sort,J] = sort(dist2(:,i));  
            Ii = J(1:K(i)+1);  
            NI{i} = Ii; 
        end;
    else 
        for i=1:N
            % Determine ki nearest neighbors of x_j
            x = data(:,i);
            ki = K(i); %K = N-1
            dist2 = sum((data-repmat(x,[1 N])).^2,1);  
            [dist_sort,J] = sort(dist2);
            Ii = J(1:ki+1); % ki + 1 = N
            NI{i} = Ii;
        end;
    end;
else
    K = zeros(1,N);
    for i=1:N
        K(i) = length(NI{i});
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B = zeros(N);
B=sparse(B);
for i=1:N
    Ii = NI{i};
    Ii2=NI2{i};

    ki=K(1);%%number of neighbors

    j=0;
    for tt=1:ki
        if isempty(find(Ii2==Ii(tt+1)))==1 
            j=j+1;
            Ii3(j)=Ii(tt+1); 
        end;
    end;%%%

    j=0;
    Ii5=[];
    for m=1:K
        if isempty(find(Ii2==Ii(m+1)))==0;
            j=j+1;
            Ii5(j)=Ii(m+1); 
        end;
    end;

    Ii4=[i,Ii5(1:k1),Ii3(1:k2)];%%indics for the patch
    wi=[ones(1,k1),w.*ones(1,k2)];%%coefficients vector
    %wi=[ones(1,Ni_label-1),-[0.1,0.1,0.1].*ones(1,fa)];
    MM=[-ones(1,k1+k2);eye(k1+k2)]; % k1+k2 by k1+k2
    BI=MM*diag(wi)*MM';
    B(Ii4,Ii4) = B(Ii4,Ii4)+BI;%% contruct the alignment matrix
    clear Ii1;
    clear Ii2;
    clear Ii3;
    clear Ii4;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DPrime = data*data'; 
DPrime = (DPrime+DPrime')/2;
LPrime = data*B*data';
LPrime = (LPrime+LPrime')/2;

[eigvector, eigvalue] = eig(LPrime); %%standard eigenvalue problem
eigvalue=diag(eigvalue);
[junk, index] = sort(eigvalue);
eigvalue = eigvalue(index);
eigvector = eigvector(:,index);
eigvector = eigvector(:, 1:d);
for i = 1:size(eigvector,2)
    eigvector(:,i) = eigvector(:,i)./norm(eigvector(:,i));
end
% eigvector = eigvector_PCA*eigvector;
eigvector = eigvector;



