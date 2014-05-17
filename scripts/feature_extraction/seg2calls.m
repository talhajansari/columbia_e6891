function Y = seg2calls(audioarray, fs, savepath, makeplot)
% Write feature files of the input sound data - according to the setting, .mat
% example usage:
% gen_features(y, 32000, '1.mat');
% if no segment detected, return 0 - not sure how often it happens
% Created by Talha Ansari 2014, talhajansari@hotmail.com

head;
if nargin < 4
    makeplot = false;
end
y = audioarray;

% Smoothing
yabs = abs(y);
ys = smooth(yabs,5000);
yss = smooth(ys,5000);
yssd = diff(yss,1);
yssds = smooth(yssd, 5000);

% Indentify the segments of the audiofile by applying a threshold filter
on = [];
off = [];
t_on = false;
t_off = true;
cnt = 0;
frame = 5000;
for i=6:length(yssds)-5
    if yss(i)>=0.005 && mean(yssds(i-5:i+5)>0) && t_on==false && t_off==true
        on = [on, i];
        t_on = true;
        t_off = false;
    elseif yss(i)<=0.005 && mean(yssds(i-5:i+5)<0) && t_on==true && t_off==false && cnt>=frame
        off = [off, i];
        t_on = false;
        t_off = true;
        cnt = 0;
    end
    if t_on==true
        cnt = cnt +1;
    end
end
% if the last 'off' hasnt been found yet
if numel(off) < numel(on)
    if (length(y)-on(end))>=frame % if enough frame size
        off = [off, length(y)]; %if on has not ended, then off is the last index of the audio
    else % remove the last on (frame) altogether
        on = on(1:end-1);
    end
end

if makeplot==true;
    maxy = max(yss);
    tmpon = zeros(length(y),1);
    tmpoff = zeros(length(y),1);
    for i=1:length(tmpon)
       if ~isempty(find(on==i, 1))
           tmpon(i) = maxy;
       end
       if ~isempty(find(off==i, 1))
           tmpoff(i) = maxy;
       end
    end
    t = [1:1:numel(y)];

    figure(1);
    subplot(211);
    plot(t, yss);
    ylabel('amplitude');
    hold on;
    plot(t,tmpon, 'g');
    plot(t, tmpoff, 'r');
    
%     subplot(212);
%     plot(t(2:end), yssds(1:end));
%     hold on;
%     plot(zeros(numel(t)-1,1),'r');
%     ylim([-0.00005 0.00005]);
%     ylabel('amplitude');
%     xlabel('time, arbitrary units');
end

% Break the audio into segments and generate Mel-FC Coefficients
Y = cell(length(on),1);
for k = 1:length(on)
    Y{k} = y(on(k):off(k));
end

save(savepath, 'Y');
