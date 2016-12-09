function [g_pimer_direction_filtered, EMax, index_max] = deblock_filter(I, fft_M, fft_N)
%  I����ͼ��, g_pimer_direction_filtered ����ͼ�����˲����ʱ��ͼ��, EMax ͼ���������Ƶ������, index_max Ƶ����������Ӧ���˲�������
%  fft_M,  fft_N ����Ҷ�任�ĵ���

%% 1. �������ͼ��ĳߴ�
[block_height, block_width] = size(I);
%% 2. ʹ�ü��10�ȵķ����˲����˲������õ�ÿ�������Ƶ������
% i = 0:L��ʾ0,10, ..., 180��19������
K = 5; % Ƶ��֧����б��
L = 17;
E = zeros(L + 1, 1);
for i = 0:17
    [H_filter, E_direction] = FilterToPicture(I, K, i, fft_M, fft_N);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);
%% 3.�ж��Ƿ�������ͼ��
E_total = sum(E(:));  %���������˲���Ƶ�������ܺ�
E_avg = E_total / (L + 1);  %�������ƽ��Ƶ������
Threshold = 0;     %�����жϵ���ֵ
if  ((E_total == 0) || ((EMax / E_avg) < Threshold))
    is_texture = false;
else
    is_texture = true;
end
%% 3.���ӿ����Ƶ���������ķ����˲������˲��������˲��õ�ʱ��ͼ��
if is_texture == true
    [H_filter, EMax] = FilterToPicture(I, K, index_max, fft_M, fft_N);
    g_pimer_direction_filtered = InverseFilter(H_filter, fft_M, fft_N);
    g_pimer_direction_filtered = g_pimer_direction_filtered(1:block_height, 1:block_width);
else
    H_filter = zeros(size(I));
    g_pimer_direction_filtered = InverseFilter(H_filter, fft_M, fft_N);
    g_pimer_direction_filtered = g_pimer_direction_filtered(1:block_height, 1:block_width);
end
%% 4. ���� �˲����һ����Ƶ����������ͼ����0, 10, 20, ..., 180��19��
settings.ymin = 0;
[E_normalization,settings] = mapminmax(E',settings);
figure(41), subplot(2, 2, 3), bar(E_normalization'); title('�˲����һ����Ƶ����������ͼ0, 10, 20, ..., 170');