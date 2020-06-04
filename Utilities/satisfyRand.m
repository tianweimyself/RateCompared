function [ index_arr, index_label ] = satisfyRand( cur, predict_arr, num_col )
%SATISFY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%ÿ�õ�һ�����index,�ҵ����ʵĵ�ǰλ����Χ16�����index
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
%ȷ�� predict_block ����ЩԪ��ͬʱҲ�� predict_arr �С�

Lia = ismember(predict_block,predict_arr);

for j = 1 : size(Lia, 2)
    if(Lia(j))
        index_arr = [index_arr, predict_block(j)];
        index_label = [index_label, j];
    end
end

end