function H = hpfilter(type, M, N, D0)
% 创建频域高通滤波器
if nargin == 4
    n = 1;
end
% generate highpass filter
Hlp = lpfilter(type, M, N, D0);
H = 1 - Hlp;
    