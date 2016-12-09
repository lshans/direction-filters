%% ���˲����Ĵ���
close all;clear all;clc;
N = 4;

% filter PPfft and rotate and ippfft
[f1, f2] = freqspace(N, 'meshgrid');
% �����˲�����Ƶ������
Hd = ones(N);
k = 4; % ����б��
% Hd((k * f1 + f2 <= -1/2) | (k * f1 + f2 >= 1/2)| (-k * f1 + f2 <= -1/2) | (-k * f1 + f2 >= 1/2)) = 0;
Hd(((k * f1 - f2 < 0) & (k * f1 + f2 < 0)) | ((k * f1 - f2 > 0) & (k * f1 + f2 > 0))) = 0;
figure, mesh(f1, f2, Hd), title('Hd');
figure(1),imshow(Hd, []);title('imshow Hd');

% �Ӵ�
h3 = fwind1(Hd, hanning(N));
% % figure, imshow(h3, []), title('h3');
% ��ʱ������Ӧ�õ�Ƶ���ϵͳ������N��M��ʾ M x N��С���˲�����������ʱ����ѭ�������ע�������˲���Ҫ��ͼ��һ�£��ſ�����Ƶ��ֱ�����г˷�
H = freqz2(h3, N, N); 
% title('�۲��˲�����Ƶ������, freqz2, H');

% �˲�����Ƶ��ͼ��
gap = 1;    % mesh��ʾʱ�ļ��
HS = 20 * log10(abs(H) + 1); 
Wx = linspace(-pi,pi/16,pi); Wy = linspace(-pi,pi/16,pi);
% figure, mesh(HS(1:gap:N, 1:gap:N)), title('mesh HS');
% % figure, imshow(HS, []);title('imshow HS')


%% 2. ��������ֵ���˲���Ƶ����תһ���Ƕȣ��õ���ӦL�ķ����˲���
% ��ͼ��A��ͼ������ݾ�����ͼ������ĵ���תangle�ȣ� ������ʾ��ʱ����ת�� ������ʾ˳ʱ����ת��������ת���ͼ�����
% B = imrotate(A,angle,method,bbox),bbox��������ָ�����ͼ�����ԣ�
% 'crop'�� ͨ������ת���ͼ��B���вü��� ������ת�����ͼ��B�ĳߴ������ͼ��A�ĳߴ�һ����
% 'loose'�� ʹ���ͼ���㹻�� �Ա�֤Դͼ����ת�󳬳�ͼ��ߴ緶Χ������ֵû�ж�ʧ�� һ�����ָ�ʽ������ͼ��ĳߴ綼Ҫ����Դͼ��ĳߴ硣
% H_rotate = imrotate(H, L * angle_support,'bicubic','crop'); 
H_rotate = imrotate(H, 60,'bicubic','crop'); 
% figure, mesh(H_rotate(1:gap:N, 1:gap:N)); title('cubic rotate');
figure, imshow(H_rotate, []);title('imshow H_rotate')
