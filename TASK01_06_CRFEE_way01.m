close all;clear all;clc;
tic
%% Fisrst dim 
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
    
    for j = 1:min_dim
        result_all = zeros(d, graph_num+1);
        for k = 0:graph_num
            load (['./Processed_dataset/', datasetname, '/05CRFEE_P/train/split', num2str(i), '/', num2str(k)]);
            newtrain = train * P(:, 1:j);
            newtest = test * P(:, 1:j);
            
            result = knnclassification(newtrain, trainlabel, newtest,1);
            result_all(:, k+1) = result;
        end
        result = MULTI_RESULT(result_all);
        accuracy(i, j) = mean(result==testlabel)
    end    
end

correct = mean(accuracy)
max (correct)

% for i = 1:1:10
%     load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/0']);
%     load (['./Processed_dataset/', datasetname, '/03PCA/test/', num2str(i)]);
%     load (['./Processed_dataset/', datasetname, '/05CRFEE_P/train/split', num2str(i), '/0']);
%     trainlabel = gnd(ind_train(:, i));
%     testlabel = gnd(ind_test(:, i));
%
%     for j = 1:min_dim
%         newtrain = train * P(:, 1:j);
%         newtest = test * P(:, 1:j);
%         result = knnclassification(newtrain, trainlabel, newtest,1);
%         accuracy(i, j) = mean(result==testlabel)
%     end
% end
%
% correct = mean(accuracy)
% max (correct)
