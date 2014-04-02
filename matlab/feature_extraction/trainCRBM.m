function [model, output] = trainCRBM(data, params, oldModel)
% TRAINCRBM  Trains a convolutional restricted Boltzmann machine 
%   with the specified parameters.
%
%   [model output] = TRAINCRBM(data, params, oldModel)
%
%   data should be a structure, containing:
%       data.x      The input images / pooling states of the previous layer
%                   of CRBM. This matrix is 4-D the first three dimensions
%                   define an image (coloum-stored with a color channel),
%                   and the last dimension indexes through the batch of
%                   images. I.e. the four dimensions are: height, width,
%                   channels (1 for grayscale, 3 for RGB), and number of
%                   images.
%
%   Written by: Peng Qi, Sep 27, 2012
%   Last Updated: Feb 8, 2014
%   Version: 0.3 alpha

if params.verbose > 0,
    fprintf('Starting training CRBM with the following parameters:\n');
    disp(params);
    fprintf('Initializing parameters...');
end

useCuda = params.useCuda;


%% initialization
N = length(data);
Nfilters = params.nmap;
Wfilter = params.szFilter;
p = params.szPool;
H = size(data{1}, 1);
W = cellfun(@size, data, num2cell(2*ones(1,N)));
Whidden = W - Wfilter + 1;
Hpool = H;
Wpool = floor(Whidden / p);
param_iter = params.iter;
param_szBatch = params.szBatch;
output_enabled = nargout > 1;

%vmasNfilters = conve(ones(nh), ones(m), useCuda);

hinit = -.5;%0;

if params.sparseness > 0,
    hinit = -.1;
end

if exist('oldModel','var') && ~isempty(oldModel),
    model = oldModel;
    if (~isfield(model,'W')), 
        model.W = 0.01 * randn(H, Wfilter, Nfilters);
    else
        if (size(model.W) ~= [H Wfilter Nfilters]), error('Incompatible input model.'); end
    end
    if (~isfield(model,'vbias')), model.vbias = 0;end
    if (~isfield(model,'hbias')), model.hbias = ones(1, Nfilters) * hinit;end
    if (~isfield(model,'sigma')),
        if (params.sparseness > 0)
            model.sigma = 0.1;
        else
            model.sigma = 1;    
        end
    end
else
    model.W = 0.01 * randn(H, Wfilter, Nfilters);
    model.vbias = 0;
    model.hbias = ones(1, Nfilters) * hinit;
    if (params.sparseness > 0)
        model.sigma = 0.1;
    else
        model.sigma = 1;    
    end
end

dW = 0;
dvbias = 0;
dhbias = 0;

pW = params.pW;
pvbias = params.pvbias;
phbias = params.phbias;

if output_enabled,
    output.x = zeros(Hpool, Wpool, Nfilters, N);
end

total_batches = floor(N / param_szBatch);

if params.verbose > 0,
    fprintf('Completed.\n');
end

hidq = params.sparseness;
lambdaq = 0.9;

if ~isfield(model,'iter')
    model.iter = 0;
end

%TODO
% if (params.whitenData),
%     try
%         load(sprintf('whitM_%d', params.szFilter));
%     catch e,
%         if (params.verbose > 1), fprintf('\nComputing whitening matrix...');end
%         compWhitMatrix(data.x, params.szFilter);
%         load(sprintf('whitM_%d', params.szFilter));
%         if (params.verbose > 1), fprintf('Completed.\n');end
%     end
%     if (params.verbose > 0), fprintf('Whitening data...'); end
%     data.x = whiten_data(data.x, whM, useCuda);
%     if (params.verbose > 0), fprintf('Completed.\n'); end
% end

for iter = model.iter+1:param_iter,
    % shuffle data
    batch_idx = randperm(N);
    
    if params.verbose > 0,
        fprintf('\nIteration %d\n', iter);
        if params.verbose > 1,
            fprintf('Batch progress (%d total): ', total_batches);
        end
    end
    
    hidact = zeros(1, Nfilters);
    errsum = 0;
    errsum_base = 0;
    
    if (iter > 5),
        params.pW = .9;
        params.pvbias = 0;
        params.phbias = 0;
    end
    
    for batch = 1:total_batches,
        batchdata = data(batch_idx((batch - 1) * param_szBatch + 1 : ...
            batch * param_szBatch));
        
        recon = batchdata;
        
        %% positive phase

        %% hidden update
        
        model_W = model.W;
        model_hbias = model.hbias;
        model_vbias = model.vbias;
        
        poshidacts = cell(1, param_szBatch);
        poshidprobs = cell(1, param_szBatch);
        pospoolprobs = cell(1, param_szBatch);
        poshidstates = cell(1, param_szBatch);
        for ii = 1:param_szBatch
            poshidacts{ii} = convs_(recon{ii}, model_W);
            [poshidprobs{ii}, pospoolprobs{ii}, poshidstates{ii}] = poolHidden_(...
                poshidacts{ii}/model.sigma, model_hbias/model.sigma, p);
        end 
%         poshidacts = convs(recon, model_W);
%         [poshidprobs, pospoolprobs, poshidstates] = poolHidden(...
%             cellfun(@mrdivide, poshidacts, num2cell(model.sigma*ones(1,param_szBatch)), 'UniformOutput', 0), ...
%             model_hbias / model.sigma, p);
        
        if output_enabled && ~rem(iter, params.saveInterv),
            output_x = pospoolprobs;
        end
        
        if output_enabled && ~rem(iter, params.saveInterv),
            output.x(:,:,:,batch_idx((batch - 1) * param_szBatch + 1 : ...
            batch * param_szBatch)) = output_x;
        end
        
        %% negative phase
        
        %% reconstruct data from hidden variables

        for ii = 1:param_szBatch
            %IMPORTANT
            recon{ii} = conve_(poshidstates{ii}, model_W(:,end:-1:1,:))+model_vbias;
        end        
%         recon = cellfun(@plus, recon, num2cell(model_vbias*ones(1,param_szBatch)),'UniformOutput', 0);

        if (params.sparseness > 0)
            for i = 1:param_szBatch
                recon{i} = recon{i} + model.sigma * randn(size(recon{i}));
            end
%         else
%             for i = 1:param_szBatch
%                 recon{i} = recon{i} + .01 * randn(size(recon{i}));
%             end
        end
        
                
        %% mean field hidden update
        
        neghidacts = cell(1, param_szBatch);
        neghidprobs = cell(1, param_szBatch);
        for ii = 1:param_szBatch
            neghidacts{ii} = convs_(recon{ii}, model_W);
            neghidprobs{ii} = poolHidden_(...
            neghidacts{ii}/model.sigma, model_hbias/model.sigma, p);
        end

            
        if (params.verbose > 1),
            fprintf('.');
            err = cellfun(@minus, batchdata, recon, 'UniformOutput', 0);
            err_base = cellfun(@(x) mean(abs(x(:)).^1), batchdata);            
            errsum = errsum + sum(cellfun(@(x) mean(abs(x(:)).^1), err));
            errsum_base = errsum_base + sum(err_base);
        end
        
        %% contrast divergence update on params
        
        if (params.sparseness > 0)
            for i = 1:param_szBatch
                hidact = hidact + reshape(mean(mean(pospoolprobs{i},1),2), [1 Nfilters]);
            end
            %hidact = hidact + reshape(sum(sum(sum(pospoolprobs, 4), 2), 1), [1 Nfilters]);
        else            
            kmean = cellfun(@(x,y) reshape(mean(mean(x-y,1),2),[1 Nfilters]), poshidprobs, neghidprobs, 'UniformOutput', 0);        
            dhbias = phbias * dhbias + mean(cat(1,kmean{:}));
        end
        
        kmean = cellfun(@(x,y) mean(mean(x-y,1),2), batchdata, recon);        
        dvbias = pvbias * dvbias + mean(kmean);
        
        %TODO
        %ddw = convs4(batchdata(Wfilter:H-Wfilter+1,Wfilter:W-Wfilter+1,:).x, poshidprobs(Wfilter:Hhidden-Wfilter+1,Wfilter:Whidden-Wfilter+1,:,:)) ...
        %    - convs4(    recon(Wfilter:H-Wfilter+1,Wfilter:W-Wfilter+1,:).x, neghidprobs(Wfilter:Hhidden-Wfilter+1,Wfilter:Whidden-Wfilter+1,:,:));
        ddw = convs4(batchdata, poshidprobs) ...
            - convs4(recon, neghidprobs);
        dW = pW * dW + ddw/1;%(Whidden - 2 * Wfilter + 2) / param_szBatch;
        
        model.vbias = model.vbias + params.epsvbias * dvbias;
        if params.sparseness <= 0,
            model.hbias = model.hbias + params.epshbias * dhbias; 
        end
        model.W = model.W + params.epsW * (dW  - params.decayw * model.W);
        
    end
    
    if (params.verbose > 1),
        fprintf('\nerror: %f, upper bound: %f', errsum/(total_batches*param_szBatch), errsum_base/(total_batches*param_szBatch));
        fprintf('\tW: %f, hb: %f, hv: %f', average(model.W), average(model.hbias), average(model.vbias));
        fprintf('\ndW: %f, dhbias: %f, dvbias: %f', average(dW), average(dhbias), average(dvbias));
    end
    
    if params.sparseness > 0,
        hidact = hidact / N;
        hidq = hidq * lambdaq + hidact * (1 - lambdaq);
        dhbias = phbias * dhbias + ((params.sparseness) - (hidq));
        model.hbias = model.hbias + params.epshbias * dhbias;
        if params.verbose > 0,
            if (params.verbose > 1),
                fprintf('\nsigma:%f', model.sigma);
            end
            fprintf('\tsparseness: %f\thidbias: %f\n', sum(hidact) / Nfilters, sum(model.hbias) / Nfilters);
        end
        if (model.sigma > 0.01), %0.01
            model.sigma = model.sigma * 0.95; %.95
        end
    end
    
    if ~rem(iter, params.saveInterv),
        if (params.verbose > 3),
            figure(1);
            hidact = convs_(data{1}, model.W);
            [hidprob, poolprob, hidstate] = poolHidden_(hidact/model.sigma, model.hbias/model.sigma, params.szPool);            
            recon = (conve_(hidstate, model.W(:,end:-1:1,:)));
            hidprob = mean(hidprob,3);
            %hidprob = hidprob(:,:,1);
            %hidstate = hidstate(:,:,1);
            hidstate = mean(hidstate,3);
            subplot(2,2,1);imagesc(data{1});colorbar;axis off;title('raw');
            subplot(2,2,2);imagesc(hidprob);colorbar;axis off;title('hidden prob');
            subplot(2,2,3);imagesc(recon);colorbar;axis off;title('reconstruct');
            subplot(2,2,4);
            %imagesc(hidstate);
            [h w NN] = size(model.W);
            b = min(min(min(model.W)));
            visual = [];
            for i = 1:NN
                visual = [visual, b*ones(h,1), model.W(:,:,i)];
            end
            imagesc(visual);
            colorbar;axis off;title('hidden state');
            drawnow;
        end
        if output_enabled,
            model.iter = iter;
            save(params.saveName, 'model', 'output', 'iter');
            if params.verbose > 1,  
                fprintf('\nModel and output saved at iteration %d\n', iter);
            end
        else 
            model.iter = iter;
            save(params.saveName, 'model', 'iter');
            if params.verbose > 1,
                fprintf('\nModel saved at iteration %d\n', iter);
            end
        end
    end

end
end