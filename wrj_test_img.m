clear all;
close all;
clc;

%% 1. ����ͼ��
fp = fopen('E:\��Ŀ\����Ԥ��\directionFilterProject\barbara.raw', 'r');
M = 512; N = 512;
img = fread(fp, [M, N],'uint8'); % �����е�˳������ͼ�����512 x 512 �ľ���
img = uint8(img');
fclose(fp);
I = img(129:384, 129:384); %��ȡ����ͼ��
I = I(197:200, 201:204);
figure(1), imshow(I);
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
[img_height, img_width] = size(I);

block_height = 4; block_width = 4;
block_height_num = img_height / block_height;
block_width_num = img_width / block_width;

[f, revertclass] = tofloat(I);
figure(61), subplot(2, 2, 1), imshow(f, []), title(['ԭʼ��ͼ', sprintf('%d x %d', img_height, img_width)]);
I = f;
% ��ȡ������
PQ = paddedsize(size(I));   
% ���ͼ��FFT����ƫ��
F_I = fft2(I, PQ(1), PQ(2)); 
figure(62), subplot(2, 2, 1), imshow(log(abs(fftshift(F_I)) + 1), []); title('log��fftshift���F');

%% 2. ������ͨ�˲���
D0 = 0.015 * PQ(1); % 0.015 for barbara.raw by lss ,��Ե����Ƚ�ȫ���Ƚ�����.0.013for lena.raw
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(62), subplot(2, 2, 2), imshow(log(abs(fftshift(H)) + 1), []); title('log��fftshift���H');

%% 3. �˲�
G = F_I .* H;
g = ifft2(G);
figure(62), subplot(2, 2, 3), imshow(log(abs(fftshift(G)) + 1), []); title('log��fftshift���G');

%% 4. IFFT
% pad����Ҫ�ü�ȡ�����Ͻ�
g = g(1:size(I, 1), 1:size(I, 2));
% figure, imshow(g, []); title('IFFT1������');
% figure, imshow(uint8(g)); title('IFFT2, uint8');
g = revertclass(g);
figure(61), subplot(2, 2, 2), imshow(g); title('reverclass');
%% test��ͨ�˲����ͼ���ԭͼ������ӣ����½��ͼ
% g_revertclass_I = g + revertclass(f);
% figure(63),imshow(g_revertclass_I);
%% 5. �ֿ鴦��
fft_M = 128; fft_N = 128;
E = cell(block_height_num, block_width_num);
Grad_origin = cell(block_height_num, block_width_num);
Grad_gauss = cell(block_height_num, block_width_num);
% ���˲����ԭͼ���ݾ���
G = zeros(size(I), 'uint8');
same_block_count = 0;
unsame_block_count = 0;
for r = 0 : block_height_num - 1
    for c = 0: block_width_num - 1
       %% �����˲��� by lss
        I_gauss_block = g(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        figure(51), subplot(2, 2, 1), imshow(I_gauss_block); title('ʱ��ͼ���');
        [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I_gauss_block, fft_M, fft_N);
        E{r + 1, c + 1} = [EMax, index_max];
        G(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width) = g_pimer_direction_filtered;
        fprintf('�������(%d, %d)�е�ͼ���\n', r, c);
        %% sobel �ݶȼ��㷽���õ���������
        I_origin_block = I(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        [pixel_number_origin, pimer_direction_index_origin, Gdir_origin] = SobelFilter(im2uint8(I_origin_block));
        Grad_origin{r + 1, c + 1} = [pixel_number_origin, pimer_direction_index_origin];
        [pixel_number_gauss, pimer_direction_index_gauss, Gdir_gauss] = SobelFilter(I_gauss_block);
        Grad_gauss{r + 1, c + 1} = [pixel_number_gauss, pimer_direction_index_gauss];
        %% ͳ�����ַ����ķ����Ƿ�һ��
        transport_pimer_direction_index = mod(mod(pimer_direction_index_gauss + 9, 37) + 1, 19) + 1;
        % index_max == (transport_pimer_direction_index) 
        if (index_max) == (transport_pimer_direction_index)
            same_block_count = same_block_count + 1;
        else
            unsame_block_count = unsame_block_count + 1;
        end
    end
end
%% 6.��ʾ���˲����ʱ��ͼ��
figure(66), imshow(G);