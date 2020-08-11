function [T] = CRFEE(data, gnd, r, lemda, alpha, metric)
[d, n] = size(data);
train_num = length(unique(gnd));
%% construct Ls and Ps 类内协作表示
for c = 1:train_num
    Xc = data(:, gnd==c);
    nc = size(Xc, 2);
    t = 1;
    for k = 1:nc
        if k == 1
            xj = Xc(:, 1);
            Xj = Xc(:, 2:nc);
            aj = inv(Xj'*Xj+lemda*eye(nc-1))*Xj'*xj;
            wij = [0;aj];
        else
            xj = Xc(:, k);
            Xj(:, 1:k-1) = Xc(:, 1:k-1);
            Xj(:, k:nc-1) = Xc(:, k+1:nc);
            aj = inv(Xj'*Xj+lemda*eye(nc-1))*Xj'*xj;
            wij = [aj(1:(k-1));0;aj(k:nc-1)];
        end
        A(:, t) = wij;
        t = t + 1;
    end
    Ls((c-1)*nc+1:c*nc, (c-1)*nc+1:c*nc) = A;
end
Ls = (eye(n)-Ls)*(eye(n)-Ls)';
Ps = data*Ls*data';

%% construct Lb and Pb 类间抗协作表示
for c = 1:train_num
    Xb = data(:, gnd~=c);
    t = 1;
    for k = 1:nc
        if c == 1
            xj = data(:, k);
            bj = inv(Xb'*Xb + lemda*eye(n-nc))*Xb'*xj;
            wbij = [zeros(nc, 1);bj];
        elseif c>1 && c<train_num
            xj = data(:, k);
            bj = inv(Xb'*Xb + lemda*eye(n-nc))*Xb'*xj;
            wbij = [bj(1:(c-1)*nc);zeros(nc, 1);bj((c-1)*nc+1:end)];
        else
            xj = data(:, k);
            bj = inv(Xb'*Xb + lemda*eye(n-nc))*Xb'*xj;
            wbij = [bj;zeros(nc, 1)];
        end
        B(:, t)=wbij;
        t = t + 1;
    end
    Lb((c-1)*nc+1:c*nc, :) = B';
end
Lb = (eye(n)-Lb)*(eye(n)-Lb)';
Pb = data*Lb*data';

%%
P = Pb - alpha*Ps;
% P = data*(Lb - alpha*Ls)*data';

%% eigvetor T
opts.disp = 0;
[eigvec, eigval_matrix] = eigs(P, d, 'LR', opts);


eigval = diag(eigval_matrix);
[sort_eigval, sort_eigval_index] = sort(eigval);
T0 = eigvec(:, sort_eigval_index(end:-1:1));

switch metric
    case 'weighted'
        T = T0.*repmat(sqrt(sort_eigval(end:-1:1))', [d, 1]);
    case 'orthonormalized'%正交
        [T, dummy] = qr(T0, 0);
    case 'plain'%普通
        T = T0;
end

