% 这份代码是在SDPC源代码的基础上改进添加的
% 
% 运行Main.m脚本文件可以看到5种算法('BCS-SPL+SDPC','BCS-SPL+DPCM', 'BCS-SPL+SQ', 'BCS-SPL+SDPC_ch8','BCS-SPL+SDPC_ch16')
% 的图像率失真图，后续继续要做的话可以拿到预测块的相关性信息，标志位的分布图。
% 
% 改进的核心代码为satisfy, satisfy16分别是找到当前块领域的8个块的index和16个块的index

