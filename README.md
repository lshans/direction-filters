# direction-filters
1.Polar Fourier Transform, PolarLab, nfft is downloaded files about polarFFT and reverse polarFFT.
2.test_filter.m: design frequency domain symmetric parallellogram filter using 2-D lowpass filter. and wedge-shape filter(hasing wedge-shape support domain)
3.line_shift.m: create line-shift matrix.
4.column_shift.m: create column-shift matrix.
5.res: reserve intermediate graph.

1. figure(71), supplot(6, 6), show direction_filters
2. figure(72), input figure
    1. I (H * W)
    2. H (Gassian Filter)
    3. F (fft2(I))
    4. G (F_filtered)
    5. g (I_filtered)
    6. I_direction_filtered
3. figure(73), direction_filter filter block
    1. block_gaussian_I
    2. optimal_direction_filter
    3. block_F (M x N)
    4. hist of spectrum engergy
    5. block_filtered_I