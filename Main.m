%��ʵ������Run_Experiment_BCSSPL_SDPC.m�ϵĸĽ���Run_Experiment_BCSSPL_SDPC.m
%������SQ, DPCM+SQ, SDPC+SQ����ʵ��
%Main.m�ڴ˻�������������ʵ��SDPC8 + SQ(�ڵ�ǰͼ����8������Ѱ�����Ԥ���)
%SDPC16 + SQ(�ڵ�ǰͼ����16������Ѱ�����Ԥ���)

cur = cd;
addpath(genpath(cur));
for imageIndex = 1 : 3
    for ImaNo = imageIndex %ѡ��ͬ��ͼƬ�������Լ�����
    switch ImaNo
        case 1
            filename = 'lenna';
        case 2
            filename = 'peppers';
        case 3
            filename = 'clown';
    end
    
    original_image = double(imread([filename '.pgm']));
    [num_rows, num_cols] = size(original_image);
    current_image = original_image;
    
    num_levels = 5;
    block_size = 8; %��ͼ��ֿ�Ĵ�С�������Լ����ڳ�����ֵ��4��8��16��32��
    algorithm = 'bcsspl'; %SPL�ع�����
    
    [psnr_spl_adapt, rate_spl_adapt, coef_spl_adapt] = SPL_adapt(filename, current_image, num_levels, block_size, algorithm);
    [psnr_sq, rate_sq] = SQ(filename, current_image, num_levels, block_size, algorithm);
    [psnr_dpcm, rate_dpcm] = DPCM(filename, current_image, num_levels, block_size, algorithm);
    [psnr_mfpq, rate_mfpq] = MFPQ(filename, current_image, num_levels, block_size, algorithm);
    [psnr_sdpc, rate_sdpc] = SDPC(filename, current_image, num_levels, block_size, algorithm);
    [psnr_sdpc_ch8, rate_sdpc_ch8] = SDPC_ch8(filename, current_image, num_levels, block_size, algorithm);
    [psnr_sdpc_ch16, rate_sdpc_ch16] = SDPC_ch16(filename, current_image, num_levels, block_size, algorithm);
    
    
    
    figure;
    clf;
    plot(rate_sdpc, psnr_sdpc, 'r-x', 'LineWidth', 2); %��ɫ
    hold on
    plot(rate_dpcm, psnr_dpcm, 'k-x', 'LineWidth', 2); %��ɫ
    hold on
    plot(rate_mfpq, psnr_mfpq, 'b-x', 'LineWidth', 2); %��ɫ
    hold on
    plot(rate_sdpc_ch8, psnr_sdpc_ch8, 'g-x', 'LineWidth', 1);  %��ɫ
    hold on
    plot(rate_sdpc_ch16, psnr_sdpc_ch16, 'y-x', 'LineWidth', 1);  %��ɫ
    grid on
    title(filename);
    xlabel('Bitrate (bpp)');
    ylabel('PSNR (dB)');
    
    legend('BCS-SPL+SDPC','BCS-SPL+DPCM', 'BCS-SPL+MFPQ', 'BCS-SPL+SDPC_ch8','BCS-SPL+SDPC_ch16','Location', 'SouthEast');
    end
end