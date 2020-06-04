function [ Phi_basic ] = GenerateRandomProjection( block_size, s_q )
%GENERATEBASICPROJECTION �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
basic_phi_filename = 'basicPhi';
N = block_size * block_size;
M = round(s_q * N);

 if exist(basic_phi_filename, 'file') %�Ƿ��������ļ�
     load(basic_phi_filename);
 else
     Phi = orth(randn(N, N))'; 
     save(basic_phi_filename, 'Phi');
 end
 
 Phi_basic = Phi(1:M, :);
end

