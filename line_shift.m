function Q = line_shift(i, N)
% 构造一个2N * 2N的矩阵
a = zeros(2 * N - i, i); b = eye(2 * N - i); c = eye(i); d = zeros(i, 2 * N - i);
Q = [a, b;c, d];
end