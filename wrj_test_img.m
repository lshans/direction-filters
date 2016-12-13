%% ���Է����˲���
clear all; close all; clc;
tic;
%% 1. ����ͼ��
fp = fopen('.\lena.raw', 'r');
M = 512; N = 512;
img = fread(fp, [M, N],'uint8'); % �����е�˳������ͼ�����512 x 512 �ľ���
img = uint8(img');
fclose(fp);

I = img(129:384, 129:384); %��ȡ����ͼ��
%I = I(5:8, 1:4);    % ȡһ��С����ʵ��
figure(72), subplot(2, 3, 1), imshow(I), title(['I ', num2str(size(I))]);
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
[img_height, img_width] = size(I);

block_height = 32; block_width = 32;
block_height_num = img_height / block_height;
block_width_num = img_width / block_width;

% ת���ɸ�����
% [f, revertclass] = tofloat(I);
% figure(61), subplot(2, 2, 1), imshow(f, []), title(['ԭʼ��ͼ', sprintf('%d x %d', img_height, img_width)]);
%% 2.������ͼ����и�ͨ�˲�
% g = gauss_filter(I);

%% 3. �ֿ鴦��
fft_M = 128; fft_N = 128;   % fft2��ĸ���
E = cell(block_height_num, block_width_num);    % ÿ��С��
Grad_origin = cell(block_height_num, block_width_num);  % ԭʼͼ������sobel������ݶȼ�������Ϣ
Grad_gauss = cell(block_height_num, block_width_num);   % ��ͨv�˲����ͼ������sobel������ݶȼ�������Ϣ
G = zeros(size(I), 'uint8');    % ���˲���ͼ�񣬴�ͼ

% various_block_cnt.smoothing_block_cnt = 0;  % ƽ��ͼ���
% various_block_cnt.same_direction_block_cnt = 0;  % ���ַ���������ͬ��С����
% various_block_cnt.unsame_direction_block_cnt = 0; % ����ͬ�� 
% various_block_cnt.nearly_direction_block_cnt = 0; % ����ӽ��ģ���1
% various_block_cnt.different_two_direction_cnt = 0; % �����������Ŀ� 
% various_block_cnt.different_three_direction_cnt = 0; % �����������Ŀ�
% various_block_cnt.different_four_direction_cnt = 0; % ����ĸ�����Ŀ�
various_block_cnt_arr = zeros(11, 1);  %ͳ��Ш���˲�����sobel���ַ����õ����������������Ƕȵ�ͼ�����Ŀ��0~90��֮�ڷֱ��¼�ڵ�1��10��,���һ�м�¼ƽ����ĸ���
Different_block = cell(block_height_num, block_width_num); %��������һ�µ�ͼ�������ַ����¼������һ����֤
% �ֿ鴦��
for r = 0 : block_height_num - 1
    for c = 0: block_width_num - 1
       %% �����˲������Ը�˹�˲����ͼ����
        % �Ը�˹�˲����ͼ��ֿ�
        I_gauss_block = g(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        % figure(73), subplot(2, 3, 1), imshow(I_gauss_block); title(['��˹�˲����ʱ��ͼ���', num2str(size(I_gauss_block))]);
        % �˲�
        [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I_gauss_block, fft_M, fft_N);
        E{r + 1, c + 1} = [EMax, index_max];
        % �洢���˲�ͼ��
        G(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width) = g_pimer_direction_filtered;
        fprintf('�������(%d, %d)�е�ͼ���\n', r, c);
        
       %% sobel �ݶȼ��㷽���õ��������򣬷ֱ�Ը�˹�˲����ԭʼͼ���ͼ����
        % �����ݶ�
        [pixel_number_gauss, pimer_direction_index_gauss, Gdir_gauss] = SobelFilter(I_gauss_block);
        Grad_gauss{r + 1, c + 1} = [pixel_number_gauss, pimer_direction_index_gauss];
        
        % ��ԭʼͼ��ֿ�
        I_origin_block = I(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        % �����ݶ�
        [pixel_number_origin, pimer_direction_index_origin, Gdir_origin] = SobelFilter(I_origin_block);
        Grad_origin{r + 1, c + 1} = [pixel_number_origin, pimer_direction_index_origin];
        
       %% TODO: �ȽϹ�ʽ��ȷ��
        %ͳ�����ַ����ķ����Ƿ�һ��
%         numberic_index = char(index_max) - '0';
        [various_block_cnt_arr, flag] = direction_consistency_compare(EMax, index_max, pimer_direction_index_gauss, various_block_cnt_arr);
        if flag == false
          Different_block{r + 1, c + 1} = [index_max, pimer_direction_index_gauss];
        end
    end
end

%% 4.��ʾ���˲����ʱ��ͼ��
figure(72), subplot(2, 3, 6), imshow(G), title('���˲����ͼ��');
t = toc