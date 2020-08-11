function [W] = CRFEE_L(data, gnd, lemda, alpha)
[d,n]=size(data);%d行n列，124x160
train_num=length(unique(gnd));%数据有几类
%% construct W and Ws
for c=1:train_num
    Xc=data(:,gnd==c);%Xc是标签为1,2,3,。。。的样本（第1类样本。。。）
    nc=size(Xc,2);%Xc的列（特征数）Xc有几列说明该类有nc个样本
    t=1;
    for k=1:nc
        if k==1
            xj=Xc(:,1);%xj是该类样本的第一列  mx1
            Xj=Xc(:,2:nc);%Xj是该类样本第2到nc列  mx（nc-1）
            aj=inv(Xj'*Xj+lemda*eye(nc-1))*Xj'*xj;%协作表示系数  （nc-1）x1
            wij=[0;aj];%
        else
            xj=Xc(:,k); 
            Xj(:,1:k-1)=Xc(:,1:k-1);
            Xj(:,k:nc-1)=Xc(:,k+1:nc);
            aj=inv(Xj'*Xj+lemda*eye(nc-1))*Xj'*xj;%协作表示系数
            wij=[aj(1:(k-1));0;aj(k:nc-1)];%
        end        
        A(:,t)=wij;% A是每一类的类内权值矩阵
        t=t+1;
    end
    clear Xj aj t;
    Ws((c-1)*nc+1:c*nc,(c-1)*nc+1:c*nc)=A;%所有类的类内权值矩阵（对角矩阵）
end
 Ws=(eye(n)-Ws)*(eye(n)-Ws)'; %与类内权值矩阵相关的图拉普拉斯矩阵
%% construct Wb and Sb 
 for c=1:train_num
     Xb=data(:,gnd~=c);
     t=1;
     for k=1:nc
         if c==1
             xj=data(:,k);
             bj=inv(Xb'*Xb+lemda*eye(n-nc))*Xb'*xj;%抗协作表示系数
             wbij=[zeros(nc,1);bj];%类间权值矩阵
         elseif c>1&&c<train_num
             xj=data(:,k);
             bj=inv(Xb'*Xb+lemda*eye(n-nc))*Xb'*xj;
             wbij=[bj(1:(c-1)*nc);zeros(nc,1);bj((c-1)*nc+1:end)];
         else 
             xj=data(:,k);
             bj=inv(Xb'*Xb+lemda*eye(n-nc))*Xb'*xj;
             wbij=[bj;zeros(nc,1)];             
         end
         B(:,t)=wbij;
         t=t+1;
     end
     clear bj t;
     Wb((c-1)*nc+1:c*nc,:)=B';
 end 
 Wb=(eye(n)-Wb)*(eye(n)-Wb)'; %与类间权值矩阵相关的图拉普拉斯矩阵
 W = Wb-alpha*Ws;

 