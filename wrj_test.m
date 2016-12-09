clear all;
close all;
clc;
dbstop if error
% figure(51)ʱ��ͼ��figure(52)Ƶ��ͼ��

%% 1. ����ԭͼ���任��Ƶ��
% ����19������0, 10, ....180���Լ��ߴ�sample_img_size
load('ImgArrCrop.mat');
% ����ͼ���Ĵ�С
block_size = 64;
% 40��
angle_index = 5;
I = ImgArrCrop(sample_img_size / 2 - block_size / 2 + 1 : sample_img_size / 2 + block_size / 2 , sample_img_size / 2 - block_size / 2 + 1 : sample_img_size / 2 + block_size / 2, angle_index);
% figure(51), subplot(2, 2, 1), imshow(I); title(['��ʾԭͼ uint8, ', num2str(angle_index)]);
[f, revertclass] = tofloat(I);
figure(51), subplot(2, 2, 1), imshow(f, []); title(['��ʾԭͼ float [], ', num2str(angle_index)]);
I = f;
% ��ȡ������
PQ = paddedsize(size(I));   
% ���ͼ��FFT����ƫ��
F_I = fft2(I, PQ(1), PQ(2)); 
figure(52), subplot(2, 2, 1), imshow(log(abs(fftshift(F_I)) + 1), []); title('log��fftshift���F');

%% 2. ������ͨ�˲���
D0 = 0.2 * PQ(1);
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(52), subplot(2, 2, 2), imshow(log(abs(fftshift(H)) + 1), []); title('log��fftshift���H');

%% 3. �˲�
G = F_I .* H;
g = ifft2(G);
figure(52), subplot(2, 2, 3), imshow(log(abs(fftshift(G)) + 1), []); title('log��fftshift���G');

%% 4. IFFT
% pad����Ҫ�ü�ȡ�����Ͻ�
g = g(1:size(I, 1), 1:size(I, 2));
% figure, imshow(g, []); title('IFFT1������');
% figure, imshow(uint8(g)); title('IFFT2, uint8');
g = revertclass(g);
figure(51), subplot(2, 2, 2), imshow(g); title('reverclass');
% ȥ��ͼ������ܣ��ߴ�����
g = g(block_size / 4 + 1: block_size * 3 / 4, block_size / 4 + 1: block_size * 3 / 4);
figure(51), subplot(2, 2, 3), imshow(g); title('reverclass');

%% 5. �����˲����˲�
% Ƶ��֧�����С
K = 3;
% �任�ĽǶȵĸ���
L = 18; 
% ����������˲�Ƶ��ϵ���ܺ�
E = zeros(L,  1);
for i = 0:L - 1
    E(i + 1) = FilterToPicture(g, K, i);
end

%% 6. �����˲����Ƶ������ͼ
settings.ymin = 0;
[E_normalization, settings] = mapminmax(E', settings);
figure(51), subplot(2, 2, 4), bar(E_normalization'); title('�˲����һ����Ƶ����������ͼ0, 10, 20, ..., 170');