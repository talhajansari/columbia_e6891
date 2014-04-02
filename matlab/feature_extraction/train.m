root = '/home/jingwei/bird/';
load(strcat(root, 'data5.mat'))
data = cellfun(@abs, data, 'UniformOutput', 0);
maximum = 0;
%N = length(data);
%data = data(randperm(N));
%data = data(1:50);
N = length(data);
sum = [];
for i = 1:N    
    data{i} = expand(data{i} ./ max(data{i}(:)));
    sum = [sum, mean(data{i}(:))];
end
for i = 1:N
    %data{i} = .5/mean(sum)*data{i};
    data{i} = 30*data{i};
end
params = getparams('CD', root);
[model] = trainCRBM(data, params);
load(strcat(root, 'model.mat'))
[model] = trainCRBM(data, params, model);
%model.W = zeros(64,5,10);
%model.W(:,:,1) = .5*ones(64,5);
%model.hbias = -3*ones(1,10);

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
subplot(2,2,4);imagesc(hidstate);colorbar;axis off;title('hidden state');
drawnow;