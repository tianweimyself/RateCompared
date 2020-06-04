function [ index_arr ] = satisfy( index, num_col )
%SATISFY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%ÿ�õ�һ��index,�ҵ����ʵĵ�ǰλ����Χ�˸����index
index_arr = [];

if(mod(index, num_col) == 0)
    first = (fix(index / num_col) - 1) * num_col + 1;
    last = fix(index / num_col) * num_col;
    arr = first : last;

    if(ismember(index - 1,arr))
        index_arr = [index_arr, index - 1];
    end

    if(ismember(index - 2,arr))
        index_arr = [index_arr, index - 2];
    end

    cur_left = index - num_col;
    if(cur_left > 0)
        arr = arr - num_col;
        if(ismember(cur_left,arr))
            index_arr = [index_arr, cur_left];
        end

        if(ismember(cur_left - 1,arr))
            index_arr = [index_arr, cur_left - 1];
        end

        if(ismember(cur_left - 2,arr))
            index_arr = [index_arr, cur_left - 2];
        end

        if(ismember(cur_left + 1,arr))
            index_arr = [index_arr, cur_left + 1];
        end

        if(cur_left - num_col > 0)
            arr = arr - num_col;
            if(ismember(cur_left - num_col,arr))
                index_arr = [index_arr, cur_left - num_col];
            end

            if(ismember(cur_left - num_col - 1,arr))
                index_arr = [index_arr, cur_left - num_col - 1];
            end
        end
    end
    
else
    first = fix(index / num_col) * num_col + 1;
    last = (fix(index / num_col) + 1) * num_col;
    arr = first : last;

    if(ismember(index - 1,arr))
        index_arr = [index_arr, index - 1];
    end

    if(ismember(index - 2,arr))
        index_arr = [index_arr, index - 2];
    end

    cur_left = index - num_col;
    if(cur_left > 0)
        arr = arr - num_col;
        if(ismember(cur_left,arr))
            index_arr = [index_arr, cur_left];
        end

        if(ismember(cur_left - 1,arr))
            index_arr = [index_arr, cur_left - 1];
        end

        if(ismember(cur_left - 2,arr))
            index_arr = [index_arr, cur_left - 2];
        end

        if(ismember(cur_left + 1,arr))
            index_arr = [index_arr, cur_left + 1];
        end

        if(cur_left - num_col > 0)
            arr = arr - num_col;
            if(ismember(cur_left - num_col,arr))
                index_arr = [index_arr, cur_left - num_col];
            end

            if(ismember(cur_left - num_col - 1,arr))
                index_arr = [index_arr, cur_left - num_col - 1];
            end
        end
    end
end


end

