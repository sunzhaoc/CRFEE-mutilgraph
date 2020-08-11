close all;clear all;clc;
addpath('FUNCTION')
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
    
    
    options = [];
    options.PCARatio = 0.99;
    graph_num = 99
    
    time = 0;
    for i = 1:1:10
        for j = 0:graph_num
            load (['./Processed_dataset/', datasetname, '/01SPILT/test/', num2str(i)]);
            load (['./Processed_dataset/', datasetname, '/02RANDOM/train/split', num2str(i), '/', num2str(j)]);
            [eigvector, eigvalue1] = PCA(train, options);
            
            train = train * eigvector;
            test = test * eigvector;
            train = NormalizeFea(train, 1);
            test = NormalizeFea(test, 1);
            
            trainpath = (['./Processed_dataset/', datasetname, '/03PCA_2/train/split', num2str(i), '/']);
            testpath = (['./Processed_dataset/', datasetname, '/03PCA_2/test/split', num2str(i), '/']);
            if ~exist(trainpath, 'dir')
                mkdir(trainpath)
            end
            if ~exist(testpath, 'dir')
                mkdir(testpath)
            end
            save([trainpath, [num2str(j)]], 'train');
            save([testpath, [num2str(j)]], 'test');
            
            time = time+1;
            jindu = time/(10*(graph_num+1));
            [choosedata, jindu]
        end
    end
    clearvars -except choosedata
end
