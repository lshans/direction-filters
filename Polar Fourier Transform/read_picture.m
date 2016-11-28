clear all;
close all;
clc;

%% ��ͼ��Ĵ���
N = 512;
I = imread('C:\Users\Administrator\Downloads\Compressed\06538707Polar-Fourier-Transform\Polar Fourier Transform\lena.tif');
F = fft2(I);
S = 20*log10(abs(F) + 1);
figure, imshow(S, []), title('S');
Fc = fftshift(F);
S2 = 20 * log10(abs(Fc) + 1);
figure, imshow(S2, []), title('S2');

% change_I = -ones(N, N);
% x = [1:N]; x = repmat(x, [N, 1]);
% y = [1:N]'; y = repmat(y, [1, N]);
% change_I = change_I .^(x + y);
% change_I = int8(change_I);
% X_change_I = (int8(X)) .* change_I;
% out_change_I = uint8(X_change_I);
% figure(1),imshow(out_change_I);
% H_out_change_I = fft2(out_change_I);
% H_out_change_I=20*log10(abs(H_out_change_I));
% figure(4), imshow(H_out_change_I, [ ]);

% �����긵��Ҷ�任
F_P = PPFFT(I,1,1);

% ����ƽ�ƾ���
i = 20; % i = 0, 1, 2....2 * N - 1
a = zeros(2 * N - i, i); b = eye(2 * N - i); c = eye(i); d = zeros(i, 2 * N - i);
Q = [a, b;c, d];

% �������µ�ƽ�Ʊ任
FShift_P = Q * F_P;

% �����긵��Ҷ��任�����ƽ�
IRotate = IPPFFT(FShift_P);
% disp(norm(X1-X));
% out=uint8(X1);
% figure(5),imshow(out);
figure, imshow(IRotate, []), title('�ڼ������¾���ƽ�ƣ��ٸ���Ҷ���任���ԭͼ')
FRotate = fft2(IRotate);
SRorate = 20*log10(abs(FRotate) + 1);
figure, imshow(SRorate, []), title('ԭͼ��ת���Ƶ��')

FcRotate = fftshift(FRotate);
S2Rotate = 20 * log10(abs(FcRotate) + 1);
figure, imshow(S2Rotate, []), title('S2Rotate');

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
% figure, imshow(HS, []), title('HS');
% H = fft2(h3);
% HS = 20 * log10(abs(H) + 1);
% figure, imshow(HS, []), title('H fft');
% figure(8), imshow(H_h3, [ ]);

% �����긵��Ҷ��
H_P = PPFFT(h3,1,1);

i = 0; % i = 0, 1, 2....2 * N - 1
a = zeros(2 * N - i, i); b = eye(2 * N - i); c = eye(i); d = zeros(i, 2 * N - i);
Q = [a, b;c, d];

HShift_P = Q * H_P;
HShift_P = H_P * Q;

h3_rotate=IPPFFT(HShift_P);
figure, imshow(h3_rotate, []), title('h3Rotate');
figure, mesh(Hd(1:gap:N, 1:gap:N)), title('mesh');
% h3_rotate=uint8(h3_rotate);
HRotate = freqz2(h3_rotate, N, N); title('�۲��˲�����Ƶ������, freqz2, HRotate');

HSRotate = 20 * log10(abs(HRotate) + 1);
figure, mesh(HSRotate(1:gap:N, 1:gap:N)), title('mesh HSRotate');

HSRotate = 20 * log10(abs(HRotate) + 1);
% figure, imshow(HSRotate, []), title('HSRotate');



H_h3_rotate = fft2(h3_rotate);
H_h3_rotate = 20000*log10(abs(H_h3_rotate));
figure(9), mesh(f1, f2, H_h3_rotate);
figure(10), imshow(H_h3_rotate, [ ]);


% clear all;
% close all;
% N = 100;
% [f1, f2] = freqspace(N, 'meshgrid');
% Hd = ones(N);
% k = 10;
% Hd((k * f1 + f2 <= -1/2) | (k * f1 + f2 >= 1/2)| (-k * f1 + f2 <= -1/2) | (-k * f1 + f2 >= 1/2)) = 0;
% figure(1), mesh(f1, f2, Hd)
% 
% h3 = fwind1(Hd, hanning(N));
% change_I = -ones(N, N);
% x = [1:N]; x = repmat(x, [N, 1]);
% y = [1:N]'; y = repmat(y, [1, N]);
% change_I = change_I .^(x + y);
% h3 = h3 .* change_I;
% figure(2), freqz2(h3);
% 
% [H, f1, f2] = freqz2(h3);
% H=20*log10(abs(H));
% figure(3), mesh(f1, f2, H);
% 
% w1 = f1 * 2 * pi;
% w2 = f2 * 2 * pi;
% w1 = w1 / pi;
% w2 = w2 / pi;
% figure(4), mesh(w1, w2, H);
% axis([-pi pi -pi pi -120 0])
% 
% H_PPFFT = PPFFT(h3, 1, 1);
% 
% i = 102; % i = 0, 1, 2....2 * N - 1
% a = zeros(2 * N - i, i); b = eye(2 * N - i); c = eye(i); d = zeros(i, 2 * N - i);
% Q = [a, b;c, d];
% 
% H_rotate_H_PPFFT = H_PPFFT * Q;
% h_IFFPPT = IPPFFT(H_rotate_H_PPFFT);
% 
% figure(6), freqz2(h_IFFPPT);
% % 
% % 
% % % f = H;
% % % a=f(1,:);c=f(m,:);             
% % % %������ֵͼ�����ǰ�����չ��������,����չ�������� 
% % % b=[f(1,1),f(1,1),f(:,1)',f(m,1),f(m,1)];
% % % d=[f(1,n),f(1,n),f(:,n)',f(m,n),f(m,n)]; 
% % % a1=[a;a;f;c;c]; 
% % % b1=[b;b;a1';d;d]; 
% % % ffff=b1';
% % % f1=double(ffff); 
% % % g1 = zeros(k*m,k*n);  
% % % for i=1:k*m                 
% % %     %����˫���β�ֵ��ʽ����ͼ���������ظ�ֵ    
% % %     u=rem(i,k)/k; i1=floor(i/k)+2;     
% % %     A=[sw(1+u) sw(u) sw(1-u) sw(2-u)];      
% % %     for j=1:k*n       
% % %         v=rem(j,k)/k;j1=floor(j/k)+2;      
% % %         C=[sw(1+v);sw(v);sw(1-v);sw(2-v)];       
% % %         B=[f1(i1-1,j1-1) f1(i1-1,j1) f1(i1-1,j1+1) f1(i1-1,j1+2)        
% % %             f1(i1,j1-1)   f1(i1,j1)   f1(i1,j1+1)   f1(i1,j1+2)        
% % %             f1(i1+1,j1-1)   f1(i1+1,j1) f1(i1+1,j1+1) f1(i1+1,j1+2)        
% % %             f1(i1+2,j1-1) f1(i1+2,j1) f1(i1+2,j1+1) f1(i1+2,j1+2)];      
% % %         g1(i,j)=(A*B*C);    
% % %     end
% % % end
% % % g=uint8(g1);  
% % % imshow(uint8(f)); title('��С��ͼ��');             %��ʾ��С��ͼ�� 
% % % figure,imshow(ff);title('ԭͼ');               %��ʾԭͼ��  
% % % figure,imshow(g);title('˫���β�ֵ�Ŵ��ͼ��');     %��ʾ��ֵ���ͼ��
% 
% X = h3;
% tic; Y1=Polar_Transform_New(X,1,1,4,1); toc;
% tic; Y2=Polar_Transform_New(X,1,2,4,1); toc;
% tic; Y3=Polar_Transform_New(X,2,1,4,1); toc;
% tic; Y4=Polar_Transform_New(X,2,2,4,1); toc;
% 
% % % N=100; X=randn(N,N); 
% % % tic; Y=PFFT(X,5,5); toc;