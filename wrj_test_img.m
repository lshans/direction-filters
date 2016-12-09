%% ���Է����˲���
clear all; close all; clc;

%% 1. ����ͼ��
fp = fopen('E:\��Ŀ\����Ԥ��\directionFilterProject\barbara.raw', 'r');
M = 512; N = 512;
img = fread(fp, [M, N],'uint8'); % �����е�˳������ͼ�����512 x 512 �ľ���
img = uint8(img');
fclose(fp);

I = img(129:384, 129:384); %��ȡ����ͼ��
I = I(197:200, 201:204);    % ȡһ��С����ʵ��
figure(31), subplot(2, 2, 1), imshow(I), title('�������ͼ��');
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
[img_height, img_width] = size(I);

block_height = 4; block_width = 4;
block_height_num = img_height / block_height;
block_width_num = img_width / block_width;

% ת���ɸ�����
[f, revertclass] = tofloat(I);
figure(61), subplot(2, 2, 1), imshow(f, []), title(['ԭʼ��ͼ', sprintf('%d x %d', img_height, img_width)]);

% ���ͼ��FFT����ƫ��
PQ = paddedsize(size(I));   % ��ȡ������  
F_I = fft2(f, PQ(1), PQ(2)); 
figure(62), subplot(2, 2, 1), imshow(log(abs(fftshift(F_I)) + 1), []); title('log��fftshift���F');

%% 2. ������ͨ�˲���
D0 = 0.015 * PQ(1); % 0.015 for barbara.raw by lss ,��Ե����Ƚ�ȫ���Ƚ�����.0.013for lena.raw
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(62), subplot(2, 2, 2), imshow(log(abs(fftshift(H)) + 1), []); title('log��fftshift��ĸ�ͨ�˲���H');

%% 3. �˲�
G = F_I .* H;
g = ifft2(G);
figure(62), subplot(2, 2, 3), imshow(log(abs(fftshift(G)) + 1), []); title('log��fftshift��ĸ�ͨ�˲����Ƶ��G');

%% 4. IFFT
% pad����Ҫ�ü�ȡ�����Ͻ�
g = g(1:size(I, 1), 1:size(I, 2));
g = revertclass(g);
figure(61), subplot(2, 2, 2), imshow(g); title('reverclass');

%% 5. �ֿ鴦��
fft_M = 128; fft_N = 128;   % fft2��ĸ���
E = cell(block_height_num, block_width_num);    % ÿ��С��
Grad_origin = cell(block_height_num, block_width_num);  % ԭʼͼ������sobel������ݶȼ�������Ϣ
Grad_gauss = cell(block_height_num, block_width_num);   % ��ͨv�˲����ͼ������sobel������ݶȼ�������Ϣ
G = zeros(size(I), 'uint8');    % ���˲���ͼ�񣬴�ͼ
same_block_count = 0;           % ���ַ���������ͬ��С����
unsame_block_count = 0;         % ����ͬ��
% �ֿ鴦��
for r = 0 : block_height_num - 1
    for c = 0: block_width_num - 1
       %% �����˲������Ը�˹�˲����ͼ����
        % �Ը�˹�˲����ͼ��ֿ�
        I_gauss_block = g(r * block_height + 1 : (r + 1) * block_height, c * block_width + 1 : (c + 1) * block_width);
        figure(51), subplot(2, 2, 1), imshow(I_gauss_block); title('ʱ��ͼ���');
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
figure(31), subplot(2, 2, 2), imshow(G), title('���˲����ͼ��');