function [i, y_q, y_index, coef]= SDPC_Encode_ch16(y,q,DC_Measure, num_rows,block_size)

i = zeros(size(y));
y_q = zeros(size(y));
num_col = num_rows / block_size; %每列有多少块。

y_index  = zeros(size(y,2),1);%标志位
L_norm = 1; % 1 or 2
coef = zeros(size(y,2),1);

for j = 1 : size(y, 2)
    [index_arr, index_label] = satisfy16(j, num_col);%对于每个当前块，至多有16个观测块可供选择去预测，satisfy找到相对应的至多16个块的index
    min_index = 0;
    y_index(j) = 0;
    min_value = norm(y(:,j)-DC_Measure,L_norm);
    
    for k = 1 : size(index_arr, 2)
        norm_val = norm(y(:,j)-y_q(:, index_arr(k)),L_norm);
        if(norm_val < min_value)
            min_value = norm_val;
            min_index = index_arr(k);
            y_index(j) = index_label(k);
        end
    end
    
    if(min_index == 0)
        y_hat = DC_Measure;
    else
        y_hat = y_q(:, min_index); %选中可以被当前块的替代块，因为有diff存在，所以当前块是可以被还原的
    end
    
    coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);
    d = y(:,j) - y_hat;
    i(:,j) = round(d/q);
    d_hat = i(:,j)*q;
    y_q(:,j) = y_hat + d_hat;
end



