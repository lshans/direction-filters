function  [direction_index] = detect_direction(I)

figure(72), subplot(2, 3, 1), imshow(I), title(['I ', num2str(size(I))]);
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
[img_height, img_width] = size(I);

block_height = 32; block_width = 32;
block_height_num = img_height / block_height;
block_width_num = img_width / block_width;

%% 2.对输入图像进行高通滤波
parameter_of_D0 = 0.013;
g = gauss_filter(I, parameter_of_D0);

%% 3. 分块处理
fft_M = 128; fft_N = 128;   % fft2点的个数
E = cell(block_height_num, block_width_num);    % 每个小块
Grad_origin = cell(block_height_num, block_width_num);  % 原始图像利用sobel计算的梯度及方向信息
Grad_gauss = cell(block_height_num, block_width_num);   % 高通v滤波后的图像利用sobel计算的梯度及方向信息
G = zeros(size(I), 'uint8');    % 逆滤波的图像，大图

various_block_cnt_arr = zeros(11, 1);  %统计楔形滤波器和sobel两种方法得到的主方向相差各个角度的图像块数目，0~90度之内分别记录在第1到10行,最后一行记录平滑块的个数
Different_block = cell(block_height_num, block_width_num); %将方法不一致的图像块的两种方向记录下来进一步验证
% 分块处理
for r = 0 : block_height_num - 1
    for c = 0: block_width_num - 1
       %% 方向滤波器，对高斯滤波后的图像处理
        % 对高斯滤波后的图像分块
        I_gauss_block = g(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        % figure(73), subplot(2, 3, 1), imshow(I_gauss_block); title(['高斯滤波后的时域图像块', num2str(size(I_gauss_block))]);
        % 滤波
        [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I_gauss_block, fft_M, fft_N);
        E{r + 1, c + 1} = [EMax, index_max];
        % 存储逆滤波图像
        G(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width) = g_pimer_direction_filtered;
        fprintf('处理完第(%d, %d)行的图像块\n', r, c);
        
       %% sobel 梯度计算方法得到的主方向，分别对高斯滤波后和原始图像的图像处理
        % 计算梯度
        [pixel_number_gauss, pimer_direction_index_gauss, Gdir_gauss] = SobelFilter(I_gauss_block);
        Grad_gauss{r + 1, c + 1} = [pixel_number_gauss, pimer_direction_index_gauss];
        
        % 对原始图像分块
        I_origin_block = I(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        % 计算梯度
        [pixel_number_origin, pimer_direction_index_origin, Gdir_origin] = SobelFilter(I_origin_block);
        Grad_origin{r + 1, c + 1} = [pixel_number_origin, pimer_direction_index_origin];
        
       %% TODO: 比较公式待确定
        %统计两种方法的方向是否一致
%         numberic_index = char(index_max) - '0';
        [various_block_cnt_arr, flag] = direction_consistency_compare(EMax, index_max, pimer_direction_index_gauss, various_block_cnt_arr);
        if flag == false
          Different_block{r + 1, c + 1} = [index_max, pimer_direction_index_gauss];
        end
    end
end

%% 4.显示逆滤波后的时域图像
figure(72), subplot(2, 3, 6), imshow(G), title('逆滤波后的图像');
t = toc