function [ psnr_spl_adapt, rate_spl_adapt, coef ] = SPL_adapt( filename, current_image, num_levels, block_size, algorithm )
%SPL 此处显示有关此函数的摘要
%   此处显示详细说明

[num_rows, num_cols] = size(current_image);
x = current_image;
 
% projection_matrix_file = ['projections.' num2str(block_size) '.mat'];

type = 'dpcm';
filename_parameters_SQ = ['/Parameters/' filename '_' algorithm '_' ...
    type '_parameters.mat' ];
load(filename_parameters_SQ);

num_trials = length(subrates);

rate_spl_adapt = zeros(1, num_trials);
psnr_spl_adapt = zeros(1, num_trials);
s_q = 0.1; %对交叉子集块的测量率
K = 8; %定义每隔8个块，把这个块放入交叉子集

for trial = 1:num_trials
    quantizer_bitdepth = bits(trial);  %量化深度
    subrate = subrates(trial);         %采样率
    
    % 获得初始random projection
    Phi_basic = GenerateBasicProjection(block_size, s_q);
    %通过交叉子集分别求出外区，中区，内区的观测率
    [] = predictAdaptSampleRate(x, Phi_basic, K);
    y = BCS_SPL_Encoder(x, Phi);

    [y_SPL, rate_spl_adapt(trial), coef] = SPL_Coding(y, quantizer_bitdepth, num_rows, num_cols,Phi);

    % reconstruction
    disp('Decoding SPL...');
    tic
    rec_SPL = BCS_SPL_DDWT_Decoder(y_SPL, Phi, num_rows, num_cols, ...
        num_levels);
    toc

    psnr_spl(trial) = PSNR(original_image, rec_SPL);
    SPL_Name = strcat(filename,'_Rate_',num2str(rate_spl_adapt(trial)),'_QP_',num2str(quantizer_bitdepth),...
        '_subrate_',num2str(subrate),'_PSNR_',num2str(psnr_spl(trial)),'dB.tif');
    imwrite(uint8(rec_SPL),strcat('./result/SPL/', SPL_Name));
    
    disp(['Rate = ' num2str(rate_spl_adapt(trial), '%0.4f') ...
        ' (bpp), PSNR = ' num2str(psnr_spl(trial), '%0.2f') ' (dB)']);
end
end

