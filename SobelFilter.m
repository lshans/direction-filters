function [pixel_number, pimer_direction_index, Gdir] = SobelFilter(I)
%% 1. ԭʼͼ��I
%% 2. ��������ص���ݶȷ�ֵ�ͽǶ�  
%calculates the gradient magnitude and direction using the specified METHOD.
%  X axis points in the direction of increasing column subscripts and Y axis points in the
%  direction of increasing row subscripts.
% [Gx, Gy] = imgradientxy(I);
% [Gmag, Gdir] = imgradient(Gx, Gy);

[Gmag, Gdir] = imgradient(I,'Sobel');  
%% 3.���ݶȽǽ�������
L = 18; %�Ƕ���������
quantization_angle_step = 180 / L; 
N = 360 / quantization_angle_step; % �ܹ�������1`32 ֮��
Gdir_quantization = mod(ceil(((Gdir + 180) - quantization_angle_step / 2) / quantization_angle_step), N) + 1;
% hist_direction_quantization = hist(Gdir_quantization(:), 1:N); %ͳ��ֱ��ͼ
% [pixel_number, pimer_direction_index] = max(hist_direction_quantization);
TABLE = tabulate(Gdir_quantization(:));  %ͳ�Ƹ�Ԫ�س��ִ���, �ٷֱ�
[pixel_number, pimer_direction_index] = max(TABLE(:,2)); % ͳ�Ƴ��ִ�������Ԫ���Լ����±�
end