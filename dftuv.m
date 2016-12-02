function [U, V] = dftuv(M, N)
%set up range of variables
u = single(0: (M - 1));
v = single(0: (N - 1));

% compute the indices for use in meshgrid
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

%compute the meshgrid arrays
[U,V] = meshgrid(v, u);