close all;clear all;clc;

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


graph_num = 99

for i = 1:1:10
    load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/0']);
    [d, n] = size(train);
    for j = 0:graph_num
        load (['./Processed_dataset/', datasetname, '/04CRFEE_L/train/split', num2str(i), '/', num2str(j)]);
        P = CRFEE_P(train', L);
        
        filepath = (['./Processed_dataset/', datasetname, '/05CRFEE_P/train/split', num2str(i), '/'])
        if ~exist(filepath, 'dir')
            mkdir(filepath)
        end
        save([filepath, [num2str(j)]], 'P');
    end
end