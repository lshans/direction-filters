function [I_H_filter, E] = FilterToPicture(I, K, L, M, N)   % g_filtered 逆滤波后的时域图像， E频域滤波后的频谱能量
% 使用双立方插值法对滤波器旋转从而得到不同方向的滤波器，E是当前滤波器对图像滤波后的频谱能量，I是待滤波的原始图像，K是支撑域的斜率，L是旋转方向滤波器的角度，10 * L表示角度
% M和N是对I需要做[M x N]点的fft2

% close all;clear all;clc;
% [M, N] = size(I);

% [I, revertclass] = tofloat(I);    % 处理不同数值类型的图像
% 改成m x n点的fft2，原来直接fft2的
F_I = fft2(I, M, N);
F_I = fftshift(F_I);    % 滤波器已经是平移过后的，所以图像要相同处理
figure(41), subplot(2, 2, 2), imshow(F_I, []), title('滤波器的输入图像的频谱');
% 测试64 x 64点的FFT2
% F_I_pad = fft2(I, M, N);
% figure(21), subplot(2, 2, 2), imshow(F_I_pad, []), title('滤波器的输入图像的频谱128 x 128');



%% 1. 构造滤波器的频域特性，并加窗
[f1, f2] = freqspace([M N], 'meshgrid');
% 构造滤波器，频域特性
Hd = ones(M, N);
% K = 10; % 方向斜率
angle_support = 2 * atan(1 / K) * 180 / pi;
% 生成平行四边形的支撑域
% Hd((K * f1 + f2 <= -1/2) | (K * f1 + f2 >= 1/2)| (-v * f1 + f2 <= -1/2) | (-K * f1 + f2 >= 1/2)) = 0;
% 生成楔形滤波器的支撑域
Hd(((K * f1 - f2 < 0) & (K * f1 + f2 < 0)) | ((K * f1 - f2 > 0) & (K * f1 + f2 > 0))) = 0;
% % figure, mesh(f1, f2, Hd), title('Hd');

% 加窗
h3 = fwind1(Hd, hanning(N));
% % figure, imshow(h3, []), title('h3');
% 由时域冲击响应得到频域的系统函数，N和M表示 M x N大小的滤波器，由于是时域是循环卷积，注意生成滤波器要和图像一致，才可以在频域直接阵列乘法
H = freqz2(h3, N, M); 
% title('观察滤波器的频域特性, freqz2, H');

% 滤波器的频域图像
gap = 1;    % mesh显示时的间隔
HS = 20 * log10(abs(H) + 1); 
Wx = linspace(-pi,pi/16,pi); Wy = linspace(-pi,pi/16,pi);
% figure, mesh(HS(1:gap:N, 1:gap:N)), title('mesh HS');
% % figure, imshow(HS, []);title('imshow HS')


%% 2. 三立方插值将滤波器频谱旋转一定角度，得到对应L的方向滤波器
% 将图像A（图像的数据矩阵）绕图像的中心点旋转angle度， 正数表示逆时针旋转， 负数表示顺时针旋转。返回旋转后的图像矩阵。
% B = imrotate(A,angle,method,bbox),bbox参数用于指定输出图像属性：
% 'crop'： 通过对旋转后的图像B进行裁剪， 保持旋转后输出图像B的尺寸和输入图像A的尺寸一样。
% 'loose'： 使输出图像足够大， 以保证源图像旋转后超出图像尺寸范围的像素值没有丢失。 一般这种格式产生的图像的尺寸都要大于源图像的尺寸。
% H_rotate = imrotate(H, L * angle_support,'bicubic','crop'); 
H_rotate = imrotate(H, L * 10,'bicubic','crop'); 
% figure, mesh(H_rotate(1:gap:N, 1:gap:N)); title('cubic rotate');
figure(41), subplot(2, 2, 1), imshow(H_rotate, []);title('imshow H_rotate')
%% 3. 频域相乘，实现滤波
I_H_filter = H_rotate .* F_I;
% I_H_filter_int8 = uint8(I_H_filter);
% % mesh(I_H_filter_int8(1:gap:N, 1:gap:N)); title('filtered picture');
%% 4. 计算滤波后频谱能量，傅里叶变换后的傅里叶变换系数的平方和，作为频谱能量
A = abs(I_H_filter);
E = sum(A(:).^2);
end