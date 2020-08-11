close all;clear all;clc;

% load ./Dataset/ORL
% load ./Dataset/ORL_index4
% load ./Dataset/ORL_index5
% load ./Dataset/ORL_index6
% load ./Dataset/banc
% load ./Dataset/banc_index4
% load ./Dataset/banc_index
% load ./Dataset/COIL
% load ./Dataset/coil_index5
% load ./Dataset/coil_index15
% load ./Dataset/umist
% load ./Dataset/umist_index4
% load ./Dataset/umist_index5
% load ./Dataset/umist_index6
% load ./Dataset/ar
% load ./Dataset/ar_index5
% load ./Dataset/ar_index10
% load ./Dataset/ar_index15
load ./Dataset/yaleB
% load ./Dataset/yaleB_index20
% load ./Dataset/yaleB_index30
load ./Dataset/yaleB_index40
for i=1:10
    train = fea(ind_train(:, i), :);
    trainlabel = gnd(ind_train(:, i));
    test = fea(ind_test(:, i), :);
    testlabel = gnd(ind_test(:, i));
    
    options = [];
    options.PCARatio = 0.99;
    [eigvector_pca, eigvalue1_pca] = PCA(train, options);
    
    train = train * eigvector_pca;
    test = test * eigvector_pca;
    
    train = NormalizeFea(train, 1);
    test = NormalizeFea(test, 1);
    
    [P] = CRFEE(train', trainlabel, j, 0.1, 9, 'orthonormalized');
    
    for j = 1:1:min_dim
        eigvector = P(:, 1:j);
        newtrain = train * eigvector;
        newtest = test * eigvector;
        result = knnclassification(newtrain, trainlabel, newtest, 1);
        
        accuracy(i, j) = mean(result == testlabel)
    end
end
correct = mean(accuracy)

[dim, max] = max(correct)
