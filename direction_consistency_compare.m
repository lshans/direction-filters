function [various_block_cnt, flag] = direction_consistency_compare(EMax, wedge_shape_index, pimer_direction_index_gauss, various_block_cnt)
load('E:\项目\lss_graduate_project\angle_10_diff_direction_matching.mat');
load('E:\项目\lss_graduate_project\angle_20_diff_direction_matching.mat');
load('E:\项目\lss_graduate_project\angle_30_diff_direction_matching.mat');
load('E:\项目\lss_graduate_project\angle_40_diff_direction_matching.mat');
load('E:\项目\lss_graduate_project\angle_samely_direction_matching.mat');
% direction_matching = [[10	28	9	11	27	29	8	12	26	30]
%                         [11	29	10	12	28	30	9	13	27	31]
%                         [12	30	11	13	29	31	10	14	28	32]
%                         [13	31	12	14	30	32	11	15	29	33]
%                         [14	32	13	15	31	33	12	16	30	34]
%                         [15	33	14	16	32	34	13	17	31	35]
%                         [16	34	15	17	33	35	14	18	32	36]
%                         [17	35	16	18	34	36	15	19	33	1]
%                         [18	36	17	19	35	1	16	20	34	2]
%                         [19	1	18	20	36	2	17	21	35	3]
%                         [20	2	19	21	1	3	18	22	36	4]
%                         [21	3	20	22	2	4	19	23	1	5]
%                         [22	4	21	23	3	5	20	24	2	6]
%                         [23	5	22	24	4	6	21	25	3	7]
%                         [24	6	23	25	5	7	22	26	4	8]
%                         [25	7	24	26	6	8	23	27	5	9]
%                         [26	8	25	27	7	9	24	28	6	10]
%                         [27	9	26	28	8	10	25	29	7	11]]; 
flag = true;
    if  ((EMax < 10) && (pimer_direction_index_gauss == -1)) 
        various_block_cnt.same_direction_block_cnt = various_block_cnt.same_direction_block_cnt + 1;
    elseif(-1 == pimer_direction_index_gauss)
            various_block_cnt.smoothing_block_cnt = various_block_cnt.smoothing_block_cnt + 1;
    elseif(~all(samely_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
        various_block_cnt.same_direction_block_cnt = various_block_cnt.same_direction_block_cnt + 1;
    elseif(~all(angle_10_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
        various_block_cnt.nearly_direction_block_cnt = various_block_cnt.nearly_direction_block_cnt + 1;
    elseif(~all(angle_20_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
        various_block_cnt.different_two_direction_cnt = various_block_cnt.different_two_direction_cnt + 1;
    elseif(~all(angle_30_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
        various_block_cnt.different_three_direction_cnt = various_block_cnt.different_three_direction_cnt + 1;
    elseif(~all(angle_40_diff_direction_matching(wedge_shape_index,:) - pimer_direction_index_gauss))
        various_block_cnt.different_four_direction_cnt = various_block_cnt.different_four_direction_cnt + 1;
    else
        various_block_cnt.unsame_direction_block_cnt = various_block_cnt.unsame_direction_block_cnt + 1;
        flag = false;
    end
end
