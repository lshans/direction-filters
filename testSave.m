a = 1;
b = 2;
c = 3;
save('abc.mat', 'a', 'b', 'c')
clear all;
v = load('abc.mat');
aa = v.a
bb = v.b
cc = v.c
