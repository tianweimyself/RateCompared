function [ i, y_q, y_index, coef ] = SPL_adapt_Encode( meaumentOfremain,q,DC_Measure,remainIndex, block_size, num_rows )
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
i = zeros(size(meaumentOfremain));
n=num_rows / block_size; %�ò���˵��ÿ���ж��ٸ���
y_q = zeros(size(meaumentOfremain));
y_ql = zeros(size(meaumentOfremain, 1), n * n);

y_hat = DC_Measure;

y_index  = zeros(size(meaumentOfremain,2),1);%��־λ
L_norm = 1; % 1 or 2
% count_l = 0; % left   index = 0
% count_u = 0; % up     index = -1
% count_ul = 0;% upleft index = 2
% count_d = 0; % dc     index = 1
coef = zeros(size(meaumentOfremain,2),1);

for j = 1:size(meaumentOfremain,2)
    t=remainIndex(1:j);  %�������ʵ��¼j��Ӧԭͼ���index
    bias = [t-1,t-1+n,t+n,t+n+1,t+1,t+1-n,t-n,t-n-1];
    cnt  = length(bias);
    if j == 1
        d = meaumentOfremain(:,j) - y_hat;
        coef(j) = dot(meaumentOfremain(:,j),y_hat)/(norm(meaumentOfremain(:,j),2)*norm(y_hat,2)+eps);%norm(A,p)��������A��p����
        i(:,j) = round(d/q);
        d_hat = i(:,j)*q;
        y_q(:,j) = y_hat + d_hat;
        y_ql(:,remainIndex(j)) = y_hat + d_hat;
        y_index(j) = 0;
        
    else 
        CS = [DC_Measure];%����Ϊ��
        for k = 1:cnt 
            if bias(k)>0 && ismember(bias(k), remainIndex)
                if norm(y_ql(:,bias(k)),2)~=0 %����ж�����˵���Ѿ���Ԥ���ˣ��ҿ�����Ϊ��ѡ������һ��
                    CS = [CS,y_ql(:,bias(k))];%����һֱ������;
                end
            end
        end
        
    value=zeros(1,size(CS,2));
    for v=1:size(CS,2)
        value(v)=norm(meaumentOfremain(:,j)-CS(:,v),L_norm);
    end
    [~, min_index] = min(value);
    y_hat=CS(:,min_index);


    d = meaumentOfremain(:,j) - y_hat;
    coef(j) = dot(meaumentOfremain(:,j),y_hat)/(norm(meaumentOfremain(:,j),2)*norm(y_hat,2)+eps);%norm(A,p)��������A��p����
    i(:,j) = round(d/q);
    d_hat = i(:,j)*q;
    y_q(:,j) = y_hat + d_hat;
    y_ql(:,remainIndex(j)) = y_hat + d_hat;
    
end


end

