clear all;
close all;
clc;
%% ������άmat����ImgArrCrop�г�ʼͼ�����ݵ���Ե��������
load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArrCrop.mat');
for i = 1:19
%       figure, imshow(ImgArrCrop(:, :, i));
end
ImgArrCrop1 = ImgArrCrop(:, :, 8);
%% �ü��µ�4x4 С������Եͼ
[ImgArrCrop_Height, ImgArrCrop_Width, K] = size(ImgArrCrop);
block_size = 4;
ImgArrCrop_4_4 = zero(block_size, block_size, 19);
for i = 1:19
   
     figure, imshow(ImgArrCrop_4_4(:, :, i));
end
sample_img_size = create_size / 256;
save('ImgArrCrop.mat', 'ImgArrCrop', 'sample_img_size');