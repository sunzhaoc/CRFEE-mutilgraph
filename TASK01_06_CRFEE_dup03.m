close all;clear all;clc;
for choosedata = 1:12
    switch choosedata
        case 1
            load ./Dataset/banc
            load ./Dataset/banc_index4
        case 2
            load ./Dataset/banc
            load ./Dataset/banc_index5
        case 3
            load ./Dataset/banc
            load ./Dataset/banc_index6
            
        case 4
            load ./Dataset/COIL
            load ./Dataset/coil_index5
        case 5
            load ./Dataset/COIL
            load ./Dataset/coil_index10
        case 6
            load ./Dataset/COIL
            load ./Dataset/coil_index15
            
        case 7
            load ./Dataset/ORL
            load ./Dataset/ORL_index4
        case 8
            load ./Dataset/ORL
            load ./Dataset/ORL_index5
        case 9
            load ./Dataset/banc
            load ./Dataset/ORL_index6
            
        case 10
            load ./Dataset/umist
            load ./Dataset/umist_index4
        case 11
            load ./Dataset/umist
            load ./Dataset/umist_index5
        case 12
            load ./Dataset/umist
            load ./Dataset/umist_index6
            
        case 13
            load ./Dataset/ar
            load ./Dataset/ar_index5
        case 14
            load ./Dataset/ar
            load ./Dataset/ar_index10
        case 15
            load ./Dataset/ar
            load ./Dataset/ar_index15
            
        case 16
            load ./Dataset/yaleB
            load ./Dataset/yaleB_index20
        case 17
            load ./Dataset/yaleB
            load ./Dataset/yaleB_index30
        case 18
            load ./Dataset/yaleB
            load ./Dataset/yaleB_index40
    end
    
    graph_num = 0;
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
                jindu = time/(test_num*10*min_dim);
                [choosedata, jindu]
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
    clearvars -except choosedata
end
