clear all;
close all;
clc;
%% 创建样本图像
width = 512; height = 512;
line_width = 10;

A = zeros(height, width);
A(:, width / 2 - line_width / 2:width / 2 + line_width / 2) = 255;
% imshow(A);

ImgArr = zeros(height, width, 19);
ImgArr = uint8(ImgArr);
for angle = 0:18
    I = imrotate(A, angle * 10, 'bicubic', 'crop');
    L = logical(I) * 255;
    ImgArr(:, :, angle + 1) = uint8(L);
end
save('ImgArr.mat', 'ImgArr');


%% 用法
%% angle与i的换算关系 i = angle / 10 + 1
load('ImgArr.mat');
for i =1:19
    figure, imshow(ImgArr(:, :, i))
end

%% 组合不同的角度方向
I1 = ImgArr(:, :, 5);
I2 = ImgArr(:, :, 13);
ICombined = uint8((I1 | I2)) * 255;
figure, imshow(ICombined)
save('ICombined_5_13.mat', 'ICombined');


%% 创建单边缘的样本团，存储在ImgArrCrop中
create_size = 1024; % 只提取create_size / 2，以消除旋转边缘
IRoi = ones(create_size, create_size);
IRoi = 255 * IRoi;
IRoi(:, create_size / 2 + 1:create_size) = 0;
imshow(IRoi);

ImgArr = zeros(create_size, create_size, 19);
for angle_i = 0:18
    I = imrotate(IRoi, angle_i * 10, 'bicubic', 'crop');
    L = logical(I) * 255;
    ImgArr(:, :, angle_i + 1) = uint8(L);
    % figure, imshow(ImgArr(:, :, angle_i + 1));
end

%ImgArrCrop = zeros(create_size / 2, create_size / 2, 19);
ImgArrCrop = ImgArr(create_size / 4 + 1: create_size * 3 / 4, create_size / 4 + 1: create_size * 3 / 4, :);
for i = 1:19
    % figure, imshow(ImgArrCrop(:, :, i));
end
sample_img_size = create_size / 2;
save('ImgArrCrop.mat', 'ImgArrCrop', 'sample_img_size');