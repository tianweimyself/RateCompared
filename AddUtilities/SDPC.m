function [ psnr_SDPC, rate_SDPC ] = SDPC( filename, current_image, num_levels, block_size, algorithm )
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

rate_SDPC = zeros(1, num_trials);
psnr_SDPC = zeros(1, num_trials);

coefs = [];

for trial = 1:num_trials
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        y = BCS_SPL_Encoder(x, Phi);
        
        % SDPC + uniform scalar quantization 该论文的improve为观测数据的量化，提高率失真表现
        [y_SDPC, rate_SDPC(trial),coef] = ...
            SDPC_Coding(y, quantizer_bitdepth, num_rows, num_cols,Phi,trial);
        
        if trial == 2 || trial == 5 | trial == 9 | trial == 14 | trial == 20
            coefs = [coefs, coef];
        end
        
        % reconstruction
        disp('Decoding SDPC...');
        tic
        x_hat_SDPC = BCS_SPL_DDWT_Decoder(y_SDPC, Phi, num_rows, num_cols, ...
            num_levels);
        toc
        
        SDPC_Name = strcat(filename,'_SPL_SDPC_Rate_',num2str(rate_SDPC(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(current_image, x_hat_SDPC)),'dB.tif');
        imwrite(uint8(x_hat_SDPC),strcat('Results\',SDPC_Name));
        
        psnr_SDPC(trial) = PSNR(current_image, x_hat_SDPC);
        disp(['Rate = ' num2str(rate_SDPC(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_SDPC(trial), '%0.2f') ' (dB)']);
        
end
 
save([filename '_' algorithm '_SDPC_results.mat'], ...
        'rate_SDPC', 'psnr_SDPC');
    
    save([filename 'sdpc_index.mat'], ...
        'coefs');

end

