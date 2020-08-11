close all;clear all;clc;
tic

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
load ./Dataset/coil_index10
% load ./Dataset/coil_index15

graph_num = 99;
time = 0;
for i = 1:1:10
    trainlabel = gnd(ind_train(:, i));
    for j = 0:graph_num
        load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/', num2str(j)]);
        L = CRFEE_L(train', trainlabel, 0.1, 9);
        
        filepath = (['./Processed_dataset/', datasetname, '/04CRFEE_L/train/split', num2str(i), '/']);
        if ~exist(filepath, 'dir')
            mkdir(filepath)
        end
        save([filepath, [num2str(j)]], 'L');
        time = time+1;
        time/(10*(graph_num+1))
    end
end