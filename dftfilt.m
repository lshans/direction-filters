function g = dftfilt(f, H)
N = 512;
gap = 10;
F = fft2(f, size(H, 1), size(H, 2));
F_filter = H.*F;
mesh(F_filter(1:gap:N, 1:gap:N)); title('filtered picture');
g = ifft(H.*F);
g = g(1 : size(f, 1), 1 : size(f, 2));
