function [T] = CRFEEA_P(Lb, Ls, data, meanmat, alpha)
[d,n]=size(data);
Ps = data * Ls * data';
Pb = meanmat * Lb * meanmat';
P = Pb - alpha*Ps;

opts.disp = 0;
[eigvec, eigval_matrix] = eigs(P, d, 'LR', opts);

eigval = diag(eigval_matrix);
[sort_eigval, sort_eigval_index] = sort(eigval);
T0 = eigvec(:, sort_eigval_index(end:-1:1));

[T, dummy]=qr(T0,0);
end

