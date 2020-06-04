function [ index_arr, index_label ] = satisfyRand( cur, predict_arr, num_col )
%SATISFY 此处显示有关此函数的摘要
%   此处显示详细说明
%每拿到一个随机index,找到合适的当前位的周围16个块的index
%                 1                   2
%        3        4        5          6       7         
%                 8        cur        9
%        10       11       12         13      14
%                 15                  16
index_arr = [];
index_label = [];

predict_block = [cur-num_col-2, cur+num_col-2, cur-2*num_col-1, cur-num_col-1,...
                 cur-1, cur+num_col-1, cur+2*num_col-1, cur-num_col,...
                 cur+num_col, cur-2*num_col+1, cur-num_col+1, cur+1,...
                 cur+num_col+1, cur+2*num_col+1, cur-num_col+2, cur+num_col+2
                ];
%确定 predict_block 的哪些元素同时也在 predict_arr 中。

Lia = ismember(predict_block,predict_arr);

for j = 1 : size(Lia, 2)
    if(Lia(j))
        index_arr = [index_arr, predict_block(j)];
        index_label = [index_label, j];
    end
end

end