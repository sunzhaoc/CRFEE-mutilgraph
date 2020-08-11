function [Wb, Ws, meanmat]=CRFEEA_L(data, gnd, lemda, beta, kNN)
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
Ws = (eye(n)-Ws) * (eye(n)-Ws)';
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
Wb = (eye(train_num)-Wb) * (eye(train_num)-Wb)';
end