% 数据切片保存
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

%% train data
% for i = 1:10
%     train = fea(ind_train(:,i),:);
% 
%     filename = [num2str(i)]
%     filepath = (['./Processed_dataset/', datasetname, '/01SPILT/train/'])
% 
%     if ~exist(filepath, 'dir')
%         mkdir(filepath)
%     end
% 
%     save([filepath, filename], 'train')
% end

%% test data
for i = 1:10
    test=fea(ind_test(:,i),:);
    
    filename = [num2str(i)]
    filepath = (['./Processed_dataset/', datasetname, '/01SPILT/test/'])
    if ~exist(filepath, 'dir')
        mkdir(filepath)
    end
    
    save([filepath, filename], 'test')
end
