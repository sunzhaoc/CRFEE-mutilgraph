function [train] = random_data(train, class, num)    
% data - Inputdata [n * d]
% class - Number of data class
% num - Number of samples in each class

for i = 1:1:class
    temp_train = train((num*i)-(num-1): num*i, :);
    r = randperm(size(temp_train, 1));
    train((num*i)-(num-1): num*i, :) = temp_train(r, :);    
end