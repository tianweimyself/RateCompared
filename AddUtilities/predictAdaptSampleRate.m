function [ output_args ] = predictAdaptSampleRate( current_image, Phi_basic, K )
%PREDICTADAPTSAMPLERATE 此处显示有关此函数的摘要
%   此处显示详细说明
[M N] = size(Phi_basic);

block_size = sqrt(N);

[num_rows, num_cols] = size(current_image);

x = im2col(current_image, [block_size block_size], 'distinct'); %将图像块按照列排列

for j = 0 : K : size(x, 2) %每隔K个数，把这个i* K块放入交叉子集
    
end

end

