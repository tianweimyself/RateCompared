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
        d = y(:,j) - y_hat;% y(:,j)������ȡ��j�е���˼
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%dot()Ϊ�ڻ�����;norm(y(:,j),2),��������y(:,j)��2����
        i(:,j) = round(d/q);%�������뺯��
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;
    elseif ceil(j/blk_rows) == 1
        CS=[y_q(:,1),y_q(:,j-1),(y_q(:,1)+y_q(:,j-1))/2];
        %y_hat = mean(CS,2);%Ҳ��������ȡƽ��ֵ����
         y_hat = median(CS,2);
        d = y(:,j) - y_hat;
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%���ص������;
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;%y_q���������ڲ��ϲ���y_q   = zeros(M,len)
        
    elseif mod(j,blk_rows) == 1
        CS=[y_q(:,j-blk_rows),y_q(:,j-blk_rows+1),y_q(:,j-1)];
        %y_hat = mean(CS,2);%Ҳ��������ȡƽ��ֵ����
         y_hat = median(CS,2);
        d = y(:,j) - y_hat;
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%���ص������;
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;%y_q���������ڲ��ϲ���y_q   = zeros(M,len)
    else
        CS = [];%����Ϊ��
        for k = 1:cnt %1:4
            idx = j-bias(k);
            if (idx>0)&&(idx<=len)
               CS = [CS,y_q(:,idx)];%����һֱ������;�������4�У�(idx>0)&&(idx<=len)����������ĳЩ����
            end
        end
        %y_hat = max(CS,[],2);
      y_hat = median(CS,2);%median(M,dim)��2��ʾ��ÿ�з���һ��ֵ,Ϊ���дӴ�С���е��м�ֵ.
      %y_hat = mean(CS,2);%Ҳ��������ȡƽ��ֵ����
        d = y(:,j) - y_hat;
        coef(j) = dot(y(:,j),y_hat)/(norm(y(:,j),2)*norm(y_hat,2)+eps);%���ص������;
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;%y_q���������ڲ��ϲ���y_q   = zeros(M,len)
    end
end
    
end


