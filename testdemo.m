% for i=1:10
%     train=fea(ind_train(:,i),:);%在fea中随机取160x1024
%
%     options = [];
%     options.PCARatio = 0.99;
%     [eigvector1,eigvalue1] = PCA(train,options);%求出PCA映射矩阵
%
%     train=train*eigvector1;
%
%     train = NormalizeFea(train,1);%特征归一�?
%     d(:, i) = size(train,2);
% end
% min(d)

[min(final_acc), mean(final_acc), max(final_acc)]
% clear;clc;
% load ./Dataset/ORL
% load ./Dataset/ORL_index4
% load ./Processed_dataset/ORL_index4/03PCA/train/split5/20
% load ./Processed_dataset/ORL_index4/03PCA/test/5
% 
% for i=1:10
%     trainlabel = gnd(ind_train(:, i));
%     testlabel = gnd(ind_test(:, i));
%     
%     [P] = CRFEE(train', trainlabel, j, 0.1, 9, 'orthonormalized');
%     
%     for j = 1:1:min_dim
%         eigvector = P(:, 1:j);
%         newtrain = train * eigvector;
%         newtest = test * eigvector;
%         result = knnclassification(newtrain, trainlabel, newtest, 1);
%         
%         accuracy(i, j) = mean(result == testlabel)
%     end
% end
% correct = mean(accuracy)
% 
% [dim, max] = max(correct)
