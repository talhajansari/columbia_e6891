function b = medianClipping(a, time_th, freq_th, set_to)

b = a;
[H,W] = size(b);
row_th = ones(H,1) * (freq_th*median(b,1));
col_th = time_th*median(b,2) * ones(1,W);        
b(b < col_th | b < row_th) = set_to;
