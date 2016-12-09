clear all;
close all;
clc;
dbstop if error
% figure(51)时域图像，figure(52)频域图像

%% 1. 加载原图，变换到频域
% 加载19个方向0, 10, ....180，以及尺寸sample_img_size
load('ImgArrCrop.mat');
% 样本图像块的大小
block_size = 64;
% 40度
angle_index = 5;
I = ImgArrCrop(sample_img_size / 2 - block_size / 2 + 1 : sample_img_size / 2 + block_size / 2 , sample_img_size / 2 - block_size / 2 + 1 : sample_img_size / 2 + block_size / 2, angle_index);
% figure(51), subplot(2, 2, 1), imshow(I); title(['显示原图 uint8, ', num2str(angle_index)]);
[f, revertclass] = tofloat(I);
figure(51), subplot(2, 2, 1), imshow(f, []); title(['显示原图 float [], ', num2str(angle_index)]);
I = f;
% 获取填充参数
PQ = paddedsize(size(I));   
% 填充图的FFT，不偏移
F_I = fft2(I, PQ(1), PQ(2)); 
figure(52), subplot(2, 2, 1), imshow(log(abs(fftshift(F_I)) + 1), []); title('log和fftshift后的F');

%% 2. 创建高通滤波器
D0 = 0.2 * PQ(1);
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(52), subplot(2, 2, 2), imshow(log(abs(fftshift(H)) + 1), []); title('log和fftshift后的H');

%% 3. 滤波
G = F_I .* H;
g = ifft2(G);
figure(52), subplot(2, 2, 3), imshow(log(abs(fftshift(G)) + 1), []); title('log和fftshift后的G');

%% 4. IFFT
% pad后需要裁剪取，左上角
g = g(1:size(I, 1), 1:size(I, 2));
% figure, imshow(g, []); title('IFFT1，【】');
% figure, imshow(uint8(g)); title('IFFT2, uint8');
g = revertclass(g);
figure(51), subplot(2, 2, 2), imshow(g); title('reverclass');
% 去掉图像的四周，尺寸缩放
g = g(block_size / 4 + 1: block_size * 3 / 4, block_size / 4 + 1: block_size * 3 / 4);
figure(51), subplot(2, 2, 3), imshow(g); title('reverclass');

%% 5. 方向滤波器滤波
% 频谱支撑域大小
K = 3;
% 变换的角度的个数
L = 18; 
% 各个方向的滤波频谱系数总和
E = zeros(L,  1);
for i = 0:L - 1
    E(i + 1) = FilterToPicture(g, K, i);
end

%% 6. 绘制滤波后的频谱能量图
settings.ymin = 0;
[E_normalization, settings] = mapminmax(E', settings);
figure(51), subplot(2, 2, 4), bar(E_normalization'); title('滤波后归一化的频谱能量条形图0, 10, 20, ..., 170');