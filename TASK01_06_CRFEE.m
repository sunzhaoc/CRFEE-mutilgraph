close all;clear all;clc;
tic
%% Fisrst dim
% load ./Dataset/ORL
% load ./Dataset/ORL_index4
% load ./Dataset/ORL_index5
% load ./Dataset/ORL_index6
% load ./Dataset/banc
% load ./Dataset/banc_index4
% load ./Dataset/banc_index5
% load ./Dataset/banc_index6
load ./Dataset/COIL
% load ./Dataset/coil_index5
% load ./Dataset/coil_index10
load ./Dataset/coil_index15

graph_num = 9;
test_num = 10;
time = 0;   %%
for z = 1:test_num
    for i = 1:10
        load (['./Processed_dataset/', datasetname, '/03PCA/test/', num2str(i)]);
        load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/0']);
        trainlabel = gnd(ind_train(:, i));
        testlabel = gnd(ind_test(:, i));
        [d, n] = size(test);
        for k = 0:graph_num
            graphchoose(:, k+1) = (unidrnd(100)-1);
        end
        for j = 1:min_dim
            result_all = zeros(d, graph_num+1);
            for k = 0:graph_num
                load (['./Processed_dataset/', datasetname, '/05CRFEE_P/train/split', num2str(i), '/', num2str(graphchoose(:, k+1))]);
                newtrain = train * P(:, 1:j);
                newtest = test * P(:, 1:j);
                
                result = knnclassification(newtrain, trainlabel, newtest,1);
                result_all(:, k+1) = result;
            end
            result = MULTI_RESULT(result_all);
            accuracy(i, j) = mean(result==testlabel);
            time = time + 1; %%
            jindu = time/(test_num*10*min_dim)
        end
    end
    correct = mean(accuracy);
    final_acc(:, z) = max (correct);
    
    filepath = (['./Result/', datasetname, '/']);
    if ~exist(filepath, 'dir')
        mkdir(filepath)
    end
    save([filepath, [num2str(graph_num+1)]], 'final_acc');
end

