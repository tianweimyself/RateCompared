clear;
clc;
load('peppers_bcsspl_dpcm_results.mat')
    load('peppers_bcsspl_MFPQ_results.mat')
    load('peppers_bcsspl_SDPC_ch8_results.mat')
    load('peppers_bcsspl_SDPC_ch16_results.mat')
    load('peppers_bcsspl_SDPC_results.mat')
    
     rate_SDPC = sort(rate_SDPC)
     rate_DPCM = sort(rate_DPCM);
     rate_MFPQ = sort(rate_MFPQ);
     rate_SDPC_ch8 = sort(rate_SDPC_ch8)
     rate_SDPC_ch16 = sort(rate_SDPC_ch16);
     
     psnr_SDPC = sort(psnr_SDPC)
     psnr_DPCM = sort(psnr_DPCM);
     psnr_MFPQ = sort(psnr_MFPQ);
     psnr_SDPC_ch8 = sort(psnr_SDPC_ch8)
     psnr_SDPC_ch16 = sort(psnr_SDPC_ch16);
     
     upDb = sum(psnr_SDPC_ch8) - sum(psnr_SDPC)
     upRate = upDb / sum(psnr_SDPC)
    filename = 'peppers';
    figure;
    clf;
    plot(rate_SDPC, psnr_SDPC, 'r-x', 'LineWidth', 2); %��ɫ
    hold on
    plot(rate_DPCM, psnr_DPCM, 'k-x', 'LineWidth', 2); %��ɫ
    hold on
    plot(rate_MFPQ, psnr_MFPQ, 'b-x', 'LineWidth', 2); %��ɫ
    hold on
    plot(rate_SDPC_ch8, psnr_SDPC_ch8, 'g-x', 'LineWidth', 1);  %��ɫ
    hold on
    plot(rate_SDPC_ch16, psnr_SDPC_ch16, 'y-x', 'LineWidth', 1);  %��ɫ
    grid on
    title(filename);
    xlabel('Bitrate (bpp)');
    ylabel('PSNR (dB)');
    
    legend('BCS-SPL+SDPC','BCS-SPL+DPCM', 'BCS-SPL+MFPQ', 'BCS-SPL+Prop.8','BCS-SPL+Prop.16','Location', 'SouthEast');