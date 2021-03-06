clear all;
close all;
clc;
dbstop if error
% figure(51)时域图像，figure(52)频域图像

%% 1. 加载原图，变换到频域
% 加载19个方向0, 10, ....180，以及尺寸sample_img_size
load('ImgArrCrop.mat');
ImgArrCrop = im2uint8(ImgArrCrop);
%   样本图像块的大小
block_size = 8;
% 40度
angle_index = 4;
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
[crop_height, crop_width] = size(g);
% I_crop尺寸与g对应
I_crop = ImgArrCrop(sample_img_size / 2 - crop_height / 2 + 1 : sample_img_size / 2 + crop_height / 2 , sample_img_size / 2 - crop_width / 2 + 1 : sample_img_size / 2 + crop_width / 2, angle_index);
figure(52), subplot(2, 2, 4), imshow(I_crop); title('对应g的原图I_crop');
figure(51), subplot(2, 2, 3), imshow(g); title('reverclass');

%% 5. 方向滤波器滤波
% 频谱支撑域大小
K = 3;
% 变换的角度的个数
L = 18; 
% 各个方向的滤波频谱系数总和
E = zeros(L,  1);
% Grad = cell(block_size / 2, block_size / 2);
fft2_M = 128; fft2_N = 128;   % fft2的点数
for i = 0:L - 1
    [g_filtered, E(i + 1)] = FilterToPicture(g, K, i, fft2_M, fft2_N);
    [EMax, filter_primer_direction_index] = max(E);
end
FilterToPicture(g, K, mod(angle_index + 9 - 1, 18), fft2_M, fft2_N);
%% sobel 算子计算梯度
[pixel_number_gauss, pimer_direction_index_gauss, Gdir_gauss] = SobelFilter(g);
[pixel_number_origin, pimer_direction_index_origin, Gdir_origin] = SobelFilter(I_crop);
%     Grad{r + 1, c + 1} = [pixel_number, pimer_direction_index];

display(pimer_direction_index_gauss);
display(pimer_direction_index_origin);
display(filter_primer_direction_index);
% display(filter_primer_direction_index - pimer_direction_index); % 差值对应9时，两个方向一致
%% 6. 绘制滤波后的频谱能量图
settings.ymin = 0;
[E_normalization, settings] = mapminmax(E', settings);
figure(51), subplot(2, 2, 4), bar(E_normalization'); title('滤波后归一化的频谱能量条形图0, 10, 20, ..., 170');