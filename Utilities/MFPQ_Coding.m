
function [y_q rate,coef] = MFPQ_Coding(y, quantizer_bitdepth, num_rows,num_cols, Phi,trial)

y_max = max(y(:));  y_min = min(y(:));

q = (y_max - y_min)/2^quantizer_bitdepth;

[M N] = size(Phi);

block_size = sqrt(N);

%DC_block = ones(256,1)*128; 这样写的有局限性，只能计算block_size = 16的情况
DC_block = ones(block_size * block_size,1)*128;

DC_Measure = Phi*DC_block;

[yq, y_q,coef] = MFPQ_Encode(y,q,DC_Measure);


total_pixels = num_rows*num_cols;

rate = Measurement_Entropy(yq(:),total_pixels);

end

