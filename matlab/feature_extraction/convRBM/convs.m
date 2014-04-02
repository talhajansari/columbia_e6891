function Z = convs(X, Y)
% CONVS  Shrinking matrix convolution in CRBM
%   Z = CONVS(X, Y, useCuda)
%       Takes X the n-by-n input image, Y the m-by-m convolutional filter,
%       returns the convolution result Z, which is (n-m+1)-by-(n-m+1)
%       
%       Set useCuda to 1 to use CUDA MEX files.
%
%       See also CONVE
%
%   Written by: Peng Qi, Sep 27, 2012

% rewrite to speed up
    [h,m,K] = size(Y);
    Z = cell(size(X));
    for i = 1:length(X);
        M = X{i};
        n = size(M,2);
        N = zeros(h, n-m+1,K);
        for j = 1:(n-m+1)
            for k = 1:K
                N(:,j,k) = dot(M(:,j:(j+m-1)), Y(:,:,k), 2);
            end
        end
        Z{i} = N;
    end
end