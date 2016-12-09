function [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I, fft_M, fft_N)
%  I输入图像, g_pimer_direction_filtered 输入图像逆滤波后的时域图像, EMax 图像主方向的频谱能量, index_max 频谱能量最大对应的滤波器方向
%  fft_M,  fft_N 傅里叶变换的点数

%% 1. 获得输入图像的尺寸
[block_height, block_width] = size(I);
%% 2. 使用间隔10度的方向滤波器滤波，并得到每个方向的频谱能量
% i = 0:L表示0,10, ..., 180，19个方向
K = 5; % 频谱支撑域斜率
L = 17;
E = zeros(L + 1, 1);
for i = 0:17
    [H_filter, E_direction] = FilterToPicture(I, K, i, fft_M, fft_N);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);
%% 3.判断是否是纹理图像
E_total = sum(E(:));  %各个方向滤波器频谱能量总和
E_avg = E_total / (L + 1);  %各方向的平均频谱能量
Threshold = 0;     %纹理判断的阈值
if  ((E_total == 0) || ((EMax / E_avg) < Threshold))
    is_texture = false;
else
    is_texture = true;
end
%% 3.对子块进行频谱能量最大的方向滤波器的滤波，及逆滤波得到时域图像
if is_texture == true
    [H_filter, EMax] = FilterToPicture(I, K, index_max, fft_M, fft_N);
    g_pimer_direction_filtered = InverseFilter(H_filter, fft_M, fft_N);
    g_pimer_direction_filtered = g_pimer_direction_filtered(1:block_height, 1:block_width);
else
    H_filter = zeros(size(I));
    g_pimer_direction_filtered = InverseFilter(H_filter, fft_M, fft_N);
    g_pimer_direction_filtered = g_pimer_direction_filtered(1:block_height, 1:block_width);
end
%% 4. 绘制 滤波后归一化的频谱能量条形图，从0, 10, 20, ..., 180共19列
settings.ymin = 0;
[E_normalization,settings] = mapminmax(E',settings);
figure(41), subplot(2, 2, 3), bar(E_normalization'); title('滤波后归一化的频谱能量条形图0, 10, 20, ..., 170');