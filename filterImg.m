function [G, E_direction] = filterImg(I, H, M, N)
% M x N 点的fft2

% fft2
F_I = fft2(I, M, N);
F_I = fftshift(F_I);	% 滤波器已经是平移过后的，所以图像要相同处理
figure(43), subplot(2, 2, 1), imshow(F_I, []), title(['滤波器的输入图像的频谱，', num2str(M), '点的FFT2']);

% 滤波
G = H .* F_I;
% I_H_filter_int8 = uint8(I_H_filter), mesh(I_H_filter_int8(1:gap:N, 1:gap:N)); title('filtered picture');

% 计算滤波后频谱能量，傅里叶变换后的傅里叶变换系数的平方和，作为频谱能量
A = abs(G);
E_direction = sum(A(:).^2);
end