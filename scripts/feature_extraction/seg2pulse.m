function Y = seg2pulse(audioarray, fs, frame, savepath, makeplot, inputtype)
% Write feature files of the input sound data - according to the setting, .mat
% example usage:
% gen_features(y, 32000, '1.mat');
% if no segment detected, return 0 - not sure how often it happens
% Created by Talha Ansari 2014, talhajansari@hotmail.com

if (nargin < 5)
    makeplot = false;
end
if (nargin < 6)
    inputtype = 'recording';
end

%head;
y = audioarray;

% Smoothing
yabs = abs(y);
ys = smooth(yabs,frame);
yss = smooth(ys,frame);
yssd = diff(yss);
yssds = smooth(yssd, frame); %smooth(yssd, frame);

% Indentify the segments of the audiofile by applying a threshold filter
on = [];
off = [];
t_on = false;
t_off = true;
cnt = 0;
% if strcmp(inputtype,'segment')
%     t_on = true;
%     t_off = false;
%     %cnt=frame;
% end


%frame = 1000;
meany = mean(yss);

for i=6:length(yssds)-5
    % the frame size for end elements gives out of array index error
    if (numel(yss)-i) < frame
        win = numel(yss) - i;
    elseif (i<=frame)
        win = i-1;
    else
        win = frame;
    end
    % check for starting points
    p = round(win)-1;
    
    A = yss(i)<mean(yss(i:i+win));
    B = mean(yss(i-win:i)) < mean(yss(i-win:i+win));
    C = mean(yss(i:i+win)) > mean(yss(i-win:i+win));
    % check for ending point
    D = yss(i)<mean(yss(i-win:i));
    E = mean(yssds(i-p:i+p)<0);
    
    if A && B && C && t_on==false && t_off==true
        on = [on, i];
        t_on = true;
        t_off = false;
    elseif D && B && C && t_on==true && t_off==false && cnt>=frame
        off = [off, i];
        t_on = false;
        t_off = true;
        cnt = 0;
    end
    if t_on==true
        cnt = cnt +1;
    end
end
%disp(meany);
if isempty(on) || isempty(off)
    Y = {};
    Y = [Y; y];
    return
end

% if the last 'off' hasnt been found yet
if numel(off) < numel(on)
    if (length(y)-on(end))>=frame % if enough frame size
        off = [off, length(y)]; %if on has not ended, then off is the last index of the audio
    else % remove the last on (frame) altogether
        on = on(1:end-1);
    end
end

%if we are segmenting a call into pulses, we need off[i] and on[i] same
if strcmp(inputtype,'segment')
    for i=1:numel(on)-1,
       midd = round(mean([on(i+1),off(i)]));
       on(i+1) = midd;
       off(i) = midd;
    end
    off(end) = numel(y);
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

    figure(2);
    %subplot(211);
    plot(t, y);
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
X = cell(length(on),1);
for k = 1:length(on)
    Y{k} = y(on(k):off(k));
end

%save(savepath, 'Y');
