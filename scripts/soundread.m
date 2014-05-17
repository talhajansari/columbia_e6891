function [ y, fs ] = soundread(filepath, type)
%SOUNDREAD Reads the sound file available at 'filepath' and returns a array
%and the sampling rate Fs.

head;

% Load the soundfile in Matlab
if strcmp(type, 'mp3')
    [y,fs] = mp3read(filepath,'double',1);
elseif strcmp(type, 'wav')
    [y,fs] = audioread(filepath);
    if size(y,2) == 2
        y = (y(:,1)+y(:,2))/2;
    end
else
    error('unknow type');
end

end

