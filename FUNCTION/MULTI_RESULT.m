function [out] = MULTI_RESULT(result)

for i = 1:size(result, 1)
    for j = 1:size(result, 2)
        temp(j) = size(find(result(i,:) == result(i,j)),2);
    end
    [data id] = max(temp,[],2);
    out(i) = result(i,id);
end
out = out';
end

