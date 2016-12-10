function direction_filters = create_filter(K, ones_rotate_angle, M, N)
% �˲����ĳߴ�M x N 
L = 180 / ones_rotate_angle;    % �˲����ĸ���
direction_filters = zeros(M, N, L);

%% 1. �����˲�����Ƶ�����ԣ����Ӵ�
[f1, f2] = freqspace([M N], 'meshgrid');
% �����˲�����Ƶ������
Hd = ones(M, N);
% angle_support = 2 * atan(1 / K) * 180 / pi; % ֧�����ſ��ĽǶ�

% ����Ш���˲�����֧����
Hd(((K * f1 - f2 < 0) & (K * f1 + f2 < 0)) | ((K * f1 - f2 > 0) & (K * f1 + f2 > 0))) = 0;

% �Ӵ�
h3 = fwind1(Hd, hanning(N));    % ���ɴ�

% ����Ƶ���˲���
H = freqz2(h3, N, M); 

% ����ֱ������ʱ����ת����L�������˲���
for i = 0: L - 1
    H_rotate = imrotate(H, i * ones_rotate_angle ,'bicubic','crop');
    direction_filters(:, :, i + 1) = H_rotate;
    figure(71), subplot(ceil(sqrt(L)), ceil(sqrt(L)), i + 1), imshow(H_rotate, []);title(['H_rotate', num2str(i)]);
end
end