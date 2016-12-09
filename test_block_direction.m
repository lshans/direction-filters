clear all;
close all;
clc;

%% 1. 载入图像
% 加载ImgArr，存储了0, 10, ..., 180共十九个方向的样本图像
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArr.mat');
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ICombined_5_13.mat');
% I = ICombined(145:400, 145:400);
% figure, imshow(I), title('两条直线纹理相交的图')
M = 512; N = 512; 
% 加载raw图的方式
fp = fopen('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\lena.raw', 'r');
img = fread(fp, [M, N],'uint8'); % 按照列的顺序将输入图像读成512 x 512 的矩阵
img = uint8(img);
fclose(fp);
% 分块尺寸以及分块数目
block_r_size = 8; block_c_size = 8; blocknum_r = M / block_r_size; blocknum_c = N / block_c_size;
% 统一尺寸
I = img(1:M, 1:N);
I = I';  %读入的图像是按列存储到矩阵I中的， 所以对 I 进行转置
figure, imshow(I);
%% 对输入图像进行高通滤波处理
% highpass filter
H = hpfilter('gaussian', M, N, 10);
figure, mesh(double(H(1:10:M, 1:10:N)));
axis tight
colormap([0 0 0])
axis off
I_hlpfilter = ifft2(fft2(I).*H);
I_hlpfilter = uint8(I_hlpfilter);
figure, imshow(I_hlpfilter);
%% 将读入的图像数据分成块进行滤波处理
E = cell(blocknum_r, blocknum_c);
for r = 0 : blocknum_r - 1
    for c = 0: blocknum_c - 1
        I_block = I(r * block_r_size + 1 : (r + 1) * block_r_size, c * block_c_size + 1 : (c + 1) * block_c_size);
%         figure, imshow(I_block);
        [EMax, index_max] = deblock_filter(I_block);
        E{r + 1, c + 1} = [EMax, index_max];
        fprintf('处理完第(%d, %d)行的图像块\n', r, c);
    end
end
