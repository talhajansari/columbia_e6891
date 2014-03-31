function [cleanData, cleanLabels] = dataCleanup (rawData, rawLabels, pathToSoundfiles)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

	N = length(rawData);
    d = length(rawLabels);
    
    % Create a copy of rawData and rawLabels to be edited
    newFields = {'Size', 'Drop'}; % new fields to be added
    sz = size(rawData);
    sz(2) = sz(2) + length(newFields); % increase the columns to accomodate new fields
    
	cleanData = cell(sz);
    cleanData(:,1:d) = rawData;
    
    cleanLabels = [rawLabels, newFields];
    cleanSounds = cell(N,1);

	post_append = '_44k.wav';

	% Iterate over each soundfile (always read from rawData and write to cleanData)
	for i =1:N,
		% Filename is basically catalog number concatanated with _44k.wav
		catalog = rawData{i,2};
		filename = strcat(pathToSoundfiles, catalog, post_append);


		% 1. Add size data to rawData:
        s = dir(filename);
        fsizeKB = s.bytes/1000;
        cleanData{i,d+1} = fsizeKB;
        
        if (fsizeKB > 4000),
            cleanData{i,end} = 1;
        else
            cleanData{i,end} = 0;
        end
        
        % 3. Load the soundfiles into the system and store into a database
        if (cleanData{i,end}==0),
            sfile = audioread(filename);
            cleanSounds{i} = sfile;
        end
    end

end

