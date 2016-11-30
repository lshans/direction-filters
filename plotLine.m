clear all;
clc;
close all;
x = [1:512];
k1 = 1;
y = k1 * x;
figure(1)
for i = 0:10
    y = y + 1;
    plot(x, y), hold on;
end