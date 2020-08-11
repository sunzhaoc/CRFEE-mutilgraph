close all;clear all;clc;
tic
% first gRap
load ./Dataset/ORL
load ./Dataset/ORL_index4
% load ./Dataset/banc
% load ./Dataset/banc_index4
graph_num = 4;
for i = 1:10
    load (['./Processed_dataset/', datasetname, '/03PCA/test/', num2str(i)]);
    load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/0']);
    trainlabel = gnd(ind_train(:, i));
    testlabel = gnd(ind_test(:, i));
    [d, n] = size(test);
    
    for k = 0:graph_num
        load (['./Processed_dataset/', datasetname, '/05CRFEE_P/train/split', num2str(i), '/', num2str(k)]);
        for j = 1:min_dim
            newtrain = train * P(:, 1:j);
            newtest = test * P(:, 1:j);
            result = knnclassification(newtrain, trainlabel, newtest,1);
            result_all(:, j, k+1) = result;
        end
    end
    
    for k=1:min_dim
        for j=0:graph_num
            result_dim(:, j+1) = result_all(:, k, j+1);
        end
        result = MULTI_RESULT(result_dim);
        accuracy(i, k) = mean(result==testlabel)
        clear result_dim
        
    end
end

correct = mean(accuracy)
max (correct)