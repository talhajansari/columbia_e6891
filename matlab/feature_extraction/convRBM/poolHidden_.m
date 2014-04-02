function [hidres, poolres, hidsample] = poolHidden_(poshidacts, hbias, p)
% POOLHIDDEN  Computing the pooling results (samples) for a CRBM
%   [hidres, poolres, hidsample] = POOLHIDDEN(poshidacts, hbias, p, useCuda)
%       poshidacts  Activations for hidden variables
%       hbias       Biases for hidden variables
%       p           Pooling size
%       
%       Set useCuda to 1 to use CUDA MEX files.
%
%       See also CONVS
%
%   Written by: Peng Qi, Jan 12, 2013

%TODO
if nargin > 1
    [h,w,k] = size(poshidacts);
    hidres = sigmoid(poshidacts+shiftdim(repmat(hbias, [w 1 h]),2));
    hidsample = binornd(1, hidres);
    w = floor(w/p);
    exprob = exp(poshidacts);
    %TODO
    if w <= 0
        poolres = 1-1./(1+sum(exprob,2));
    else
        poolres = zeros(h, w, k);
        for iw = 1:w
            prob = exprob(:, ((iw-1)*p+1):(iw*p), :);            
            poolres(:,iw,:) = 1-1./(1+sum(prob,2));
        end
    end
else
    [h,w,k] = size(poshidacts);
    hidres = sigmoid(poshidacts+shiftdim(repmat(hbias, [w 1 h]),2));
end
end