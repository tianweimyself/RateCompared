function [i y_q,coef]= MFPQ_Encode(y,q,DC_Measure)


M     = size(y,1);
len   = size(y,2);
i     = zeros(M,len);
y_q   = zeros(M,len);
y_hat=DC_Measure;

coef  = zeros(len,1);
%
blk_rows=32;
bias = [blk_rows+1,blk_rows,blk_rows-1,1];
cnt  = length(bias);
for j = 1:len
    if j == 1
        d = y(:,j) - y_hat;% y(:,j)，这是取第j列的意思
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%dot()为内积函数;norm(y(:,j),2),返回向量y(:,j)的2范数
        i(:,j) = round(d/q);%四舍五入函数
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;
    elseif ceil(j/blk_rows) == 1
        CS=[y_q(:,1),y_q(:,j-1),(y_q(:,1)+y_q(:,j-1))/2];
        %y_hat = mean(CS,2);%也许这里面取平均值更好
         y_hat = median(CS,2);
        d = y(:,j) - y_hat;
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%返回的是这个;
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;%y_q的作用是在不断补充y_q   = zeros(M,len)
        
    elseif mod(j,blk_rows) == 1
        CS=[y_q(:,j-blk_rows),y_q(:,j-blk_rows+1),y_q(:,j-1)];
        %y_hat = mean(CS,2);%也许这里面取平均值更好
         y_hat = median(CS,2);
        d = y(:,j) - y_hat;
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%返回的是这个;
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;%y_q的作用是在不断补充y_q   = zeros(M,len)
    else
        CS = [];%矩阵为空
        for k = 1:cnt %1:4
            idx = j-bias(k);
            if (idx>0)&&(idx<=len)
               CS = [CS,y_q(:,idx)];%矩阵一直在扩充;最多大概有4列，(idx>0)&&(idx<=len)好像限制了某些条件
            end
        end
        %y_hat = max(CS,[],2);
      y_hat = median(CS,2);%median(M,dim)，2表示按每行返回一个值,为该行从大到小排列的中间值.
      %y_hat = mean(CS,2);%也许这里面取平均值更好
        d = y(:,j) - y_hat;
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%返回的是这个;
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;%y_q的作用是在不断补充y_q   = zeros(M,len)
    end
end
    
end


