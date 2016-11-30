% function 
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
% I_rgb = load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\I8.mat');
% IGray = rgb2gray(I_rgb.I8);
clear all;
close all;
clc;
load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArr.mat');
I = ImgArr(:, :, 5);
I = I(1:500, 1:500);
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ICombined_5_13.mat');
% I = ICombined(1:500, 1:500);
imshow(I)
% I_rotate = rotate
% string_class = class(I);
% I_block = zeros(size(I)/4);
% I_block = BLOCKPROC(I,[4 4]);
L = 18;
E = zeros(L + 1, 1);
for i = 0:L
    E_direction = FilterToPicture(I, 10, i);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);
% E_normalization = zeros(1, L + 1);
% [E_normalization,settings] = mapminmax(E');
settings.ymin = 0;
[E_normalization,settings] = mapminmax(E',settings);
figure, bar(E_normalization');