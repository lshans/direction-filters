% function [pixel_number, pimer_direction_index, Gdir] = SobelFilter(I, L)
function [pixel_number, pimer_direction, Gdir] = SobelFilter(I, L)
% pixel_number��ͳ�Ƴ�������������ظ�����pimer_direction��������ĽǶ�����ֵ��Gdir���ݶȽǾ���, 
% L�Ƿ����˲����ĸ���
%% 1. ԭʼͼ��I
[block_height, block_width] = size(I);
%% 2. ��������ص���ݶȷ�ֵ�ͽǶ�  
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
%% 3.���ݶȽǽ������� 
quantization_angle_step = 180 / L; %�Ƕ���������
N = 360 / quantization_angle_step; % �ܹ�������1`32 ֮��
Gdir_quantization = mod(ceil(((Gdir + 180) - quantization_angle_step / 2) / quantization_angle_step), N) + 1;
Gdir_quantization(l) = -1;
% all �жϾ����Ƿ���ȫ��������������Ϊ�棬ִ��if���
  if  (~all(Gdir_quantization(:) == -1))
    TABLE = tabulate(Gdir_quantization(:));  %ͳ�Ƹ�Ԫ�س��ִ���, �ٷֱ�
    TABLE = TABLE(2:end);     % ��ͳ�Ƴ�����-1��һ�У�ƽ�����򣩹��˵�
% [pixel_number, pimer_direction_index] = max(TABLE(:,2)); % ͳ�Ƴ��ִ�������Ԫ���Լ����±�
    TABLE_sorted = sortrows(TABLE, 2); % ���յڶ�����С�������ž���
    max_line = TABLE_sorted(end, :); %ȡ�����һ�е�ֵ���������������Լ�������������ܸ���
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