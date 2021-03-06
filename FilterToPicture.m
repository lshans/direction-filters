% TODO：函数名，多于的注释，M和N可以忽略掉一个
function [I_H_filter, E] = FilterToPicture(I, K, rotate_angle, M, N)   % g_filtered 逆滤波后的时域图像， E频域滤波后的频谱能量
% 使用双立方插值法对滤波器旋转从而得到不同方向的滤波器，E是当前滤波器对图像滤波后的频谱能量，I是待滤波的原始图像，K是支撑域的斜率，rotate_angle是由竖直方向逆时针旋转楔形方向滤波器的角度
% M和N是对I需要做[M x N]点的fft2

% TODO 测试I的类型，是否有必要添加tofloat
% m x n点的fft2，比直接使用fft2效果强
F_I = fft2(I, M, N);
F_I = fftshift(F_I);    % 滤波器已经是平移过后的，所以图像要相同处理
figure(73), subplot(2, 3, 3), imshow(F_I, []), title(['滤波器的输入图像的频谱，', num2str(M), '点的FFT2']);

%% 1. 构造滤波器的频域特性，并加窗
[f1, f2] = freqspace([M N], 'meshgrid');
% 构造滤波器，频域特性
Hd = ones(M, N);
angle_support = 2 * atan(1 / K) * 180 / pi; % 支撑域张开的角度
% 生成平行四边形的支撑域 
% Hd((K * f1 + f2 <= -1/2) | (K * f1 + f2 >= 1/2)| (-v * f1 + f2 <= -1/2) | (-K * f1 + f2 >= 1/2)) = 0;

% 生成楔形滤波器的支撑域
Hd(((K * f1 - f2 < 0) & (K * f1 + f2 < 0)) | ((K * f1 - f2 > 0) & (K * f1 + f2 > 0))) = 0;

% 加窗
h3 = fwind1(Hd, hanning(N));    % 生成窗
% TODO figure
% figure, imshow(h3, []), title('h3');
% 由时域冲击响应得到频域的系统函数，N和M表示 M x N大小的滤波器，由于是时域是循环卷积，注意生成滤波器要和图像一致，才可以在频域直接阵列乘法
H = freqz2(h3, N, M); 
% title('观察滤波器的频域特性, freqz2, H');


% 滤波器的频域图像，显示用
Wx = linspace(-pi,pi/16,pi); Wy = linspace(-pi,pi/16,pi);
% gap = 1;    % mesh显示时的间隔
% HS = 20 * log10(abs(H) + 1); figure, mesh(HS(1:gap:N, 1:gap:N)), title('mesh HS');
% % figure, imshow(HS, []);title('imshow HS')


%% 2. 三立方插值将滤波器频谱旋转一定角度，得到对应L的方向滤波器
% 将图像A（图像的数据矩阵）绕图像的中心点旋转angle度， 正数表示逆时针旋转， 负数表示顺时针旋转。返回旋转后的图像矩阵。
% B = imrotate(A,angle,method,bbox),bbox参数用于指定输出图像属性：
% 'crop'： 通过对旋转后的图像B进行裁剪， 保持旋转后输出图像B的尺寸和输入图像A的尺寸一样。
% 'loose'： 使输出图像足够大， 以保证源图像旋转后超出图像尺寸范围的像素值没有丢失。 一般这种格式产生的图像的尺寸都要大于源图像的尺寸。 

H_rotate = imrotate(H, rotate_angle,'bicubic','crop'); 
% figure, mesh(H_rotate(1:gap:N, 1:gap:N)); title('cubic rotate');
figure(41), subplot(2, 2, 1), imshow(H_rotate, []);title('H_rotate')

%% 3. 频域相乘，实现滤波
I_H_filter = H_rotate .* F_I;
% I_H_filter_int8 = uint8(I_H_filter), mesh(I_H_filter_int8(1:gap:N, 1:gap:N)); title('filtered picture');

%% 4. 计算滤波后频谱能量，傅里叶变换后的傅里叶变换系数的平方和，作为频谱能量
A = abs(I_H_filter);
E = sum(A(:).^2);
end