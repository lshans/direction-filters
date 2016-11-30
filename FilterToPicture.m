%% 对滤波器的处理,双立方插值法
function E = FilterToPicture(I, K, L)
% close all;clear all;clc;
[M, N] = size(I);
gap = 5;
% L = 17;
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
% [I, revertclass] = tofloat(I);
F_I = fft2(I);
F_I = fftshift(F_I);
[f1, f2] = freqspace([M N], 'meshgrid');
% 构造滤波器，频域特性
Hd = ones(M, N);
% K = 10; % 方向斜率
angle_support = 2 * atan(1 / K) * 180 / pi;
% Hd((K * f1 + f2 <= -1/2) | (K * f1 + f2 >= 1/2)| (-v * f1 + f2 <= -1/2) | (-K * f1 + f2 >= 1/2)) = 0;
Hd(((K * f1 - f2 < 0) & (K * f1 + f2 < 0)) | ((K * f1 - f2 > 0) & (K * f1 + f2 > 0))) = 0;
% % figure, mesh(f1, f2, Hd), title('Hd');

% 加窗
h3 = fwind1(Hd, hanning(N));
% % figure, imshow(h3, []), title('h3');
H = freqz2(h3, N, M); 
% title('观察滤波器的频域特性, freqz2, H');

HS = 20 * log10(abs(H) + 1); 
% Wx = linspace(-pi,pi/16,pi); Wy = linspace(-pi,pi/16,pi);
% figure, mesh(HS(1:gap:N, 1:gap:N)), title('mesh HS');

% 三立方插值将滤波器频谱旋转一定角度
% 将图像A（图像的数据矩阵）绕图像的中心点旋转angle度， 正数表示逆时针旋转， 负数表示顺时针旋转。返回旋转后的图像矩阵。
% B = imrotate(A,angle,method,bbox),bbox参数用于指定输出图像属性：
% 'crop'： 通过对旋转后的图像B进行裁剪， 保持旋转后输出图像B的尺寸和输入图像A的尺寸一样。
% 'loose'： 使输出图像足够大， 以保证源图像旋转后超出图像尺寸范围的像素值没有丢失。 一般这种格式产生的图像的尺寸都要大于源图像的尺寸。
% H_rotate = imrotate(H, L * angle_support,'bicubic','crop'); 
H_rotate = imrotate(H, L * 10,'bicubic','crop'); 
% figure, mesh(H_rotate(1:gap:N, 1:gap:N)); title('cubic rotate');
I_H_filter = H_rotate .* F_I;
I_H_filter_int8 = int8(I_H_filter);
% % mesh(I_H_filter_int8(1:gap:N, 1:gap:N)); title('filtered picture');
%计算滤波后频谱能量
A = abs(I_H_filter);
E = sum(A(:).^2);