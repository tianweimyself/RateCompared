function [ psnr_SQ, rate_SQ ] = SQ( filename, current_image, num_levels, block_size, algorithm )
%SQ 此处显示有关此函数的摘要
%   此处显示详细说明
%该函数输出psnr_sq--> SQ标量量化算法得到的psnr, rate_sq-- SQ标量量化算法得到的psnr
%可以绘制rate-distortion图

[num_rows, num_cols] = size(current_image);
 x = current_image;
 
 projection_matrix_file = ['projections.' num2str(block_size) '.mat'];

 type = 'sq'; %sq标量量化

 filename_parameters_SQ = ['/Parameters/' filename '_' algorithm '_' ...
        type '_parameters.mat' ];
 load(filename_parameters_SQ); 
 
 num_trials = 2; %实验次数
    
 rate_SQ = zeros(1, num_trials);
 psnr_SQ = zeros(1, num_trials);
 
 for trial = 1:num_trials
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection 得到观测矩阵M * N 
        %N = block_size * block_size， M = round(subrate * N)
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        
        y = BCS_SPL_Encoder(x, Phi);%返回观测数据 M * n n为子块的个数
        
        % uniform scalar quantization 
        [y_SQ, rate_SQ(trial)] = SQ_Coding(y, quantizer_bitdepth, num_rows, num_cols);
        
        % reconstruction
        disp('Decoding SQ...');
        tic
        x_hat_SQ = BCS_SPL_DDWT_Decoder(y_SQ, Phi, num_rows, num_cols, num_levels);
        toc
        SQ_Name = strcat(filename,'_SPL_SQ_Rate_',num2str(rate_SQ(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(current_image, x_hat_SQ)),'dB.tif');
        imwrite(uint8(x_hat_SQ),strcat('Results\',SQ_Name));
        
        psnr_SQ(trial) = PSNR(current_image, x_hat_SQ);
        disp(['Rate = ' num2str(rate_SQ(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_SQ(trial), '%0.2f') ' (dB)']);
 end
  
 save([filename '_' algorithm '_' type '_results.mat'], ...
        'rate_SQ', 'psnr_SQ');
end

