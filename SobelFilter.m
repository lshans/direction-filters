% function [pixel_number, pimer_direction_index, Gdir] = SobelFilter(I, L)
function [pixel_number, pimer_direction, Gdir] = SobelFilter(I, L)
% pixel_number是统计出来主方向的像素个数，pimer_direction是主方向的角度量化值，Gdir是梯度角矩阵, 
% L是方向滤波器的个数
%% 1. 原始图像I
[block_height, block_width] = size(I);
%% 2. 计算各像素点的梯度幅值和角度  
%calculates the gradient magnitude and direction using the specified METHOD.
%  X axis points in the direction of increasing column subscripts and Y axis points in the
%  direction of increasing row subscripts.
[Gx, Gy] = imgradientxy(I);
l_x = abs(Gx) < 5;  % logic
l_y = abs(Gy) < 5;
l = l_x & l_y;

% display(Gx);display(Gy);
[Gmag, Gdir] = imgradient(Gx, Gy);
[Gmag, Gdir] = imgradient(I,'Sobel');  
%% 3.对梯度角进行量化 
quantization_angle_step = 180 / L; %角度量化步长
N = 360 / quantization_angle_step; % 总共量化到1`32 之间
Gdir_quantization = mod(ceil(((Gdir + 180) - quantization_angle_step / 2) / quantization_angle_step), N) + 1;
Gdir_quantization(l) = -1;
% all 判断矩阵是否是全零矩阵，如果不是则为真，执行if语句
  if  (~all(Gdir_quantization(:) == -1))
    TABLE = tabulate(Gdir_quantization(:));  %统计各元素出现次数, 百分比
    TABLE = TABLE(2:end);     % 把统计出来的-1那一列（平滑区域）过滤掉
% [pixel_number, pimer_direction_index] = max(TABLE(:,2)); % 统计出现次数最多的元素以及其下标
    TABLE_sorted = sortrows(TABLE, 2); % 按照第二列由小到大重排矩阵
    max_line = TABLE_sorted(end, :); %取出最后一行的值，代表着主方向，以及主方向的像素总个数
    pixel_number = max_line(2);
    if pixel_number < 3
        pimer_direction  = -1;
    else
        pimer_direction = max_line(1);
    end
  else
    pixel_number = block_height * block_width;
    pimer_direction = -1;
  end
end