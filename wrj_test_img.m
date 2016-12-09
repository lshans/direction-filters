clear all;
close all;
clc;

%% 1. 载入图像
fp = fopen('E:\项目\毕设预测\directionFilterProject\barbara.raw', 'r');
M = 512; N = 512;
img = fread(fp, [M, N],'uint8'); % 按照列的顺序将输入图像读成512 x 512 的矩阵
img = uint8(img');
fclose(fp);
I = img(129:384, 129:384); %裁取部分图像
I = I(197:200, 201:204);
figure(1), imshow(I);
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
[img_height, img_width] = size(I);

block_height = 4; block_width = 4;
block_height_num = img_height / block_height;
block_width_num = img_width / block_width;

[f, revertclass] = tofloat(I);
figure(61), subplot(2, 2, 1), imshow(f, []), title(['原始大图', sprintf('%d x %d', img_height, img_width)]);
I = f;
% 获取填充参数
PQ = paddedsize(size(I));   
% 填充图的FFT，不偏移
F_I = fft2(I, PQ(1), PQ(2)); 
figure(62), subplot(2, 2, 1), imshow(log(abs(fftshift(F_I)) + 1), []); title('log和fftshift后的F');

%% 2. 创建高通滤波器
D0 = 0.015 * PQ(1); % 0.015 for barbara.raw by lss ,边缘纹理比较全，比较明显.0.013for lena.raw
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(62), subplot(2, 2, 2), imshow(log(abs(fftshift(H)) + 1), []); title('log和fftshift后的H');

%% 3. 滤波
G = F_I .* H;
g = ifft2(G);
figure(62), subplot(2, 2, 3), imshow(log(abs(fftshift(G)) + 1), []); title('log和fftshift后的G');

%% 4. IFFT
% pad后需要裁剪取，左上角
g = g(1:size(I, 1), 1:size(I, 2));
% figure, imshow(g, []); title('IFFT1，【】');
% figure, imshow(uint8(g)); title('IFFT2, uint8');
g = revertclass(g);
figure(61), subplot(2, 2, 2), imshow(g); title('reverclass');
%% test高通滤波后的图像和原图进行相加，看下结果图
% g_revertclass_I = g + revertclass(f);
% figure(63),imshow(g_revertclass_I);
%% 5. 分块处理
fft_M = 128; fft_N = 128;
E = cell(block_height_num, block_width_num);
Grad_origin = cell(block_height_num, block_width_num);
Grad_gauss = cell(block_height_num, block_width_num);
% 逆滤波后的原图数据矩阵
G = zeros(size(I), 'uint8');
same_block_count = 0;
unsame_block_count = 0;
for r = 0 : block_height_num - 1
    for c = 0: block_width_num - 1
       %% 方向滤波器 by lss
        I_gauss_block = g(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        figure(51), subplot(2, 2, 1), imshow(I_gauss_block); title('时域图像块');
        [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I_gauss_block, fft_M, fft_N);
        E{r + 1, c + 1} = [EMax, index_max];
        G(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width) = g_pimer_direction_filtered;
        fprintf('处理完第(%d, %d)行的图像块\n', r, c);
        %% sobel 梯度计算方法得到的主方向
        I_origin_block = I(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        [pixel_number_origin, pimer_direction_index_origin, Gdir_origin] = SobelFilter(im2uint8(I_origin_block));
        Grad_origin{r + 1, c + 1} = [pixel_number_origin, pimer_direction_index_origin];
        [pixel_number_gauss, pimer_direction_index_gauss, Gdir_gauss] = SobelFilter(I_gauss_block);
        Grad_gauss{r + 1, c + 1} = [pixel_number_gauss, pimer_direction_index_gauss];
        %% 统计两种方法的方向是否一致
        transport_pimer_direction_index = mod(mod(pimer_direction_index_gauss + 9, 37) + 1, 19) + 1;
        % index_max == (transport_pimer_direction_index) 
        if (index_max) == (transport_pimer_direction_index)
            same_block_count = same_block_count + 1;
        else
            unsame_block_count = unsame_block_count + 1;
        end
    end
end
%% 6.显示逆滤波后的时域图像
figure(66), imshow(G);