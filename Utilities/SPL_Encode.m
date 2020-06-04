function [ i, y_ql, y_index, coef ] = SPL_Encode( y,q,DC_Measure )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
i = zeros(size(y));
[ y_l, indexOfNum]=changed(y);
 n=sqrt(size(y_l,2));%列进行分解n*n
y_q = zeros(size(y));
y_ql = zeros(size(y));

y_hat = DC_Measure;

y_index  = zeros(size(y,2),1);%标志位
L_norm = 1; % 1 or 2
% count_l = 0; % left   index = 0
% count_u = 0; % up     index = -1
% count_ul = 0;% upleft index = 2
% count_d = 0; % dc     index = 1
coef = zeros(size(y,2),1);

for j = 1:size(y,2)
    t=indexOfNum(j);
    bias = [t-1,t-1+n,t+n,t+n+1,t+1,t+1-n,t-n,t-n-1];
    cnt  = length(bias);
    if j == 1
        d = y_l(:,j) - y_hat;
        coef(j) = dot(y_l(:,j),y_hat)/(norm(y_l(:,j),2)*norm(y_hat,2)+eps);%norm(A,p)返回向量A的p范数
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;
        y_ql(:,indexOfNum(j)) = y_hat + d_hat;
        y_index(j) = 0;
        
    else 
        CS = [DC_Measure];%矩阵为空
        for k = 1:cnt 
            if bias(k)>0 && bias(k)<=size(y,2)
            if norm(y_ql(:,bias(k)),2)~=0
               CS = [CS,y_ql(:,bias(k))];%矩阵一直在扩充;
            end
            end
    end
        
        value=zeros(1,size(CS,2));
        for v=1:size(CS,2)
            value(v)=norm(y_l(:,j)-CS(:,v),L_norm);
        end
        [~, min_index] = min(value);
        y_hat=CS(:,min_index);

        
        d = y_l(:,j) - y_hat;
        coef(j) = dot(y_l(:,j),y_hat)/(norm(y_l(:,j),2)*norm(y_hat,2)+eps);%norm(A,p)返回向量A的p范数
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;
        y_ql(:,indexOfNum(j)) = y_hat + d_hat;
    
end


end

