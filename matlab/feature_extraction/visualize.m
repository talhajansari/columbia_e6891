load '/home/jingwei/bird/model_2k_50.mat'
[h w N] = size(model.W);
b = min(min(min(model.W)));
mid = 10:40;
visual = [];
for i = 1:N
    visual = [visual, b*ones(length(mid),1), model.W(mid,:,i)];
end
imagesc(visual);
colormap(jet);
colorbar
axis off