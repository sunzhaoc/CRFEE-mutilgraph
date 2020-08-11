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
load ./Dataset/yaleB
% load ./Dataset/yaleB_index20
% load ./Dataset/yaleB_index30
load ./Dataset/yaleB_index40

options = [];
options.PCARatio = 0.99;
graph_num = 99

time = 0;
for i = 1:1:10
    load (['./Processed_dataset/', datasetname, '/01SPILT/test/', num2str(i)]);
    for j = 0:graph_num
        load (['./Processed_dataset/', datasetname, '/02RANDOM/train/split', num2str(i), '/', num2str(j)]);
        [eigvector, eigvalue1] = PCA(train, options);
        
        train = train * eigvector;
        train = NormalizeFea(train, 1);
        
        trainpath = (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/']);
        if ~exist(trainpath, 'dir')
            mkdir(trainpath)
        end
        save([trainpath, [num2str(j)]], 'train');
        
        if j == 0
            test = test * eigvector;
            test = NormalizeFea(test, 1);
            
            testpath = (['./Processed_dataset/', datasetname, '/03PCA/test/']);
            if ~exist(testpath, 'dir')
                mkdir(testpath)
            end
            save([testpath, [num2str(i)]], 'test');
        end
        time = time+1;
        time/(10*(graph_num+1))
    end
end
