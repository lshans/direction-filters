function [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I)
% I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
% I_rgb = load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\I8.mat');
% IGray = rgb2gray(I_rgb.I8);

%% 1. 载入图像
% % 加载ImgArr，存储了0, 10, ..., 180共十九个方向的样本图像
% load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ImgArr.mat');
% index = 5;
% I = ImgArr(:, :, index);
% % 统一尺寸
% I = I(1:500, 1:500);
% % load('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\ICombined_5_13.mat');
% % I = ICombined(1:500, 1:500);
% figure, imshow(I), title(['原始图像旋转', num2str((index - 1) * 10), '度，从纵轴开始逆时针旋转'])

%% 2. 使用间隔10度的方向滤波器滤波，并得到每个方向的频谱能量
% i = 0:L表示0,10, ..., 180，19个方向
K = 12; % 频谱支撑域斜率
L = 35;
E = zeros(L + 1, 1);
for i = 0:35
    [H_filter, E_direction] = FilterToPicture(I, K, i);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);
%% 3.判断是否是纹理图像
E_total = sum(E(:));  %各个方向滤波器频谱能量总和
E_avg = E_total / (L + 1);  %各方向的平均频谱能量
Threshold = 0;     %纹理判断的阈值
if  ((E_total == 0) | ((EMax / E_avg) < Threshold))
    is_texture = false;
else
    is_texture = true;
end
%% 3.对子块进行频谱能量最大的方向滤波器的滤波，及逆滤波得到时域图像
if is_texture == true
    [H_filter, EMax] = FilterToPicture(I, K, index_max);
    g_pimer_direction_filtered = InverseFilter(H_filter);
else
    H_filter = zeros(size(I));
    g_pimer_direction_filtered = InverseFilter(H_filter);
end
%% 4. 绘制 滤波后归一化的频谱能量条形图，从0, 10, 20, ..., 180共19列
settings.ymin = 0;
[E_normalization,settings] = mapminmax(E',settings);
% figure(16), bar(E_normalization'); title('滤波后归一化的频谱能量条形图0, 10, 20, ..., 180');