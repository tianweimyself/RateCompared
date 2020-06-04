function [ psnr_MFPQ, rate_MFPQ ] = MFPQ( filename, current_image, num_levels, block_size, algorithm )
%SQ 此处显示有关此函数的摘要
%   此处显示详细说明
[num_rows, num_cols] = size(current_image);
x = current_image;
 
projection_matrix_file = ['projections.' num2str(block_size) '.mat'];

type = 'dpcm';
filename_parameters_SQ = ['/Parameters/' filename '_' algorithm '_' ...
    type '_parameters.mat' ];
load(filename_parameters_SQ);

num_trials = length(subrates);

rate_MFPQ = zeros(1, num_trials);
psnr_MFPQ = zeros(1, num_trials);
coefs = [];

for trial = 1:num_trials
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        y = BCS_SPL_Encoder(x, Phi);
        
        % SDPC + uniform scalar quantization 该论文的improve为观测数据的量化，提高率失真表现
        [y_MFPQ, rate_MFPQ(trial),coef] = ...
            MFPQ_Coding(y, quantizer_bitdepth, num_rows, num_cols,Phi,trial);
        
        if trial == 2 | trial == 5 | trial == 9 | trial == 14 | trial == 20
            coefs = [coefs, coef];
        end
        
        % reconstruction
        disp('Decoding MFPQ...');
        tic
        x_hat_MFPQ = BCS_SPL_DDWT_Decoder(y_MFPQ, Phi, num_rows, num_cols, ...
            num_levels);
        toc
        
        MFPQ_Name = strcat(filename,'_SPL_MFPQ_Rate_',num2str(rate_MFPQ(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(current_image, x_hat_MFPQ)),'dB.tif');
        imwrite(uint8(x_hat_MFPQ),strcat('Results\',MFPQ_Name));
        
        psnr_MFPQ(trial) = PSNR(current_image, x_hat_MFPQ);
        disp(['Rate = ' num2str(rate_MFPQ(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_MFPQ(trial), '%0.2f') ' (dB)']);
        
end
 
save([filename '_' algorithm '_MFPQ_results.mat'], ...
        'rate_MFPQ', 'psnr_MFPQ');
    
    save([filename 'mfpq_index.mat'], ...
        'coefs');

end

