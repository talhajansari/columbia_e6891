soundspath = '/media/wind/bird_sounds/';
savepath = '/media/wind/birds/';
filepath = dir(soundspath);
filepath = filepath(3:end);
name = {};
for i = 1:length(filepath)
    name = [name,filepath(i).name];
end
% len = [];
for i = 1:length(name)
%     f = [];
%     fprintf('%d %s\n', i, name{i});
    soundfiles = dir(strcat(soundspath,name{i}));
    soundfiles = soundfiles(3:end);
    if ~exist(strcat(savepath,name{i}))
        mkdir(strcat(savepath,name{i}));
    end
    for j = 1:length(soundfiles)
        f = [];
        soundfile = strcat(soundspath,name{i},'/',soundfiles(j).name);
        [y,fs] = mp3read(soundfile);
%         resample not good
%         y = resample(y, 1, 2);
%         fs = fs/2;
%         len = [len, length(y)/fs];
        n_before = 0;
        if length(f) > 0
            n_before = length(f(1,:));
        end
        data = [];
        maximum = -Inf;
        sec = 30;
        for head = 1:sec*fs:length(y)
            tail = min(head+sec*fs-1, length(y));
            [cepstra,aspectrum,pspectrum,logE, spec] = melfcc(y(head:tail), fs, 'wintime', 512/fs, 'hoptime', 512/fs/3, 'numcep', 13, 'nbands', 32, 'minfreq', .1*.5*fs, 'maxfreq', .5*.5*fs, 'useenergy', 1);
            a = struct('cep',cepstra,'as',aspectrum,'ps',pspectrum,'e',logE);
            data = [data, a];
            maximum = max(maximum, max(aspectrum(:)));            
        end
%         use a gmm model to fit the base noise level
%         base = [];
%         for k = 1:ceil(length(y)/(sec*fs))
%             base = [base, sum(data(k).as,1)];
%         end
%         base = base / maximum;
%         th = .05;
%         try
%             options = statset('MaxIter', 1000);
%             fit = gmdistribution.fit('base', 2,'CovType','diagonal','Regularize',1e-10,'Options',options); 
%             [mu,I] = sort(fit.mu);
%             sd = reshape(fit.Sigma,2,1);
%             sd = sqrt(sd(I));    
%             th = min(mu(1) + 3*sd(1), .05);
%         catch err
%             th = .05;
%             disp(err);
%         end
        th = .1; % this threshold seems works fine
        for k = 1:ceil(length(y)/(sec*fs))
            seg = segmentation(data(k).as/maximum, data(k).e, th, 800, 11, 20); %11 20
            if length(seg) > 0
                for kk = 1:length(seg(:,1))
                    f = [f, feature(data(k).cep(:,seg(kk,1):seg(kk,2)))];
                end
            end
        end
        n_end = 0;
        if length(f) > 0
            n_end = length(f(1,:));
        end
        n = n_end - n_before;
        %length(f(1,:))
        fprintf('%d %s, %d vectors, %f sec, %f sec/vec\n', i, name{i}, n, length(y)/fs, length(y)/fs/n);
        
        savefile = strcat(savepath,name{i},'/',soundfiles(j).name);
        save(strrep(savefile,'.mp3','.mat'), 'f');
        clear aspectrum base  cepstra data logE pspectrum y f
    end
%     save(strcat(savepath,naspectrumame{i},'.mat'), 'f');
%     clear f
end


%imagesc(aspectrum);


