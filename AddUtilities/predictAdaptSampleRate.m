function [ remainIndex, crossIndex, Phi_remain, ramainMeaurement,  crossMeaurement ] = predictAdaptSampleRate( current_image, Phi_basic, K, s_q_min, subrate )
%PREDICTADAPTSAMPLERATE 此处显示有关此函数的摘要
%   此处显示详细说明
[M N] = size(Phi_basic);

block_size = sqrt(N);

[num_rows, num_cols] = size(current_image);

x = im2col(current_image, [block_size block_size], 'distinct'); %将图像块按照列排列
[ x, indexOfNum]=changed(x); %将图像按照从中心开始螺旋排列，indexOfNum为一维数组，记录着每个图像块原本的位置
average = round(size(x, 2) / 3);
remainInner = [];
remainMiddler = [];
remainOuter = [];
crossInner = [];
crossMiddler = [];
crossOuter = [];

remainInnerIndexOrigin = [];
remainMiddlerIndexOrigin = [];
remainOuterIndexOrigin = [];
crossInnerIndexOrigin = [];
crossMiddlerIndexOrigin = [];
crossOuterIndexOrigin = [];

for j = 1 : size(x, 2) %每隔K个数，把这个i* K块放入交叉子集,剩余放入剩余子集
    if j == 1
        crossInner = [crossInner, x(:, 1)];
        crossInnerIndexOrigin = [crossInnerIndexOrigin, indexOfNum(1, 1)];
    elseif j <= average
        if mod(j, K) == 0
            crossInner = [crossInner, x(:, j)];
            crossInnerIndexOrigin = [crossInnerIndexOrigin, indexOfNum(1, j)];
        else
            remainInner = [remainInner, x(:, j)];
            remainInnerIndexOrigin = [remainInnerIndexOrigin, indexOfNum(1, j)]; %这个告诉了你它原本属于哪个位置
        end
    elseif j <= 2 * average
        if mod(j, K) == 0
            crossMiddler = [crossMiddler, x(:, j)];
            crossMiddlerIndexOrigin = [crossMiddlerIndexOrigin, indexOfNum(1, j)];
        else
            remainMiddler = [remainMiddler, x(:, j)];
            remainMiddlerIndexOrigin = [remainMiddlerIndexOrigin, indexOfNum(1, j)];
        end
    else
        if mod(j, K) == 0
            crossOuter = [crossOuter, x(:, j)];
            crossOuterIndexOrigin = [crossOuterIndexOrigin, indexOfNum(1, j)];
        else
            remainOuter = [remainOuter, x(:, j)];
            remainOuterIndexOrigin = [remainOuterIndexOrigin, indexOfNum(1, j)];
        end
    end
end

%%%%%%%%分别求出inner middler outer交叉子集的观测数据%%%%%%%%%%%%%
meaumentOfcrossInner = Phi_basic * crossInner;
meaumentOfcrossMiddler = Phi_basic * crossMiddler;
meaumentOfcrossOuter = Phi_basic * crossOuter;


%%%%%%%%%%%分别求出inner middler outer交叉子集的平均观测数据
meanOfInner = mean(meaumentOfcrossInner);
meanOfMiddler = mean(meaumentOfcrossMiddler);
meanOfOuter = mean(meaumentOfcrossOuter);


%%%%%%%%%%%分别求出inner middler outer应分配观测块的比例
%rate_sum = sum(norm(meanOfInner, 1), norm(meanOfMiddler, 1), norm(meanOfOuter, 1));
rate_sum = norm(meanOfInner, 1) + norm(meanOfMiddler, 1) + norm(meanOfOuter, 1);
rateInner = norm(meanOfInner, 1) / rate_sum;
rateMiddler = norm(meanOfMiddler, 1) / rate_sum;
rateOuter = norm(meanOfOuter, 1) / rate_sum;
s_q_Inner = min(max(rateInner * 3 * subrate,s_q_min),1.00);
s_q_Middler = min(max(rateMiddler * 3 * subrate,s_q_min),1.00);
s_q_Outer = min(max(rateOuter * 3 * subrate,s_q_min),1.00);

%%%%%%%%%%根据观测率生成随机观测矩阵%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Phi_inner = GenerateRandomProjection(block_size, s_q_Inner);
Phi_middler = GenerateRandomProjection(block_size, s_q_Middler);
Phi_outer = GenerateRandomProjection(block_size, s_q_Outer);

%%%%%%%%%观测得到inner middler outer观测数据
meaumentOfremainInner = Phi_inner * remainInner;
meaumentOfremainMiddler = Phi_middler * remainMiddler;
meaumentOfremainOuter = Phi_outer * remainOuter;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%output args%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
remainIndex = {remainInnerIndexOrigin, remainMiddlerIndexOrigin, remainOuterIndexOrigin};
crossIndex = {crossInnerIndexOrigin, crossMiddlerIndexOrigin, crossOuterIndexOrigin};
Phi_remain = {Phi_inner, Phi_middler, Phi_outer};
ramainMeaurement = {meaumentOfremainInner, meaumentOfremainMiddler, meaumentOfremainOuter};
crossMeaurement = {meaumentOfcrossInner, meanOfMiddler, meaumentOfcrossOuter};

end

