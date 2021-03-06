function [ rec_SPL_adapt ] = SPL_adapt_DecoderFun( recmeaumentOfcross,recmeaumentOfremain,remainIndex, crossIndex, ...
        Phi_basic,Phi_remain, num_rows, num_cols,num_levels, block_size )
%分六个部分重构
%%%%%%%%%%%%%%第一块（crossInner）%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossInner_q_re = recmeaumentOfcross{1, 1};
crossInnerInOrigin = zeros(size(meaumentOfcrossInner_q_re, 1), (num_rows / block_size) * (num_cols / block_size));
crossInnerIndexOrigin = crossIndex{1, 1};
meaumentOfcrossInnerInOrigin = getmeaumentInOrigin(crossInnerInOrigin, meaumentOfcrossInner_q_re, crossInnerIndexOrigin );
crossInnerInOrigin = BCS_SPL_DDWT_Decoder_col(meaumentOfcrossInnerInOrigin, Phi_basic, num_rows, num_cols, num_levels);
        

%%%%%%%%%%%%%%第二块（crossMiddler）%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossMiddler_q_re = recmeaumentOfcross{1, 2};
crossMiddlerInOrigin = zeros(size(meaumentOfcrossMiddler_q_re, 1), (num_rows / block_size) * (num_cols / block_size));
crossMiddlerIndexOrigin = crossIndex{1, 2};
meaumentOfcrossMiddlerInOrigin = getmeaumentInOrigin(crossMiddlerInOrigin, meaumentOfcrossMiddler_q_re, crossMiddlerIndexOrigin );
crossMiddlerInOrigin = BCS_SPL_DDWT_Decoder_col(meaumentOfcrossMiddlerInOrigin, Phi_basic, num_rows, num_cols, num_levels);
        
%%%%%%%%%%%%%%第三块（crossOuter）%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfcrossOuter_q_re = recmeaumentOfcross{1, 3};
crossOuterInOrigin = zeros(size(meaumentOfcrossOuter_q_re, 1), (num_rows / block_size) * (num_cols / block_size));
crossOuterIndexOrigin = crossIndex{1, 3};
meaumentOfcrossOuterInOrigin = getmeaumentInOrigin(crossOuterInOrigin, meaumentOfcrossOuter_q_re, crossOuterIndexOrigin );
crossOuterInOrigin = BCS_SPL_DDWT_Decoder_col(meaumentOfcrossOuterInOrigin, Phi_basic, num_rows, num_cols, num_levels);


%%%%%%%%%%%%%%第四块（remainInner）%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainInner_q_re = recmeaumentOfremain{1, 1};
remainInnerInOrigin = zeros(size(meaumentOfremainInner_q_re, 1), (num_rows / block_size) * (num_cols / block_size));
remainInnerIndexOrigin = remainIndex{1, 1};
meaumentOfremainInnerInOrigin = getmeaumentInOrigin(remainInnerInOrigin, meaumentOfremainInner_q_re, remainInnerIndexOrigin );
remainInnerInOrigin = BCS_SPL_DDWT_Decoder_col(meaumentOfremainInnerInOrigin, Phi_remain{1, 1}, num_rows, num_cols, num_levels);

%%%%%%%%%%%%%%第五块（remainMiddler）%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainMiddler_q_re = recmeaumentOfremain{1, 2};
remainMiddlerInOrigin = zeros(size(meaumentOfremainMiddler_q_re, 1), (num_rows / block_size) * (num_cols / block_size));
remainMiddlerIndexOrigin = remainIndex{1, 2};
meaumentOfremainMiddlerInOrigin = getmeaumentInOrigin(remainMiddlerInOrigin, meaumentOfremainMiddler_q_re, remainMiddlerIndexOrigin );
remainMiddlerInOrigin = BCS_SPL_DDWT_Decoder_col(meaumentOfremainMiddlerInOrigin, Phi_remain{1, 2}, num_rows, num_cols, num_levels);


%%%%%%%%%%%%%%第六块（remainOuter）%%%%%%%%%%%%%%%%%%%%%%%%
meaumentOfremainOuter_q_re = recmeaumentOfremain{1, 3};
remainOuterInOrigin = zeros(size(meaumentOfremainOuter_q_re, 1), (num_rows / block_size) * (num_cols / block_size));
remainOuterIndexOrigin = remainIndex{1, 3};
meaumentOfremainOuterInOrigin = getmeaumentInOrigin(remainOuterInOrigin, meaumentOfremainOuter_q_re, remainOuterIndexOrigin );
remainOuterInOrigin = BCS_SPL_DDWT_Decoder_col(meaumentOfremainOuterInOrigin, Phi_remain{1, 3}, num_rows, num_cols, num_levels);


%%%%%%%%接下来最刺激的六合一%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allRecImage = zeros(block_size * block_size, (num_rows / block_size) * (num_cols / block_size));
for k = 1 : size(allRecImage, 2)
    if ismember(k, crossInnerIndexOrigin)
        allRecImage(:, k) = crossInnerInOrigin(:, k);
    elseif ismember(k, crossMiddlerIndexOrigin)
        allRecImage(:, k) = crossMiddlerInOrigin(:, k);
    elseif ismember(k, crossOuterIndexOrigin)
        allRecImage(:, k) = crossOuterInOrigin(:, k);
    elseif ismember(k, remainInnerIndexOrigin)
        allRecImage(:, k) = remainInnerInOrigin(:, k);
    elseif ismember(k, remainMiddlerIndexOrigin)
        allRecImage(:, k) = remainMiddlerInOrigin(:, k);
    else
        allRecImage(:, k) = remainOuterInOrigin(:, k);
    end
end

rec_SPL_adapt = col2im(allRecImage, [block_size block_size], ...
    [num_rows num_cols], 'distict');
end


function [meaumentInOrigin] = getmeaumentInOrigin(inOrigin, meaumentOf_q_re, indexOrigin )
meaumentInOrigin = inOrigin;
for k = 1 : size(meaumentOf_q_re, 2)
   meaumentInOrigin(:, indexOrigin(k)) = meaumentOf_q_re(:, k);
end
end

