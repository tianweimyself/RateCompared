fileName = '/Image/lenna.pgm';
original_image = double(imread(fileName));
[num_rows, num_cols] = size(original_image);

x = im2col(original_image, [16 16], 'distinct');
s = std(x);
sReshape = reshape(s, [32, 32]);
% isFlaged = 

% diff = zeros(size(s)); %1 * 1024
% for k = 1 : size(diff, 2)
%     if k == 1
%         diff(1, k) = 0;
%     elseif ceil(k/32) == 1
%         diff(1, k) = abs(s(1,k) - s(1, k - 1));
%     elseif mod(k,32) == 1
%         diff(1, k) = abs(s(1,k) - s(1, k - 32));
%     else
%         diff(1, k) = max(abs(s(1,k) - s(1, k - 1)), abs(s(1,k) - s(1, k - 32)));
%     end
% end
% diffReshape = reshape(diff, [32, 32]);
% h1 = histogram(diff);
% h = histogram(s);
% sReshape = reshape(s, [32, 32]);
% save([filename '_results.mat'], ...
%         'sReshape', 'original_image', 'diff', 's', 'diffReshape');

