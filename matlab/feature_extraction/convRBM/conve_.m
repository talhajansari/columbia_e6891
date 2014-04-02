function [X] = conve_(Z, Y)
% CONVE  Expanding matrix convolution in CRBM
%   X = CONVE(Z, Y)
%       Takes Z the nz-by-nz input image, Y the m-by-m convolutional filter,
%       returns the convolution result X, which is (nz+m-1)-by-(nz+m+1)
%       
%       Set useCuda to 1 to use CUDA MEX files.
%
%       See also CONVS
%
%   Written by: Peng Qi, Sep 27, 2012
    [h,m,K] = size(Y);
    Z = [zeros(h,m-1,K), Z, zeros(h,m-1,K)];
    X = convs_(Z, Y);
    X = sum(X, 3);
end