function [X] = conve(Z, Y)
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
    N = length(Z);
    for i = 1:N
        M = [];
        for k = 1:K
            M(:,:,k) = [zeros(h,m-1), Z{i}(:,:,k), zeros(h,m-1)];
        end
        Z{i} = M;
    end
    X = convs(Z, Y);
    X = cellfun(@sum, X, num2cell(3*ones(1,N)),'UniformOutput',0);
end