function Z = convs4(X,Y)
% CONVS4  Shrinking matrix convolution in CRBM for weights calculation
%   Z = CONVS4(X, Y, useCuda)
%       Takes X the n-by-n input image, Y the m-by-m convolutional filter,
%       returns the convolution result Z, which is (n-m+1)-by-(n-m+1)
%       
%       Set useCuda to 1 to use CUDA MEX files.
%
%
%   Written by: Peng Qi, Jan 12, 2013


% rewrite to speed up
    [h,n] = size(X{1});
    m = size(Y{1},2);
    K = size(Y{1},3);
    wf = n-m+1;    
    Z = zeros(h, wf, K, length(X));
    for i = 1:length(X);
        M = X{i};
        n = size(M,2);
        M = M(:,wf:(n-wf+1));%
        n = n-wf*2+2;%
        m = size(Y{i},2);        
        Y{i} = Y{i}(:,wf:(m-wf+1),:);%
        m = m-wf*2+2;%
        for k = 1:K
            N = zeros(h, n-m+1);
            for j = 1:(n-m+1)      
                N(:,j) = dot(M(:,j:(j+m-1)), Y{i}(:,:,k), 2);
            end
            Z(:,:,k,i) = N;%used to devide
        end
        
    end
    Z = mean(Z, 4);
end