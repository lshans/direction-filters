function direction_filters = create_filter(K, ones_rotate_angle, M, N)
% 滤波器的尺寸M x N 
L = 180 / ones_rotate_angle;    % 滤波器的个数
direction_filters = zeros(M, N, L);

%% 1. 构造滤波器的频域特性，并加窗
[f1, f2] = freqspace([M N], 'meshgrid');
% 构造滤波器，频域特性
Hd = ones(M, N);
% angle_support = 2 * atan(1 / K) * 180 / pi; % 支撑域张开的角度

% 生成楔形滤波器的支撑域
Hd(((K * f1 - f2 < 0) & (K * f1 + f2 < 0)) | ((K * f1 - f2 > 0) & (K * f1 + f2 > 0))) = 0;

% 加窗
h3 = fwind1(Hd, hanning(N));    % 生成窗

% 生成频域滤波器
H = freqz2(h3, N, M); 

% 从竖直方向逆时针旋转生成L个方向滤波器
for i = 0: L - 1
    H_rotate = imrotate(H, i * ones_rotate_angle ,'bicubic','crop');
    direction_filters(:, :, i + 1) = H_rotate;
    figure(71), subplot(ceil(sqrt(L)), ceil(sqrt(L)), i + 1), imshow(H_rotate, []);title(['H_rotate', num2str(i)]);
end
end