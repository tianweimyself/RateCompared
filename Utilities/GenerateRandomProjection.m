function [ Phi_basic ] = GenerateRandomProjection( block_size, s_q )
%GENERATEBASICPROJECTION 此处显示有关此函数的摘要
%   此处显示详细说明
basic_phi_filename = 'basicPhi';
N = block_size * block_size;
M = round(s_q * N);

 if exist(basic_phi_filename, 'file') %是否存在这个文件
     load(basic_phi_filename);
 else
     Phi = orth(randn(N, N))'; 
     save(basic_phi_filename, 'Phi');
 end
 
 Phi_basic = Phi(1:M, :);
end

