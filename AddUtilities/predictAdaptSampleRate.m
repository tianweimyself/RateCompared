function [ output_args ] = predictAdaptSampleRate( current_image, Phi_basic, K )
%PREDICTADAPTSAMPLERATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[M N] = size(Phi_basic);

block_size = sqrt(N);

[num_rows, num_cols] = size(current_image);

x = im2col(current_image, [block_size block_size], 'distinct'); %��ͼ��鰴��������

for j = 0 : K : size(x, 2) %ÿ��K�����������i* K����뽻���Ӽ�
    
end

end

