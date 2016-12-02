% function 
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
% I_rgb = load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\I8.mat');
% IGray = rgb2gray(I_rgb.I8);
clear all;
close all;
clc;

%% 1. ����ͼ��
% ����ImgArr���洢��0, 10, ..., 180��ʮ�Ÿ����������ͼ��
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArr.mat');
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ICombined_5_13.mat');
% I = ICombined(145:400, 145:400);
% figure, imshow(I), title('����ֱ�������ཻ��ͼ')
M = 512; N = 512; 
% ����rawͼ�ķ�ʽ
fp = fopen('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\lena.raw', 'r');
img = fread(fp, [M, N],'uint8'); % �����е�˳������ͼ�����512 x 512 �ľ���
img = uint8(img);
fclose(fp);
% �ֿ�ߴ��Լ��ֿ���Ŀ
block_r_size = 32; block_c_size = 32; blocknum_r = M / block_r_size; blocknum_c = N / block_c_size;
% ͳһ�ߴ�
I = img(1:M, 1:N);
I = I';  %�����ͼ���ǰ��д洢������I�еģ� ���Զ� I ����ת��
figure, imshow(I);
%% ������ͼ����и�ͨ�˲�����
% highpass filter
% H = fftshift(hpfilter('ideal', M, N, 50));
% figure, mesh(double(H(1:10:M, 1:10:N)));
% axis tight
% colormap([0 0 0])
% axis off
% I_hlpfilter = ifft2(fft2(I_inverse).*H);
% I_hlpfilter = uint8(I_hlpfilter);
% figure, imshow(I_hlpfilter);
%% �������ͼ�����ݷֳɿ�����˲�����
E = cell(blocknum_r, blocknum_c);
for r = 0 : blocknum_r - 1
    for c = 0: blocknum_c - 1
        I_block = I(r * block_r_size + 1 : (r + 1) * block_r_size, c * block_c_size + 1 : (c + 1) * block_c_size);
%         figure, imshow(I_block);
        [EMax, index_max] = deblock_filter(I_block);
        E{r + 1, c + 1} = [EMax, index_max];
        fprintf('�������(%d, %d)�е�ͼ���\n', r, c);
    end
end
