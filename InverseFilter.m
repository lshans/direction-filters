function g_filtered = InverseFilter(I_H_filter)
%% 逆滤波得到滤波后的时域图像
I_filtered = ifft2(ifftshift(I_H_filter));
I_filtered = I_filtered / 255.0;
g_filtered = im2uint8(I_filtered);
% figure(64), imshow(g_filtered);
end