%% 对滤波器的处理
close all;clear all;clc;
N = 512;
gap = 5;
% filter PPfft and rotate and ippfft
[f1, f2] = freqspace(N, 'meshgrid');
% 构造滤波器，频域特性
Hd = ones(N);
k = 10; % 方向斜率
Hd((k * f1 + f2 <= -1/2) | (k * f1 + f2 >= 1/2)| (-k * f1 + f2 <= -1/2) | (-k * f1 + f2 >= 1/2)) = 0;
figure, mesh(f1, f2, Hd), title('Hd');


% 加窗
h3 = fwind1(Hd, hanning(N));
figure, imshow(h3, []), title('h3');
H = freqz2(h3, N, N); title('观察滤波器的频域特性, freqz2, H');

HS = 20 * log10(abs(H) + 1);
figure, mesh(HS(1:gap:N, 1:gap:N)), title('mesh HS');

% 三立方插值将滤波器频谱旋转一定角度
H_rotate = imrotate(HS,120,'bicubic'),mesh(H_rotate(1:gap:N, 1:gap:N)), title('cubic rotate');


% figure, imshow(HS, []), title('HS');
% H = fft2(h3);
% HS = 20 * log10(abs(H) + 1);
% figure, imshow(HS, []), title('H fft');
% figure(8), imshow(H_h3, [ ]);

% 极坐标傅里叶域
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
HRotate = freqz2(h3_rotate, N, N); title('观察滤波器的频域特性, freqz2, HRotate');

HSRotate = 20 * log10(abs(HRotate) + 1);
figure, mesh(HSRotate(1:gap:N, 1:gap:N)), title('mesh HSRotate');