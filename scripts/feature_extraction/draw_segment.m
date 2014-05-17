head;
savepath = 'test.bak/';
soundspath = '/Users/talhajansari/development/columbia_e6998/bird_sounds_data/';
%load /home/jingwei/bird/files.mat
figurepath = '/media/wind/bird_spectrum/';

I = 100;
J = 2;
m = [];
for i = 19:300%length(name)        
    fprintf('\n%d', i);
    asp = [];
    NN = 1600;
    I = .5*ones(2,NN);
    for j = 1:length(filename{i})
        mp3file = char(filename{i}(j));
        matfile = strcat(savepath,name{i},'/',mp3file(1:end-4),'.mat');
        if ~exist(matfile)
            continue
        end
        
        load(matfile);
        
        fprintf('.');
        if mod(j,100) == 0
            fprintf('\n')
        end
        
        dasp = [];
        for k = 1:length(X)
            seg = X{k}.as;
            %seg = seg / max(seg(:));
            seg = dexpand(seg);
            seg = expand(seg, 3);
%             seg = log(seg);
            seg = mat2gray(seg);
            seg = imadjust(seg);
            dasp = [dasp, seg];
        end
        %dasp = mat2gray(dasp);
        %dasp = imadjust(dasp);
        [H, N] = size(dasp);
        ii = 0;
        while N > NN
            N = N-NN;
            I = [I; dasp(:, ii*NN+1:(ii+1)*NN)];
            ii = ii+1;
        end
        if N ~= 0            
            I = [I; dasp(:, ii*NN+1:end), 0*ones(H, NN-N)];
        end
        I = [I; .5*ones(2,NN)];

        %asp = [asp,dasp];
    end    
    figure(1);
    %I = asp(:,1:NN);
    %N = size(asp, 2)-NN;
    %ii = 1;
    %while N > NN
        %N = N-NN;
        %I = [I; asp(:, ii*NN+1:(ii+1)*NN)];
        %ii = ii+1;
    %end
    %I = log(I+1);
%     I = mat2gray(I);
%     I = imadjust(I);
    
    h = imagesc(I,'visible','off');
    axis xy
    colormap jet
    freezeColors
    a = get(h,'CData');
    close 
    imwrite(a, strcat(figurepath,  num2str(i), '.png'));
end


% I = mat2gray(log10(ps));
% imshow([I;~bw]);axis xy;
% for i = 1:length(on)
%     line([on(i) on(i)],[1 H]);
%     line([off(i) off(i)],[1 H]);
% end
