%% random data
close all;clear all;clc;
tic

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
% load ./Dataset/yaleB
% load ./Dataset/yaleB_index20
% load ./Dataset/yaleB_index30
% load ./Dataset/yaleB_index40


graph_num = 99
time = 0;
for spilt_num = 1:10
    load (['./Processed_dataset/', datasetname, '/01SPILT/train/', num2str(spilt_num)]);
    
    savepath = (['./Processed_dataset/', datasetname, '/02RANDOM/train/split', num2str(spilt_num), '/']);
    savename = ['0'];
    if ~exist(savepath, 'dir')
        mkdir(savepath)
    end
    save([savepath, savename ], 'train');
    
    for i = 1:1:graph_num
        train = random_data(train, datasetclass, datasetnum);
        
        savename = [num2str(i)];
        save([savepath, savename ], 'train');
        time = time+1;
        time/(10*graph_num)
    end
end
