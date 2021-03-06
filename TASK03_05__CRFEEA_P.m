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
    end
    
    
    graph_num = 99;
    time = 0;
    for i = 1:1:10
        load (['./Processed_dataset/', datasetname, '/03PCA/train/split', num2str(i), '/0']);
        [d, n] = size(train);
        for j = 0:graph_num
            
            if j == 0
                load (['./Processed_dataset/', datasetname, '/04CRFEEA_L/train/split', num2str(i), '/', num2str(j)]);
            else
                load ((['./Processed_dataset/', datasetname, '/04CRFEEA_L/train/split', num2str(i), '/', num2str(j)]), 'Lb', 'Ls');
            end
            
            [parameter01, parameter02, parameter03, parameter04] = CRFEEA_parameter_choose(datasetname);
            P = CRFEEA_P(Lb, Ls, train', meanmat, parameter03);
            
            filepath = (['./Processed_dataset/', datasetname, '/05CRFEEA_P/train/split', num2str(i), '/'])
            if ~exist(filepath, 'dir')
                mkdir(filepath)
            end
            save([filepath, [num2str(j)]], 'P');
            time = time+1;
            timtimtimt = time/(10*(graph_num+1));
            [choosedata, timtimtimt]
        end
    end
    clearvars -except choosedata
end