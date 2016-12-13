function [various_block_cnt_arr, flag] = direction_consistency_compare(EMax, wedge_shape_index, pimer_direction_index_gauss, various_block_cnt_arr)
% 比较楔形滤波器计算出的块方向和sobel方法计算的块方向进行一致性比较，EMax 是楔形滤波器滤波得到的频谱能量，wedge_shape_index 是楔形滤波器滤波得到的主方向
% pimer_direction_index_gauss 是sobel方法得到的主方向，various_block_cnt_arr 统计楔形滤波器和sobel两种方法得到的主方向相差各个角度的图像块数目，0~90度之内分别记录在第1到10行，最后一行记录平滑块的个数
% flag 对两种方法得到的方向相差超过40度的块进行标记
    direction_gap = abs((mod(pimer_direction_index_gauss, 19) + 1) - wedge_shape_index);
    flag = true;
    if  ((EMax < 10) && (pimer_direction_index_gauss == -1))
        various_block_cnt_arr(1, 1) = various_block_cnt_arr(1, 1) + 1;
    elseif(-1 == pimer_direction_index_gauss)
        various_block_cnt_arr(11, 1) = various_block_cnt_arr(11,1) + 1;
    elseif direction_gap <= 9
        various_block_cnt_arr(direction_gap + 1, 1) = various_block_cnt_arr(direction_gap + 1, 1) + 1;
        if direction_gap > 4
            flag = false;
        end
    else
        various_block_cnt_arr(18 - direction_gap + 1, 1) = various_block_cnt_arr(18 - direction_gap + 1, 1) + 1;
        if 18 - direction_gap > 4
            flag = false;
        end
    end
end
% load('.\angle_10_diff_direction_matching.mat'); 
% load('.\angle_20_diff_direction_matching.mat'); 
% load('.\angle_30_diff_direction_matching.mat'); 
% load('.\angle_40_diff_direction_matching.mat'); 
% load('.\angle_samely_direction_matching.mat');  

%     flag = true;
%     if  ((EMax < 10) && (pimer_direction_index_gauss == -1)) 
%         various_block_cnt.same_direction_block_cnt = various_block_cnt.same_direction_block_cnt + 1;
%     elseif(-1 == pimer_direction_index_gauss)
%             various_block_cnt.smoothing_block_cnt = various_block_cnt.smoothing_block_cnt + 1;
%     elseif(~all(samely_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
%         various_block_cnt.same_direction_block_cnt = various_block_cnt.same_direction_block_cnt + 1;
%     elseif(~all(angle_10_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
%         various_block_cnt.nearly_direction_block_cnt = various_block_cnt.nearly_direction_block_cnt + 1;
%     elseif(~all(angle_20_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
%         various_block_cnt.different_two_direction_cnt = various_block_cnt.different_two_direction_cnt + 1;
%     elseif(~all(angle_30_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
%         various_block_cnt.different_three_direction_cnt = various_block_cnt.different_three_direction_cnt + 1;
%     elseif(~all(angle_40_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
%         various_block_cnt.different_four_direction_cnt = various_block_cnt.different_four_direction_cnt + 1;
%     else
%         various_block_cnt.unsame_direction_block_cnt = various_block_cnt.unsame_direction_block_cnt + 1;
%         flag = false;
%     end
% end
