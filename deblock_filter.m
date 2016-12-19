% TODO:函数名不合适
function [g_pimer_direction_filtered, EMax, index_max] = wedge_shape_filter(L, I, fft_M, fft_N)

global direction_filters;

%  L 方向滤波器的个数, I输入图像, g_pimer_direction_filtered 输入图像I逆滤波后的图像, EMax 图像主方向的频谱能量,
%  TODO：index_max 频谱能量最大对应的滤波器方向（index是1:L + 1的下标）
%  fft_M,  fft_N 傅里叶变换的点数

%% 1. 获得输入图像的尺寸
[block_height, block_width] = size(I);

%% 2. 使用一组楔形方向滤波器进行滤波，并得到每个方向的频谱能量，覆盖180度
K = 10; % 频谱支撑域斜率
ones_rotate_angle = 180 / L; % 由原始竖直方向的楔形方向滤波器开始旋转，相邻楔形方向滤波器之间旋转的角度(即每次旋转的角度)
E = zeros(L, 1);
% 创建方向滤波器组
if isempty(direction_filters)
    direction_filters = create_filter(K, ones_rotate_angle, fft_M, fft_N);
end

% 计算输入块的F
F_I = fft2(I, fft_M, fft_N);
F_I = fftshift(F_I);	% 滤波器已经是平移过后的，所以图像要相同处理
% figure(73), subplot(2, 3, 3), imshow(F_I, []), title(['滤波器的输入图像的频谱，', num2str(fft_M), '点的FFT2']);

% i * ones_rotate_angle 其中，i = 0:L， 表示由竖直方向逆时针旋转 0度,10度, ..., 170度，共18个方向
for i = 0:L-1
    % 滤波
    H_filter = direction_filters(:, :, i + 1) .* F_I;
    
    % 计算滤波后频谱能量，傅里叶变换后的傅里叶变换系数的平方和，作为频谱能量
    A = abs(H_filter);
    E_direction = sum(A(:).^2);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);
figure(73), subplot(2, 3, 2), imshow(real(direction_filters(:, :, index_max)), []), title(['当前小块得到的最佳方向滤波器 (1, 2, ...)', num2str(index_max)]);

%% 3.判断是否是纹理图像
E_total = sum(E(:));  %各个方向滤波器频谱能量总和
E_avg = E_total / L;  %各方向的平均频谱能量
Threshold = 0;     %纹理判断的阈值
if  ((E_total == 0) || ((EMax / E_avg) < Threshold))
    is_texture = false;
else
    is_texture = true;
end

%% 3.对子块进行频谱能量最大的方向滤波器的滤波，及逆滤波得到时域图像
if is_texture == true
    H_filter = direction_filters(:, :, index_max) .* F_I;
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
figure(73), subplot(2, 3, 1), imshow(I); title(['高斯滤波后的时域图像块', num2str(size(I))]);
figure(73), subplot(2, 3, 3), imshow(real(F_I), []), title(['滤波器的输入图像的频谱，', num2str(fft_M), '点的FFT2']);
figure(73), subplot(2, 3, 4), bar(E_normalization'); title('滤波后归一化的频谱能量条形图0, 10, 20, ..., 170');