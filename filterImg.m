function [G, E_direction] = filterImg(I, H, M, N)
% M x N ���fft2

% fft2
F_I = fft2(I, M, N);
F_I = fftshift(F_I);	% �˲����Ѿ���ƽ�ƹ���ģ�����ͼ��Ҫ��ͬ����
figure(43), subplot(2, 2, 1), imshow(F_I, []), title(['�˲���������ͼ���Ƶ�ף�', num2str(M), '���FFT2']);

% �˲�
G = H .* F_I;
% I_H_filter_int8 = uint8(I_H_filter), mesh(I_H_filter_int8(1:gap:N, 1:gap:N)); title('filtered picture');

% �����˲���Ƶ������������Ҷ�任��ĸ���Ҷ�任ϵ����ƽ���ͣ���ΪƵ������
A = abs(G);
E_direction = sum(A(:).^2);
end