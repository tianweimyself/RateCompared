function [recmeaumentOfcross, recmeaumentOfremain,  rate,  avg_coff ] = SPL_adapt_Coding(remainIndex, crossIndex, Phi_remain, ramainMeaurement,  crossMeaurement, quantizer_bitdepth, block_size, num_rows)
% 整体上分了6大块，那我分别计算得了，我又不想预测了，因为我看不出效果。但是你不去预测的话，中心点开始，螺旋预测就没用了，真的烦。。。
%真的啰嗦，如果观测端整这一出，复杂度我都不想说了，做吧，做吧，分六大块

%%%%%%%%%%%%%%第一块（crossInner）,不用预测，直接SQ%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossInner = crossMeaurement{1, 1};
crossInner_max = max(meaumentOfcrossInner(:));
crossInner_min = min(meaumentOfcrossInner(:));

q = (crossInner_max - crossInner_min)/2^quantizer_bitdepth;

% simple scalar quantization 标量量化（观测端做的事情）
meaumentOfcrossInner_q = round(meaumentOfcrossInner/q);
meaumentOfcrossInner_q_re = meaumentOfcrossInner_q*q; %这里做的是重构端的事
%%%%%%%%信息熵后面一起算%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%第二块（crossMiddler）,不用预测，直接SQ%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossMiddler = crossMeaurement{1, 2};
crossMiddler_max = max(meaumentOfcrossMiddler(:));
crossMiddler_min = min(meaumentOfcrossMiddler(:));

q = (crossMiddler_max - crossMiddler_min)/2^quantizer_bitdepth;

% simple scalar quantization 标量量化（观测端做的事情）
meaumentOfcrossMiddler_q = round(meaumentOfcrossMiddler/q);
meaumentOfcrossMiddler_q_re = meaumentOfcrossMiddler_q*q; %这里做的是重构端的事
%%%%%%%%信息熵后面一起算%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%第三块（crossOuter）,不用预测，直接SQ%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossOuter = crossMeaurement{1, 3};
crossOuter_max = max(meaumentOfcrossOuter(:));
crossOuter_min = min(meaumentOfcrossOuter(:));

q = (crossOuter_max - crossOuter_min)/2^quantizer_bitdepth;

% simple scalar quantization 标量量化（观测端做的事情）
meaumentOfcrossOuter_q = round(meaumentOfcrossOuter/q);
meaumentOfcrossOuter_q_re = meaumentOfcrossOuter_q*q; %这里做的是重构端的事
%%%%%%%%信息熵后面一起算%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%第四块（remainInner）,预测%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainInner = ramainMeaurement{1, 1};
remainInner_max = max(meaumentOfremainInner(:));
remainInner_min = min(meaumentOfremainInner(:));

remainInnerIndexOrigin = remainIndex{1, 1};
q = (remainInner_max - remainInner_min)/2^quantizer_bitdepth;%量化scale
DC_block = ones(block_size * block_size,1)*128;
DC_Measure = Phi_remain{1, 1}*DC_block;
%输出残差yq, 重构值残差相加得到y_q
[diffRemainInnderMeaurement, recRemainInnderMeaurement, y_index, coefRemainInnder] = SPL_adapt_Encode(meaumentOfremainInner,q,DC_Measure,remainInnerIndexOrigin, block_size, num_rows);



%%%%%%%%%%%%%%%%第五块（remainMiddler）,预测%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainMiddler = ramainMeaurement{1, 2};
remainMiddler_max = max(meaumentOfremainMiddler(:));
remainMiddler_min = min(meaumentOfremainMiddler(:));

remainMiddlerIndexOrigin = remainIndex{1, 2};
q = (remainMiddler_max - remainMiddler_min)/2^quantizer_bitdepth;%量化scale
DC_block = ones(block_size * block_size,1)*128;
DC_Measure = Phi_remain{1, 2}*DC_block;
%输出残差yq, 重构值残差相加得到y_q
[diffRemainMiddlerMeaurement, recRemainMiddlerMeaurement, y_index, coefRemainMiddler] = SPL_adapt_Encode(meaumentOfremainMiddler,q,DC_Measure,remainMiddlerIndexOrigin, block_size, num_rows);


%%%%%%%%%%%%%%%%第六块（remainOuter）,预测%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainOuter = ramainMeaurement{1, 3};
remainOuter_max = max(meaumentOfremainOuter(:));
remainOuter_min = min(meaumentOfremainOuter(:));

remainOuterIndexOrigin = remainIndex{1, 3};
q = (remainOuter_max - remainOuter_min)/2^quantizer_bitdepth;%量化scale
DC_block = ones(block_size * block_size,1)*128;
DC_Measure = Phi_remain{1, 3}*DC_block;
%输出残差yq, 重构值残差相加得到y_q
[diffRemainOuterMeaurement, recRemainOuterMeaurement, y_index, coefRemainOuter] = SPL_adapt_Encode(meaumentOfremainOuter,q,DC_Measure,remainOuterIndexOrigin, block_size, num_rows);


%%%%%%%计算相关系数平均值%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
remainBlocks = size(meaumentOfremainInner, 2) + size(meaumentOfremainMiddler, 2) + size(meaumentOfremainOuter, 2);
avg_coff = (sum(coefRemainInnder) + sum(coefRemainMiddler) + sum(coefRemainOuter)) / remainBlocks;

%%%%%%%%%计算bitrate%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
remian_pixels = remainBlocks * block_size * block_size;
diffRemainInnderMeaurementCol = diffRemainInnderMeaurement(:);
diffRemainMiddlerMeaurementCol = diffRemainMiddlerMeaurement(:);
diffRemainOuterMeaurementCol = diffRemainOuterMeaurement(:);
transBits  = [diffRemainInnderMeaurementCol;diffRemainMiddlerMeaurementCol; diffRemainOuterMeaurementCol];

rate = Measurement_Entropy(transBits,remian_pixels);

%%%%%%%output args%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
recmeaumentOfcross = {meaumentOfcrossInner_q_re, meaumentOfcrossMiddler_q_re, meaumentOfcrossOuter_q_re};
recmeaumentOfremain = {recRemainInnderMeaurement, recRemainMiddlerMeaurement, recRemainOuterMeaurement};
end