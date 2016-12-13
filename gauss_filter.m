function g = gauss_filter(I, parameter_of_D0)
%% 对输入图像进行高通滤波，I 是待滤波的输入图像， g 是逆滤波后的图像, parameter_of_D0 是高通滤波系数D0的系数
% 转换成浮点型
[f, revertclass] = tofloat(I);
%% 1. 填充图的FFT，不偏移
PQ = paddedsize(size(I));   % 获取填充参数  
F_I = fft2(f, PQ(1), PQ(2)); 
figure(72), subplot(2, 3, 2), imshow(log(abs(fftshift(F_I)) + 1), []); title('log和fftshift后的F');

%% 2. 创建高通滤波器
D0 = parameter_of_D0 * PQ(1); % 0.015 for barbara.raw by lss ,边缘纹理比较全，比较明显.0.013for lena.raw
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(72), subplot(2, 3, 3), imshow(log(abs(fftshift(H)) + 1), []); title('log和fftshift后的高通滤波器H');

%% 3. 滤波
G = F_I .* H;
g = ifft2(G);
figure(72), subplot(2, 3, 4), imshow(log(abs(fftshift(G)) + 1), []); title('log和fftshift后的高通滤波后的频谱G');

%% 4. IFFT
% pad后需要裁剪取，左上角
g = g(1:size(I, 1), 1:size(I, 2));
g = revertclass(g);
figure(72), subplot(2, 3, 5), imshow(g); title('g');
