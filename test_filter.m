%% ���˲����Ĵ���
close all;clear all;clc;
N = 512;
gap = 5;
% filter PPfft and rotate and ippfft
[f1, f2] = freqspace(N, 'meshgrid');
% �����˲�����Ƶ������
Hd = ones(N);
k = 10; % ����б��
Hd((k * f1 + f2 <= -1/2) | (k * f1 + f2 >= 1/2)| (-k * f1 + f2 <= -1/2) | (-k * f1 + f2 >= 1/2)) = 0;
figure, mesh(f1, f2, Hd), title('Hd');


% �Ӵ�
h3 = fwind1(Hd, hanning(N));
figure, imshow(h3, []), title('h3');
H = freqz2(h3, N, N); title('�۲��˲�����Ƶ������, freqz2, H');

HS = 20 * log10(abs(H) + 1);
figure, mesh(HS(1:gap:N, 1:gap:N)), title('mesh HS');

% ��������ֵ���˲���Ƶ����תһ���Ƕ�
H_rotate = imrotate(HS,120,'bicubic'),mesh(H_rotate(1:gap:N, 1:gap:N)), title('cubic rotate');


% figure, imshow(HS, []), title('HS');
% H = fft2(h3);
% HS = 20 * log10(abs(H) + 1);
% figure, imshow(HS, []), title('H fft');
% figure(8), imshow(H_h3, [ ]);

% �����긵��Ҷ��
H_P = PPFFT(h3,1,1);

i = 9 * N / 16; % i = 0, 1, 2....2 * N - 1
a = zeros(2 * N - i, i); b = eye(2 * N - i); c = eye(i); d = zeros(i, 2 * N - i);
Q = [a, b;c, d];

% HShift_P = Q * H_P;
HShift_P = H_P * Q;

h3_rotate=IPPFFT(HShift_P);
figure, imshow(h3_rotate, []), title('h3Rotate');
figure, mesh(Hd(1:gap:N, 1:gap:N)), title('mesh');
% h3_rotate=uint8(h3_rotate);
HRotate = freqz2(h3_rotate, N, N); title('�۲��˲�����Ƶ������, freqz2, HRotate');

HSRotate = 20 * log10(abs(HRotate) + 1);
figure, mesh(HSRotate(1:gap:N, 1:gap:N)), title('mesh HSRotate');