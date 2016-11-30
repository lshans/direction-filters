% function 
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
% I_rgb = load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\I8.mat');
% IGray = rgb2gray(I_rgb.I8);
clear all;
close all;
clc;

%% 1. 载入图像
% 加载ImgArr，存储了0, 10, ..., 180共十九个方向的样本图像
load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArr.mat');
index = 5;
I = ImgArr(:, :, index);
% 统一尺寸
I = I(1:500, 1:500);
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ICombined_5_13.mat');
% I = ICombined(1:500, 1:500);
figure, imshow(I), title(['原始图像旋转', num2str((index - 1) * 10), '度，从纵轴开始逆时针旋转'])

%% 2. 使用间隔10度的方向滤波器滤波，并得到每个方向的频谱能量
% i = 0:L表示0,10, ..., 180，19个方向
L = 18;
E = zeros(L + 1, 1);
for i = 0:L
    E_direction = FilterToPicture(I, 10, i);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);

%% 3. 绘制 滤波后归一化的频谱能量条形图，从0, 10, 20, ..., 180共19列
settings.ymin = 0;
[E_normalization,settings] = mapminmax(E',settings);
figure, bar(E_normalization'); title('滤波后归一化的频谱能量条形图0, 10, 20, ..., 180');