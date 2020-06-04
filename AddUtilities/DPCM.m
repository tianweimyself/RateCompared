function [ psnr_DPCM, rate_DPCM ] = DPCM( filename, current_image, num_levels, block_size, algorithm )
%DPCM 此处显示有关此函数的摘要
%   此处显示详细说明

[num_rows, num_cols] = size(current_image);
x = current_image;
 
projection_matrix_file = ['projections.' num2str(block_size) '.mat'];

% load bits and subrates used in the paper
type = 'dpcm'; %dpcm算法
filename_parameters_SQ = ['/Parameters/' filename '_' algorithm '_' ...
    type '_parameters.mat' ];
load(filename_parameters_SQ);

num_trials = length(subrates);
rate_DPCM = zeros(1, num_trials);
psnr_DPCM = zeros(1, num_trials);

coefs = [];

 for trial = 1:num_trials
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        y = BCS_SPL_Encoder(x, Phi);
        
        % DPCM + uniform scalar quantization 在量化上做改善
        [y_DPCM, rate_DPCM(trial), coef] = ...
            DPCM_Coding(y, quantizer_bitdepth, num_rows, num_cols,trial);
        
        if trial == 2 | trial == 5 | trial == 9 | trial == 14 | trial == 20
            coefs = [coefs, coef];
        end
        
        % reconstruction
        disp('Decoding DPCM...');
        tic
        x_hat_DPCM = BCS_SPL_DDWT_Decoder(y_DPCM, Phi, num_rows, num_cols, ...
            num_levels);
        toc
        DPCM_Name = strcat(filename,'_SPL_DPCM_Rate_',num2str(rate_DPCM(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(current_image, x_hat_DPCM)),'dB.tif');
        imwrite(uint8(x_hat_DPCM),strcat('Results\',DPCM_Name));
        
        psnr_DPCM(trial) = PSNR(current_image, x_hat_DPCM);
        disp(['Rate = ' num2str(rate_DPCM(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_DPCM(trial), '%0.2f') ' (dB)']);
 end
  
 save([filename '_' algorithm '_' type '_results.mat'], ...
        'rate_DPCM', 'psnr_DPCM');
    
    save([filename 'dpcm_index.mat'], ...
        'coefs');

end

