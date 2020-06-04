function [ index_arr, index_label ] = satisfy16( index, num_col )
%SATISFY 此处显示有关此函数的摘要
%   此处显示详细说明
%每拿到一个index,找到合适的当前位的周围十六个块的index
% 0 =》 DC块
                
%                 left-2-2(10)   left_2(5)     up_1(2)
%  left-3-1(14)   left-2-1(8)    left_1(4)     up(1)
%  left-3(13)     left-2(7)      left(3)       /cur/
%  left-3+1(15)   left-2+1(11)   left+1(6) 
%                 left-2+2(12)   left+1(9)
index_arr = [];
index_label = [];
if(mod(index, num_col) == 0)
    first = (fix(index / num_col) - 1) * num_col + 1;
    last = fix(index / num_col) * num_col;
    arr = first : last;

    if(ismember(index - 1,arr))%是否up(1)存在
        index_arr = [index_arr, index - 1];
        index_label = [index_label, 1];
    end

    if(ismember(index - 2,arr))%是否up_1(2)存在
        index_arr = [index_arr, index - 2];
        index_label = [index_label, 2];
    end

    cur_left = index - num_col;
    if(cur_left > 0)
        arr = arr - num_col;
        if(ismember(cur_left,arr))%是否left(3)存在
            index_arr = [index_arr, cur_left];
            index_label = [index_label, 3];
        end

        if(ismember(cur_left - 1,arr))%是否left_1(4) 存在
            index_arr = [index_arr, cur_left - 1];
            index_label = [index_label, 4];
        end

        if(ismember(cur_left - 2,arr))%是否left_2(5)存在
            index_arr = [index_arr, cur_left - 2];
            index_label = [index_label, 5];
        end

        if(ismember(cur_left + 1,arr))%是否left+1(6)存在
            index_arr = [index_arr, cur_left + 1];
            index_label = [index_label, 6];
        end
        
        if(ismember(cur_left + 2,arr))%是否left+2(9)存在
            index_arr = [index_arr, cur_left + 2];
            index_label = [index_label, 9];
        end
        
        cur_left = cur_left - num_col;
        if(cur_left > 0)
            arr = arr - num_col;
            if(ismember(cur_left,arr))%是否left-2(7)存在
                index_arr = [index_arr, cur_left];
                index_label = [index_label, 7];
            end

            if(ismember(cur_left - 1,arr))%是否left-2-1(8)存在
                index_arr = [index_arr, cur_left  - 1];
                index_label = [index_label, 8];
            end
            
            if(ismember(cur_left - 2,arr))%是否left-2-2(10)存在
                index_arr = [index_arr, cur_left  - 2];
                index_label = [index_label, 10];
            end
            
            if(ismember(cur_left + 1,arr))%是否left-2+1(11)存在
                index_arr = [index_arr, cur_left  + 1];
                index_label = [index_label, 11];
            end
            
            if(ismember(cur_left + 2,arr))%是否left-2+2(12)存在
                index_arr = [index_arr, cur_left  + 2];
                index_label = [index_label, 12];
            end
            
            
            if(cur_left - num_col > 0)
                arr = arr - num_col;
                if(ismember(cur_left - num_col,arr))%是否left-3(13)存在
                    index_arr = [index_arr, cur_left - num_col];
                    index_label = [index_label, 13];
                end
                
                if(ismember(cur_left - num_col - 1,arr))%是否left-3-1(14)存在
                    index_arr = [index_arr, cur_left - num_col - 1];
                    index_label = [index_label, 14];
                end
            
                if(ismember(cur_left - num_col + 1,arr))%是否left-3+1(15)存在
                    index_arr = [index_arr, cur_left - num_col + 1];
                    index_label = [index_label, 15];
                end
            end
        end
    end
    
else
    first = fix(index / num_col) * num_col + 1;
    last = (fix(index / num_col) + 1) * num_col;
    arr = first : last;
    if(ismember(index - 1,arr))%是否up(1)存在
        index_arr = [index_arr, index - 1];
        index_label = [index_label, 1];
    end

    if(ismember(index - 2,arr))%是否up_1(2)存在
        index_arr = [index_arr, index - 2];
        index_label = [index_label, 2];
    end

    cur_left = index - num_col;
    if(cur_left > 0)
        arr = arr - num_col;
        if(ismember(cur_left,arr))%是否left(3)存在
            index_arr = [index_arr, cur_left];
            index_label = [index_label, 3];
        end

        if(ismember(cur_left - 1,arr))%是否left_1(4) 存在
            index_arr = [index_arr, cur_left - 1];
            index_label = [index_label, 4];
        end

        if(ismember(cur_left - 2,arr))%是否left_2(5)存在
            index_arr = [index_arr, cur_left - 2];
            index_label = [index_label, 5];
        end

        if(ismember(cur_left + 1,arr))%是否left+1(6)存在
            index_arr = [index_arr, cur_left + 1];
            index_label = [index_label, 6];
        end
        
        if(ismember(cur_left + 2,arr))%是否left+2(9)存在
            index_arr = [index_arr, cur_left + 2];
            index_label = [index_label, 9];
        end
        
        cur_left = cur_left - num_col;
        if(cur_left > 0)
            arr = arr - num_col;
            if(ismember(cur_left,arr))%是否left-2(7)存在
                index_arr = [index_arr, cur_left];
                index_label = [index_label, 7];
            end

            if(ismember(cur_left - 1,arr))%是否left-2-1(8)存在
                index_arr = [index_arr, cur_left  - 1];
                index_label = [index_label, 8];
            end
            
            if(ismember(cur_left - 2,arr))%是否left-2-2(10)存在
                index_arr = [index_arr, cur_left  - 2];
                index_label = [index_label, 10];
            end
            
            if(ismember(cur_left + 1,arr))%是否left-2+1(11)存在
                index_arr = [index_arr, cur_left  + 1];
                index_label = [index_label, 11];
            end
            
            if(ismember(cur_left + 2,arr))%是否left-2+2(12)存在
                index_arr = [index_arr, cur_left  + 2];
                index_label = [index_label, 12];
            end
            
            
            if(cur_left - num_col > 0)
                arr = arr - num_col;
                if(ismember(cur_left - num_col,arr))%是否left-3(13)存在
                    index_arr = [index_arr, cur_left - num_col];
                    index_label = [index_label, 13];
                end
                
                if(ismember(cur_left - num_col - 1,arr))%是否left-3-1(14)存在
                    index_arr = [index_arr, cur_left - num_col - 1];
                    index_label = [index_label, 14];
                end
            
                if(ismember(cur_left - num_col + 1,arr))%是否left-3+1(15)存在
                    index_arr = [index_arr, cur_left - num_col + 1];
                    index_label = [index_label, 15];
                end
            end
        end
    end
end
end


