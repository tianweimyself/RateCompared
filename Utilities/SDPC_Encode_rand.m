function [i, y_q, y_index, coef]= SDPC_Encode_rand(y,q,DC_Measure, num_rows,block_size)

i = zeros(size(y));
y_q = zeros(size(y));
num_col = num_rows / block_size; %ÿ���ж��ٿ顣
rand_arr = randperm(num_col * num_col); %�ӿ����ȡindex
predict_arr = [];
y_index  = zeros(size(y,2),1);%��־λ
L_norm = 1; % 1 or 2
coef = zeros(size(y,2),1);

for j = 1 : size(y, 2)
    [index_arr, index_label] = satisfyRand(rand_arr(j), predict_arr, num_col);%����ÿ����ǰ�飬������8���۲��ɹ�ѡ��ȥԤ�⣬satisfy�ҵ����Ӧ������8�����index
    predict_arr = [predict_arr, rand_arr(j)]; %��Ԥ����ӿ�
    min_index = 0;
    y_index(rand_arr(j)) = 0;
    min_value = norm(y(:,rand_arr(j))-DC_Measure,L_norm);
    
    for k = 1 : size(index_arr, 2)
        norm_val = norm(y(:,rand_arr(j))-y(:, index_arr(k)),L_norm);
        if(norm_val < min_value)
            min_value = norm_val;
            min_index = index_arr(k);
            y_index(rand_arr(j)) = index_label(k);
        end
    end
    
    if(min_index == 0)
        y_hat = DC_Measure;
    else
        y_hat = y(:, min_index);
    end
    
    coef(j) = dot(y(:,rand_arr(j)),y_hat)/(norm(y(:,rand_arr(j)),2)*norm(y_hat,2)+eps);
    d = y(:,rand_arr(j)) - y_hat;
    i(:,rand_arr(j)) = round(d/q);
    d_hat = i(:,rand_arr(j))*q;
    y_q(:,rand_arr(j)) = y_hat + d_hat;
end



