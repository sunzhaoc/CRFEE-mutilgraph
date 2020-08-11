function [T]=CRFEEA(data,gnd,r,lemda,beta,alpha,kNN,metric)
[d,n]=size(data);
train_num=length(unique(gnd));
%% construct W and Ws
for c=1:train_num
    Xc=data(:,gnd==c);
    nc=size(Xc,2);
    t=1;
    for k=1:nc
        if k==1
            xj=Xc(:,1);
            Xj=Xc(:,2:nc);
            Zi=affine_w(Xj,nc,nc-2);
            
            aj=inv(Xj'*Xj+lemda*eye(nc-1)+beta*Zi)*Xj'*xj;
            wij=[0;aj];
        else
            xj=Xc(:,k);
            Xj(:,1:k-1)=Xc(:,1:k-1);
            Xj(:,k:nc-1)=Xc(:,k+1:nc);
            Zi=affine_w(Xj,nc,nc-2);
            
            aj=inv(Xj'*Xj+lemda*eye(nc-1)+beta*Zi)*Xj'*xj;
            wij=[aj(1:(k-1));0;aj(k:nc-1)];
        end
        W(:,t)=wij;
        t=t+1;
    end
    clear Xj aj t;
    Ws((c-1)*nc+1:c*nc,(c-1)*nc+1:c*nc)=W;
end
Ws=(eye(n)-Ws)*(eye(n)-Ws)';
Sw=data*Ws*data';
%% construct Wb and Sb
for i=1:train_num
    tempdata=data(:,find(gnd==i));
    tempmean=mean(tempdata,2);
    meanmat(:,i)=tempmean;
end

t=1;
for c=1:train_num
    if c==1
        xb=meanmat(:,1);
        Xb=meanmat(:,2:train_num);
        Zb=affine_w(Xb,train_num,kNN);
        
        bj=inv(Xb'*Xb+lemda*eye(train_num-1)+beta*Zb)*Xb'*xb;
        wbij=[0;bj];
    else
        xb=meanmat(:,c);
        Xb(:,1:c-1)=meanmat(:,1:c-1);
        Xb(:,c:train_num-1)=meanmat(:,c+1:train_num);
        Zb=affine_w(Xb,train_num,kNN);
        
        bj=inv(Xb'*Xb+lemda*eye(train_num-1)+beta*Zb)*Xb'*xb;
        wbij=[bj(1:(c-1));0;bj(c:train_num-1)];
    end
    Wb(:,t)=wbij;
    t=t+1;
end
Wb=(eye(train_num)-Wb)*(eye(train_num)-Wb)';
Sb=meanmat*Wb*meanmat';
%%
S=Sb-alpha*Sw;
%% eigvetor T
opts.disp = 0;
[eigvec,eigval_matrix]=eigs(S,r,'LR',opts);

eigval=diag(eigval_matrix);
[sort_eigval,sort_eigval_index]=sort(eigval);
T0=eigvec(:,sort_eigval_index(end:-1:1));
% T=T0;

switch metric %determine the metric in the embedding space
    case 'weighted'
        T=T0.*repmat(sqrt(sort_eigval(end:-1:1))',[d,1]);
    case 'orthonormalized'
        [T,dummy]=qr(T0,0);
    case 'plain'
        T=T0;
end












% function [T]=Lap_CRNPP(data,gnd,r,lemda,alpha,beta,kNN,metric)
% [d,n]=size(data);
% train_num=length(unique(gnd));
% %% construct W and Ws
% for c=1:train_num
%     Xc=data(:,gnd==c);
%     nc=size(Xc,2);
%     t=1;
%     for k=1:nc
%         if k==1
%             xj=Xc(:,1);
%             Xj=Xc(:,2:nc);
%
%             Xc2=sum(Xj.^2,1);
%             distance2=repmat(Xc2,nc-1,1)+repmat(Xc2',1,nc-1)-2*Xj'*Xj;
%             [sorted,index]=sort(distance2);
%             kNNdist2=sorted(kNN+1,:);
%             sigma=sqrt(kNNdist2);
%             localscale=sigma'*sigma;
%             flag=(localscale~=0);
%             A=zeros(nc-1,nc-1);
%             A(flag)=exp(-distance2(flag)./localscale(flag));
%
%             localD= diag(sum(A));
%             Zi=localD-A;
%
%             aj=inv(Xj'*Xj+lemda*eye(nc-1)+beta*Zi)*Xj'*xj;
%             wij=[0;aj];
%         else
%             xj=Xc(:,k);
%             Xj(:,1:k-1)=Xc(:,1:k-1);
%             Xj(:,k:nc-1)=Xc(:,k+1:nc);
%
%             Xc2=sum(Xj.^2,1);
%             distance2=repmat(Xc2,nc-1,1)+repmat(Xc2',1,nc-1)-2*Xj'*Xj;
%             [sorted,index]=sort(distance2);
%             kNNdist2=sorted(kNN+1,:);
%             sigma=sqrt(kNNdist2);
%             localscale=sigma'*sigma;
%             flag=(localscale~=0);
%             A=zeros(nc-1,nc-1);
%             A(flag)=exp(-distance2(flag)./localscale(flag));
%
%             localD= diag(sum(A));
%             Zi=localD-A;
%
%             aj=inv(Xj'*Xj+lemda*eye(nc-1)+beta*Zi)*Xj'*xj;
%             wij=[aj(1:(k-1));0;aj(k:nc-1)];
%         end
%         W(:,t)=wij;
%         t=t+1;
%     end
%     clear Xj aj t;
%     Ws((c-1)*nc+1:c*nc,(c-1)*nc+1:c*nc)=W;
% end
%  Ws=(eye(n)-Ws)*(eye(n)-Ws)';
%  Sw=data*Ws*data';
% %% construct Wb and Sb
%  for c=1:train_num
%      Xb=data(:,gnd~=c);
%      t=1;
%      for k=1:nc
%          if c==1
%              xj=data(:,k);
%
%             Xb2=sum(Xb.^2,1);
%             distance2=repmat(Xb2,n-nc,1)+repmat(Xb2',1,n-nc)-2*Xb'*Xb;
%             [sorted,index]=sort(distance2);
%             kNNdist2=sorted(kNN+1,:);
%             sigma=sqrt(kNNdist2);
%             localscale=sigma'*sigma;
%             flag=(localscale~=0);
%             B=zeros(n-nc,n-nc);
%             B(flag)=exp(-distance2(flag)./localscale(flag));
%
%             localD= diag(sum(B));
%             Zb=localD-B;
%
%              bj=inv(Xb'*Xb+lemda*eye(n-nc)+beta*Zb)*Xb'*xj;
%              wbij=[zeros(nc,1);bj];
%          elseif c>1&&c<train_num
%              xj=data(:,k);
%
%             Xb2=sum(Xb.^2,1);
%             distance2=repmat(Xb2,n-nc,1)+repmat(Xb2',1,n-nc)-2*Xb'*Xb;
%             [sorted,index]=sort(distance2);
%             kNNdist2=sorted(kNN+1,:);
%             sigma=sqrt(kNNdist2);
%             localscale=sigma'*sigma;
%             flag=(localscale~=0);
%             B=zeros(n-nc,n-nc);
%             B(flag)=exp(-distance2(flag)./localscale(flag));
%
%             localD= diag(sum(B));
%             Zb=localD-B;
%
%              bj=inv(Xb'*Xb+lemda*eye(n-nc)+beta*Zb)*Xb'*xj;
%              wbij=[bj(1:(c-1)*nc);zeros(nc,1);bj((c-1)*nc+1:end)];
%          else
%              xj=data(:,k);
%
%             Xb2=sum(Xb.^2,1);
%             distance2=repmat(Xb2,n-nc,1)+repmat(Xb2',1,n-nc)-2*Xb'*Xb;
%             [sorted,index]=sort(distance2);
%             kNNdist2=sorted(kNN+1,:);
%             sigma=sqrt(kNNdist2);
%             localscale=sigma'*sigma;
%             flag=(localscale~=0);
%             B=zeros(n-nc,n-nc);
%             B(flag)=exp(-distance2(flag)./localscale(flag));
%
%             localD= diag(sum(B));
%             Zb=localD-B;
%
%              bj=inv(Xb'*Xb+lemda*eye(n-nc)+beta*Zb)*Xb'*xj;
%              wbij=[bj;zeros(nc,1)];
%          end
%          W1(:,t)=wbij;
%          t=t+1;
%      end
%      clear bj t;
%      Wb((c-1)*nc+1:c*nc,:)=W1';
%  end
%  Wb=(eye(n)-Wb)*(eye(n)-Wb)';
%  Sb=data*Wb*data';
% %%
%  S=Sb-alpha*Sw;
% %% eigvetor T
% if r==d
%   [eigvec,eigval_matrix]=eigs(S);
% else
%   opts.disp = 0;
%   [eigvec,eigval_matrix]=eigs(S,r,'LR',opts);
%  end
% eigval=diag(eigval_matrix);
% [sort_eigval,sort_eigval_index]=sort(eigval);
% T0=eigvec(:,sort_eigval_index(end:-1:1));
% % T=T0;
%
% switch metric %determine the metric in the embedding space
%   case 'weighted'
%    T=T0.*repmat(sqrt(sort_eigval(end:-1:1))',[d,1]);
%   case 'orthonormalized'
%    [T,dummy]=qr(T0,0);
%   case 'plain'
%    T=T0;
% end
%
%
%
%