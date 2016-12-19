% TODO:������������
function [g_pimer_direction_filtered, EMax, index_max] = wedge_shape_filter(L, I, fft_M, fft_N)

global direction_filters;

%  L �����˲����ĸ���, I����ͼ��, g_pimer_direction_filtered ����ͼ��I���˲����ͼ��, EMax ͼ���������Ƶ������,
%  TODO��index_max Ƶ����������Ӧ���˲�������index��1:L + 1���±꣩
%  fft_M,  fft_N ����Ҷ�任�ĵ���

%% 1. �������ͼ��ĳߴ�
[block_height, block_width] = size(I);

%% 2. ʹ��һ��Ш�η����˲��������˲������õ�ÿ�������Ƶ������������180��
K = 10; % Ƶ��֧����б��
ones_rotate_angle = 180 / L; % ��ԭʼ��ֱ�����Ш�η����˲�����ʼ��ת������Ш�η����˲���֮����ת�ĽǶ�(��ÿ����ת�ĽǶ�)
E = zeros(L, 1);
% ���������˲�����
if isempty(direction_filters)
    direction_filters = create_filter(K, ones_rotate_angle, fft_M, fft_N);
end

% ����������F
F_I = fft2(I, fft_M, fft_N);
F_I = fftshift(F_I);	% �˲����Ѿ���ƽ�ƹ���ģ�����ͼ��Ҫ��ͬ����
% figure(73), subplot(2, 3, 3), imshow(F_I, []), title(['�˲���������ͼ���Ƶ�ף�', num2str(fft_M), '���FFT2']);

% i * ones_rotate_angle ���У�i = 0:L�� ��ʾ����ֱ������ʱ����ת 0��,10��, ..., 170�ȣ���18������
for i = 0:L-1
    % �˲�
    H_filter = direction_filters(:, :, i + 1) .* F_I;
    
    % �����˲���Ƶ������������Ҷ�任��ĸ���Ҷ�任ϵ����ƽ���ͣ���ΪƵ������
    A = abs(H_filter);
    E_direction = sum(A(:).^2);
    E(i + 1) = E_direction;
end
[EMax, index_max] = max(E);
figure(73), subplot(2, 3, 2), imshow(real(direction_filters(:, :, index_max)), []), title(['��ǰС��õ�����ѷ����˲��� (1, 2, ...)', num2str(index_max)]);

%% 3.�ж��Ƿ�������ͼ��
E_total = sum(E(:));  %���������˲���Ƶ�������ܺ�
E_avg = E_total / L;  %�������ƽ��Ƶ������
Threshold = 0;     %�����жϵ���ֵ
if  ((E_total == 0) || ((EMax / E_avg) < Threshold))
    is_texture = false;
else
    is_texture = true;
end

%% 3.���ӿ����Ƶ���������ķ����˲������˲��������˲��õ�ʱ��ͼ��
if is_texture == true
    H_filter = direction_filters(:, :, index_max) .* F_I;
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
figure(73), subplot(2, 3, 1), imshow(I); title(['��˹�˲����ʱ��ͼ���', num2str(size(I))]);
figure(73), subplot(2, 3, 3), imshow(real(F_I), []), title(['�˲���������ͼ���Ƶ�ף�', num2str(fft_M), '���FFT2']);
figure(73), subplot(2, 3, 4), bar(E_normalization'); title('�˲����һ����Ƶ����������ͼ0, 10, 20, ..., 170');