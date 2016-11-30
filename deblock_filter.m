% function 
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
% I_rgb = load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\I8.mat');
% IGray = rgb2gray(I_rgb.I8);
clear all;
close all;
clc;

%% 1. ����ͼ��
% ����ImgArr���洢��0, 10, ..., 180��ʮ�Ÿ����������ͼ��
load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArr.mat');
index = 5;
I = ImgArr(:, :, index);
% ͳһ�ߴ�
I = I(1:500, 1:500);
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ICombined_5_13.mat');
% I = ICombined(1:500, 1:500);
figure, imshow(I), title(['ԭʼͼ����ת', num2str((index - 1) * 10), '�ȣ������Ὺʼ��ʱ����ת'])

%% 2. ʹ�ü��10�ȵķ����˲����˲������õ�ÿ�������Ƶ������
% i = 0:L��ʾ0,10, ..., 180��19������
L = 18;
E = zeros(L + 1, 1);
for i = 0:L
    E_direction = FilterToPicture(I, 10, i);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);

%% 3. ���� �˲����һ����Ƶ����������ͼ����0, 10, 20, ..., 180��19��
settings.ymin = 0;
[E_normalization,settings] = mapminmax(E',settings);
figure, bar(E_normalization'); title('�˲����һ����Ƶ����������ͼ0, 10, 20, ..., 180');