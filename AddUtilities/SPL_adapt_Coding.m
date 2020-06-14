function [recmeaumentOfcross, recmeaumentOfremain,  rate,  avg_coff ] = SPL_adapt_Coding(remainIndex, crossIndex, Phi_remain, ramainMeaurement,  crossMeaurement, quantizer_bitdepth, block_size, num_rows)
% �����Ϸ���6��飬���ҷֱ������ˣ����ֲ���Ԥ���ˣ���Ϊ�ҿ�����Ч���������㲻ȥԤ��Ļ������ĵ㿪ʼ������Ԥ���û���ˣ���ķ�������
%��Ć��£�����۲������һ�������Ӷ��Ҷ�����˵�ˣ����ɣ����ɣ��������

%%%%%%%%%%%%%%��һ�飨crossInner��,����Ԥ�⣬ֱ��SQ%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossInner = crossMeaurement{1, 1};
crossInner_max = max(meaumentOfcrossInner(:));
crossInner_min = min(meaumentOfcrossInner(:));

q = (crossInner_max - crossInner_min)/2^quantizer_bitdepth;

% simple scalar quantization �����������۲���������飩
meaumentOfcrossInner_q = round(meaumentOfcrossInner/q);
meaumentOfcrossInner_q_re = meaumentOfcrossInner_q*q; %�����������ع��˵���
%%%%%%%%��Ϣ�غ���һ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%�ڶ��飨crossMiddler��,����Ԥ�⣬ֱ��SQ%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossMiddler = crossMeaurement{1, 2};
crossMiddler_max = max(meaumentOfcrossMiddler(:));
crossMiddler_min = min(meaumentOfcrossMiddler(:));

q = (crossMiddler_max - crossMiddler_min)/2^quantizer_bitdepth;

% simple scalar quantization �����������۲���������飩
meaumentOfcrossMiddler_q = round(meaumentOfcrossMiddler/q);
meaumentOfcrossMiddler_q_re = meaumentOfcrossMiddler_q*q; %�����������ع��˵���
%%%%%%%%��Ϣ�غ���һ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%�����飨crossOuter��,����Ԥ�⣬ֱ��SQ%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossOuter = crossMeaurement{1, 3};
crossOuter_max = max(meaumentOfcrossOuter(:));
crossOuter_min = min(meaumentOfcrossOuter(:));

q = (crossOuter_max - crossOuter_min)/2^quantizer_bitdepth;

% simple scalar quantization �����������۲���������飩
meaumentOfcrossOuter_q = round(meaumentOfcrossOuter/q);
meaumentOfcrossOuter_q_re = meaumentOfcrossOuter_q*q; %�����������ع��˵���
%%%%%%%%��Ϣ�غ���һ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%���Ŀ飨remainInner��,Ԥ��%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainInner = ramainMeaurement{1, 1};
remainInner_max = max(meaumentOfremainInner(:));
remainInner_min = min(meaumentOfremainInner(:));

remainInnerIndexOrigin = remainIndex{1, 1};
q = (remainInner_max - remainInner_min)/2^quantizer_bitdepth;%����scale
DC_block = ones(block_size * block_size,1)*128;
DC_Measure = Phi_remain{1, 1}*DC_block;
%����в�yq, �ع�ֵ�в���ӵõ�y_q
[diffRemainInnderMeaurement, recRemainInnderMeaurement, y_index, coefRemainInnder] = SPL_adapt_Encode(meaumentOfremainInner,q,DC_Measure,remainInnerIndexOrigin, block_size, num_rows);



%%%%%%%%%%%%%%%%����飨remainMiddler��,Ԥ��%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainMiddler = ramainMeaurement{1, 2};
remainMiddler_max = max(meaumentOfremainMiddler(:));
remainMiddler_min = min(meaumentOfremainMiddler(:));

remainMiddlerIndexOrigin = remainIndex{1, 2};
q = (remainMiddler_max - remainMiddler_min)/2^quantizer_bitdepth;%����scale
DC_block = ones(block_size * block_size,1)*128;
DC_Measure = Phi_remain{1, 2}*DC_block;
%����в�yq, �ع�ֵ�в���ӵõ�y_q
[diffRemainMiddlerMeaurement, recRemainMiddlerMeaurement, y_index, coefRemainMiddler] = SPL_adapt_Encode(meaumentOfremainMiddler,q,DC_Measure,remainMiddlerIndexOrigin, block_size, num_rows);


%%%%%%%%%%%%%%%%�����飨remainOuter��,Ԥ��%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainOuter = ramainMeaurement{1, 3};
remainOuter_max = max(meaumentOfremainOuter(:));
remainOuter_min = min(meaumentOfremainOuter(:));

remainOuterIndexOrigin = remainIndex{1, 3};
q = (remainOuter_max - remainOuter_min)/2^quantizer_bitdepth;%����scale
DC_block = ones(block_size * block_size,1)*128;
DC_Measure = Phi_remain{1, 3}*DC_block;
%����в�yq, �ع�ֵ�в���ӵõ�y_q
[diffRemainOuterMeaurement, recRemainOuterMeaurement, y_index, coefRemainOuter] = SPL_adapt_Encode(meaumentOfremainOuter,q,DC_Measure,remainOuterIndexOrigin, block_size, num_rows);


%%%%%%%�������ϵ��ƽ��ֵ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
remainBlocks = size(meaumentOfremainInner, 2) + size(meaumentOfremainMiddler, 2) + size(meaumentOfremainOuter, 2);
avg_coff = (sum(coefRemainInnder) + sum(coefRemainMiddler) + sum(coefRemainOuter)) / remainBlocks;

%%%%%%%%%����bitrate%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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