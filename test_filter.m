%% 对滤波器的处理
close all;clear all;clc;
N = 4;

% filter PPfft and rotate and ippfft
[f1, f2] = freqspace(N, 'meshgrid');
% 构造滤波器，频域特性
Hd = ones(N);
k = 4; % 方向斜率
% Hd((k * f1 + f2 <= -1/2) | (k * f1 + f2 >= 1/2)| (-k * f1 + f2 <= -1/2) | (-k * f1 + f2 >= 1/2)) = 0;
Hd(((k * f1 - f2 < 0) & (k * f1 + f2 < 0)) | ((k * f1 - f2 > 0) & (k * f1 + f2 > 0))) = 0;
figure, mesh(f1, f2, Hd), title('Hd');
figure(1),imshow(Hd, []);title('imshow Hd');

% 加窗
h3 = fwind1(Hd, hanning(N));
% % figure, imshow(h3, []), title('h3');
% 由时域冲击响应得到频域的系统函数，N和M表示 M x N大小的滤波器，由于是时域是循环卷积，注意生成滤波器要和图像一致，才可以在频域直接阵列乘法
H = freqz2(h3, N, N); 
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
H_rotate = imrotate(H, 60,'bicubic','crop'); 
% figure, mesh(H_rotate(1:gap:N, 1:gap:N)); title('cubic rotate');
figure, imshow(H_rotate, []);title('imshow H_rotate')
