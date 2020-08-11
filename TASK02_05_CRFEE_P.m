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
    
    graph_num = 99
    time = 0;
    
    for i = 1:1:10
        for j = 0:graph_num
            load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/', num2str(j)]);
            load (['./Processed_dataset/', datasetname, '/04CRFEE_L/train/split', num2str(i), '/', num2str(j)]);
            P = CRFEE_P(train', L);
            
            filepath = (['./Processed_dataset/', datasetname, '/05CRFEE_P_2/train/split', num2str(i), '/'])
            if ~exist(filepath, 'dir')
                mkdir(filepath)
            end
            save([filepath, [num2str(j)]], 'P');
            time = time + 1; %%
            jindu = time/((graph_num+1)*10);
            [choosedata, jindu]
        end
        
    end
    clearvars -except choosedata
end
