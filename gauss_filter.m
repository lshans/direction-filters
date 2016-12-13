function g = gauss_filter(I, parameter_of_D0)
%% ������ͼ����и�ͨ�˲���I �Ǵ��˲�������ͼ�� g �����˲����ͼ��, parameter_of_D0 �Ǹ�ͨ�˲�ϵ��D0��ϵ��
% ת���ɸ�����
[f, revertclass] = tofloat(I);
%% 1. ���ͼ��FFT����ƫ��
PQ = paddedsize(size(I));   % ��ȡ������  
F_I = fft2(f, PQ(1), PQ(2)); 
figure(72), subplot(2, 3, 2), imshow(log(abs(fftshift(F_I)) + 1), []); title('log��fftshift���F');

%% 2. ������ͨ�˲���
D0 = parameter_of_D0 * PQ(1); % 0.015 for barbara.raw by lss ,��Ե����Ƚ�ȫ���Ƚ�����.0.013for lena.raw
H = hpfilter('gaussian', PQ(1), PQ(2), D0);
figure(72), subplot(2, 3, 3), imshow(log(abs(fftshift(H)) + 1), []); title('log��fftshift��ĸ�ͨ�˲���H');

%% 3. �˲�
G = F_I .* H;
g = ifft2(G);
figure(72), subplot(2, 3, 4), imshow(log(abs(fftshift(G)) + 1), []); title('log��fftshift��ĸ�ͨ�˲����Ƶ��G');

%% 4. IFFT
% pad����Ҫ�ü�ȡ�����Ͻ�
g = g(1:size(I, 1), 1:size(I, 2));
g = revertclass(g);
figure(72), subplot(2, 3, 5), imshow(g); title('g');
