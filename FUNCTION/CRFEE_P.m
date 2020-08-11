function [T] = CRFEE_P(data, L)
[d,n]=size(data);
P = data*L*data';

opts.disp = 0;
[eigvec, eigval_matrix]=eigs(P, d, 'LR', opts);%r个实部最大的特征值和特征向量


eigval = diag(eigval_matrix);%求特征值
[sort_eigval, sort_eigval_index] = sort(eigval);%从小到大排序，调整的次序
T0 = eigvec(:, sort_eigval_index(end:-1:1));%取到想要的特征向量

[T, dummy]=qr(T0, 0);
end
