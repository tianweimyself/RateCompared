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

cur = cd;
addpath(genpath(cur));

for ImgNo = 3
    switch ImgNo
        case 1
            filename = 'lenna';
        case 2
            filename = 'peppers';
        case 3
            filename = 'clown';
    end
    
    original_image = double(imread([filename '.pgm']));
    [num_rows num_cols] = size(original_image);
    x = original_image;
    
    num_levels = 5;
    block_size = 16;
    projection_matrix_file = ['projections.' num2str(block_size) '.mat'];
    
    
    % load bits and subrates used in the paper
    algorithm = 'bcsspl';
    type = 'dpcm';
    % filename_parameters_SQ = ['./Parameters/' 'goldhill' '_' algorithm '_' ...
    %     type '_parameters.mat' ];
    filename_parameters_SQ = ['./Parameters/' filename '_' algorithm '_' ...
        type '_parameters.mat' ];
    load(filename_parameters_SQ);
    
    num_trials = length(subrates);
    rate_DPCM = zeros(1, num_trials);
    rate_SQ = zeros(1, num_trials);
    rate_SDPC = zeros(1, num_trials);

    
    for trial = 1:num_trials
        
        quantizer_bitdepth = bits(trial);
        subrate = subrates(trial);
        
        % random projection
        Phi = BCS_SPL_GenerateProjection(block_size, subrate, ...
            projection_matrix_file);
        y = BCS_SPL_Encoder(x, Phi);
        
        
        [y_SQ rate_SQ(trial)] = SQ_Coding(y, quantizer_bitdepth, num_rows, num_cols);
        
        % DPCM + uniform scalar quantization
        [y_DPCM rate_DPCM(trial)] = ...
            DPCM_Coding(y, quantizer_bitdepth, num_rows, num_cols);
            
       
        % SDPC + uniform scalar quantization
        [y_SDPC rate_SDPC(trial)] = ...
            SDPC_Coding(y, quantizer_bitdepth, num_rows, num_cols,Phi);
       
        
    end
    
    
    figure;
    
    clf;
    plot(rate_SDPC, 'r-x', 'LineWidth', 2);
    hold on
    plot(rate_DPCM, 'b-x', 'LineWidth', 2);   
    plot(rate_SQ, 'k-x', 'LineWidth', 2);    
    grid on
    title(filename);
    xlabel('Condition');
    ylabel('Bitrate (bpp)');
    
    legend('BCS-SPL+SDPC', 'BCS-SPL+DPCM','BCS-SPL+SQ','Location', 'SouthEast');
    
end



