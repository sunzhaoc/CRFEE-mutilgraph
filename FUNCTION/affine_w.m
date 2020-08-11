function Zi=affine_w(Xj,nc,kNN)            
Xc2=sum(Xj.^2,1);
distance2=repmat(Xc2,nc-1,1)+repmat(Xc2',1,nc-1)-2*Xj'*Xj;
[sorted,index]=sort(distance2);
kNNdist2=sorted(kNN+1,:);
sigma=sqrt(kNNdist2);
localscale=sigma'*sigma;
flag=(localscale~=0);
A=zeros(nc-1,nc-1);
A(flag)=exp(-distance2(flag)./localscale(flag));

localD= diag(sum(A));
Zi=localD-A;