close all;clear all;clc;

load ./Dataset/ORL
load ./Dataset/ORL_index4
% load ./Dataset/banc
% load ./Dataset/banc_index4
% load ./Dataset/COIL
% load ./Dataset/coil_index15
% load ./Dataset/umist
% load ./Dataset/umist_index6
% load ./Dataset/yaleB
% load ./Dataset/yaleB_index20
for i = 1:10
    train = fea(ind_train(:, i), :);
    trainlabel = gnd(ind_train(:, i));
    test = fea(ind_test(:, i), :);
    testlabel = gnd(ind_test(:, i));
    
    options = [];
    options.PCARatio = 0.99;
    [pca_eigvector, pca_eigvalue] = PCA(train, options);
    
    train = train * pca_eigvector;
    test = test * pca_eigvector;
    train = NormalizeFea(train, 1);
    test = NormalizeFea(test, 1);
    
    eigvector_CRFEE_A = CRFEEA(train', trainlabel, j, 0.1, 0.01, 1, 1, 'orthonormalized');
    for j = 1:min_dim
        eigvector = eigvector_CRFEE_A(:, 1:j);
        newtrain = train*eigvector;
        newtest = test*eigvector;
        result = knnclassification(newtrain,trainlabel,newtest,1);
        accuracy(i, j) = mean(result == testlabel)
    end
end

correct= mean(accuracy);
[max_correct, max_dim] = max(correct)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CRFEEA参数设置
% ORL_32x32：参数设置 0.1,0.01,1,1
% Umist_56x46_1D:参数设置0.1,1,5,1
% banc:参数设置 0.1,1,1,1
% ar参数设置 5:0.1,0.1,0.6,1     10/15:0.1,0.01,0.5,1
% coil20 参数设置：1,0.1,0.1,1
% yaleB 参数设置：1,0.01,0.1,1
