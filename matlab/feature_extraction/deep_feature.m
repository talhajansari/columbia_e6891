soundspath = '/media/wind/bird_sounds/';
savepath = '/media/wind/bird_deep/';
filepath = dir(soundspath);
filepath = filepath(3:end);
name = {};
for i = 1:length(filepath)
    name = [name,filepath(i).name];
end
len = [];
for i = 1:5%length(name) 
    f = {};
%     fprintf('%d %s\n', i, name{i});
    soundfiles = dir(strcat(soundspath,name{i}));
    soundfiles = soundfiles(3:end);
    for j = 1:length(soundfiles)
        soundfile = strcat(soundspath,name{i},'/',soundfiles(j).name);
        [y,fs] = mp3read(soundfile);
        %y = resample(y, 1, 2);
        %fs = fs/2;
        len = [len, length(y)/fs];
        n_before = 0;
        if length(f) > 0
            n_before = length(f(1,:));
        end
        data = [];
        maximum = -Inf;
        sec = 30;
        % get spec per 30s
        for head = 1:sec*fs:length(y)
            tail = min(head+sec*fs-1, length(y));
            [cepstra,aspectrum,pspectrum,logE, spec] = melfcc(y(head:tail), fs, 'wintime', 512/fs, 'hoptime', 512/fs/3, 'numcep', 13, 'nbands', 64, 'minfreq', .1*.5*fs, 'maxfreq', .5*.5*fs, 'useenergy', 1);
            a = struct('cep',cepstra,'as',aspectrum,'ps',pspectrum,'e',logE,'s',spec);
            data = [data, a];
            maximum = max(maximum, max(aspectrum(:)));            
        end
        th = .1;
        % segmentation
        for k = 1:ceil(length(y)/(sec*fs))
            seg = segmentation(data(k).as/maximum, data(k).e, th, 800, 11, 20); %11 20
            if length(seg) > 0
                for kk = 1:length(seg(:,1))
                    f = [f, data(k).as(:,seg(kk,1):seg(kk,2))];
                end
            end
        end
        n_end = 0;
        if length(f) > 0
            n_end = length(f(1,:));
        end
        n = n_end - n_before;
        %length(f(1,:))
        fprintf('%d %s, %d vectors, %f sec, %f vec/sec\n', i, name{i}, n, length(y)/fs, length(y)/fs/n);
        clear aspectrum base  cepstra data logE pspectrum y
    end
    save(strcat(savepath,name{i},'.mat'), 'f');
    clear f
end


imagesc(aspectrum);
data = [];
for i = 1:5%length(name) 
    load(strcat(savepath,name{i},'.mat'));
    data = [data, f];
end
save('~/bird/data.mat', 'data');