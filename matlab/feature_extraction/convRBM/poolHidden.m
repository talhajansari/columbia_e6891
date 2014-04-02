function [hidres, poolres, hidsample] = poolHidden(poshidacts, hbias, p)
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
    poolres = cell(size(poshidacts));
    hidres = cell(size(poshidacts));
    hidsample = cell(size(poshidacts));
    N = length(poshidacts);
    for i = 1:N
        [h,w,k] = size(poshidacts{i});
        hidres{i} = sigmoid(poshidacts{i}+shiftdim(repmat(hbias, [w 1 h]),2));
        hidsample{i} = binornd(1, hidres{i});
        h = floor(h/p);
        w = floor(w/p);        
        exprob = exp(poshidacts{i});
        if w <= 0
            M = zeros(h, 1, k);
            for ih = 1:h
                prob = exprob(((ih-1)*p+1):(ih*p), :, :);
                M(ih,1,:) = 1-1./(1+sum(sum(prob)));
            end
        else
            M = zeros(h, w, k);
            for ih = 1:h
                for iw = 1:w
                    prob = exprob(((ih-1)*p+1):(ih*p), ((iw-1)*p+1):(iw*p), :);            
                    M(ih,iw,:) = 1-1./(1+sum(sum(prob)));
                end
            end
        end
        poolres{i} = M; 
    end
else
    hidres = cell(size(poshidacts));
    N = length(poshidacts);
    for i = 1:N
        [h,w,k] = size(poshidacts{i});
        hidres{i} = sigmoid(poshidacts{i}+shiftdim(repmat(hbias, [w 1 h]),2));
    end
end
end