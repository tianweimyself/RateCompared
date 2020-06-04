%   These MATLAB programs implement the Spatially Directional Predictive Coding 
%   for Block-based Compressive Sensing as described in paper:
%   
%     J. Zhang, D. Zhao, F. Jiang, "Spatially Directional Predictive Coding for 
%     Block-based Compressive Sensing of Natural Images" in IEEE International on 
%     Image Processing (ICIP2013), Melbourne, Australia, Sep. 2013.
% 
%   
%   Note that, since most of this code relies on random projections,
%   the results produced may differ slightly in appearance and
%   value from those of the paper.
% 
% -------------------------------------------------------------------------------------------------------
% The software implemented by MatLab 7.10.0(2010a) are included in this package.
%
% ------------------------------------------------------------------
% Requirements
% ------------------------------------------------------------------
% *) Matlab 7.10.0(2010a) or later with installed:
% ------------------------------------------------------------------
% Version 1.0
% Author: Jian Zhang
% Email:  jzhangcs@hit.edu.cn
% Last modified by J. Zhang, Aug. 2013

%   For updated versions of ALSB, as well as the article on which it is based, 
%   consult: http://idm.pku.edu.cn/staff/zhangjian/SDPC/

cur = cd; %cd 显示当前文件夹。
%p = genpath(folderName) 返回一个包含路径名称的字符向量，该路径名称中包含 folderName 以及 folderName 下的多级子文件夹。
%addpath 向搜索路径中添加文件夹
addpath(genpath(cur)); %该文件夹下所有子文件夹全都被添加到搜索路径了

for ImaNo = 1
    switch ImaNo
        case 1
            filename = 'lenna';
        case 2
            filename = 'peppers';
        case 3
            filename = 'clown';
    end
    
    %A = imread(filename) 从 filename 指定的文件读取图像，并从文件内容推断出其格式。
    %X 中的值转换为双精度。数值变量自动存储为 64 位（8 字节）双精度浮点值。
    original_image = double(imread([filename '.pgm']));
    %sz = size(A) 返回一个行向量，其元素是 A 的相应维度的长度。例如，如果 A 是一个 3×4 矩阵，则 size(A) 返回向量 [3 4]。
    [num_rows num_cols] = size(original_image);
    x = original_image;
    
    num_levels = 5;
    block_size = 16;
    projection_matrix_file = ['projections.' num2str(block_size) '.mat'];
    
    % load bits and subrates used in the paper
    algorithm = 'bcsspl'; %SPL重构方法
    type = 'sq'; %sq标量量化
    filename_parameters_SQ = ['./Parameters/' filename '_' algorithm '_' ...
        type '_parameters.mat' ];
    %load(filename) 从 filename 加载数据。如果 filename 是 MAT 文件，load(filename) 会将 MAT 文件中的变量加载到 MATLAB? 工作区。
    load(filename_parameters_SQ); 
    
    %num_trials = length(subrates);
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
        [y_SQ rate_SQ(trial)] = SQ_Coding(y, quantizer_bitdepth, num_rows, num_cols);
        
        % reconstruction
        disp('Decoding SQ...');
        tic
        x_hat_SQ = BCS_SPL_DDWT_Decoder(y_SQ, Phi, num_rows, num_cols, num_levels);
        toc
        SQ_Name = strcat(filename,'_SPL_SQ_Rate_',num2str(rate_SQ(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(original_image, x_hat_SQ)),'dB.tif');
        imwrite(uint8(x_hat_SQ),strcat('Results\',SQ_Name));
        
        psnr_SQ(trial) = PSNR(original_image, x_hat_SQ);
        disp(['Rate = ' num2str(rate_SQ(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_SQ(trial), '%0.2f') ' (dB)']);
    end
    
    % load bits and subrates used in the paper
    algorithm = 'bcsspl';
    type = 'dpcm'; %dpcm算法
    filename_parameters_SQ = ['./Parameters/' filename '_' algorithm '_' ...
        type '_parameters.mat' ];
    load(filename_parameters_SQ);
    
    num_trials = length(subrates);
    rate_DPCM = zeros(1, num_trials);
    psnr_DPCM = zeros(1, num_trials);
    
    for trial = 1:num_trials
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        y = BCS_SPL_Encoder(x, Phi);
        
        % DPCM + uniform scalar quantization 在量化上做改善
        [y_DPCM rate_DPCM(trial)] = ...
            DPCM_Coding(y, quantizer_bitdepth, num_rows, num_cols);
        
        % reconstruction
        disp('Decoding DPCM...');
        tic
        x_hat_DPCM = BCS_SPL_DDWT_Decoder(y_DPCM, Phi, num_rows, num_cols, ...
            num_levels);
        toc
        DPCM_Name = strcat(filename,'_SPL_DPCM_Rate_',num2str(rate_DPCM(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(original_image, x_hat_DPCM)),'dB.tif');
        imwrite(uint8(x_hat_DPCM),strcat('Results\',DPCM_Name));
        
        psnr_DPCM(trial) = PSNR(original_image, x_hat_DPCM);
        disp(['Rate = ' num2str(rate_DPCM(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_DPCM(trial), '%0.2f') ' (dB)']);
    end
    % load bits and subrates used in the paper
    algorithm = 'bcsspl';
    type = 'dpcm';
    filename_parameters_SQ = ['./Parameters/' filename '_' algorithm '_' ...
        type '_parameters.mat' ];
    load(filename_parameters_SQ);
    
    num_trials = length(subrates);
    
    rate_SDPC = zeros(1, num_trials);
    psnr_SDPC = zeros(1, num_trials);
    
    for trial = 1:num_trials
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        y = BCS_SPL_Encoder(x, Phi);
        
        % SDPC + uniform scalar quantization 该论文的improve为观测数据的量化，提高率失真表现
        [y_SDPC rate_SDPC(trial)] = ...
            SDPC_Coding(y, quantizer_bitdepth, num_rows, num_cols,Phi);
        
        % reconstruction
        disp('Decoding SDPC...');
        tic
        x_hat_SDPC = BCS_SPL_DDWT_Decoder(y_SDPC, Phi, num_rows, num_cols, ...
            num_levels);
        toc
        
        SDPC_Name = strcat(filename,'_SPL_SDPC_Rate_',num2str(rate_SDPC(trial)),'_QP_',num2str(quantizer_bitdepth),'_subrate_',num2str(subrate),'_PSNR_',num2str(PSNR(original_image, x_hat_SDPC)),'dB.tif');
        imwrite(uint8(x_hat_SDPC),strcat('Results\',SDPC_Name));
        
        psnr_SDPC(trial) = PSNR(original_image, x_hat_SDPC);
        disp(['Rate = ' num2str(rate_SDPC(trial), '%0.4f') ...
            ' (bpp), PSNR = ' num2str(psnr_SDPC(trial), '%0.2f') ' (dB)']);
        
    end
    
    save([filename '_' algorithm '_results.mat'], ...
        'rate_SQ', 'psnr_SQ', ...
        'rate_DPCM', 'psnr_DPCM',...
        'rate_SDPC', 'psnr_SDPC');
    
    figure;
    clf;
    plot(rate_SDPC, psnr_SDPC, 'r-x', 'LineWidth', 2);
    hold on
    plot(rate_DPCM, psnr_DPCM, 'k-x', 'LineWidth', 2);
    hold on
    plot(rate_SQ, psnr_SQ, 'b-x', 'LineWidth', 2);
    grid on
    title(filename);
    xlabel('Bitrate (bpp)');
    ylabel('PSNR (dB)');
    
    legend('BCS-SPL+SDPC','BCS-SPL+DPCM', 'BCS-SPL+SQ', 'Location', 'SouthEast');
    
end

