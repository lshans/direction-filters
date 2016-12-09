function [pixel_number, pimer_direction_index, Gdir] = SobelFilter(I)
%% 1. 原始图像I
%% 2. 计算各像素点的梯度幅值和角度  
%calculates the gradient magnitude and direction using the specified METHOD.
%  X axis points in the direction of increasing column subscripts and Y axis points in the
%  direction of increasing row subscripts.
% [Gx, Gy] = imgradientxy(I);
% [Gmag, Gdir] = imgradient(Gx, Gy);

[Gmag, Gdir] = imgradient(I,'Sobel');  
%% 3.对梯度角进行量化
L = 18; %角度量化步长
quantization_angle_step = 180 / L; 
N = 360 / quantization_angle_step; % 总共量化到1`32 之间
Gdir_quantization = mod(ceil(((Gdir + 180) - quantization_angle_step / 2) / quantization_angle_step), N) + 1;
% hist_direction_quantization = hist(Gdir_quantization(:), 1:N); %统计直方图
% [pixel_number, pimer_direction_index] = max(hist_direction_quantization);
TABLE = tabulate(Gdir_quantization(:));  %统计各元素出现次数, 百分比
[pixel_number, pimer_direction_index] = max(TABLE(:,2)); % 统计出现次数最多的元素以及其下标
end