function [newData, newHeaders, include, rawLabels, fsizeMB, filenames] = dataCleanup (oldData, oldHeaders, pathToSoundfiles, sizelimit, genrep)
%Does preprocessing on the rawData info to analyze which files to 
%include and which to not. All files above the size limit are ignored. Also
%returns the column vectors 'size', 'filepath' and the boolean column
%vector 'include', which tells whether the file is to be included in the
%final experiment or not. Also adds the columns 'size' and 'filepath' to
%the info data and the corresponding headers.
%   Talha Jawad Ansari, 2014 
%   Columbia University
%   talhajansari@hotmail.com

	N = length(oldData); 
    d = length(oldHeaders);
    
    % Create a copy of rawData and rawLabels to be edited
    newFields = {'size', 'filepath'}; % new fields to be added
    sz = size(oldData);
    sz(2) = sz(2) + length(newFields); % increase the columns to accomodate new fields
    
	newData = cell(sz);
    newData(:,1:d) = oldData;
    
    newHeaders = [oldHeaders , newFields];
    include = zeros(N,1);
    post_append = '_44k.wav';
    
    labels_str = cell(N,1);
    rawLabels = zeros(N,1);
    fsizeMB = zeros(N,1);
    filenames = cell(N,1);
    
    avg_size = zeros(3,1);
    avg_length = zeros(3,1);
   
	% Iterate over each soundfile (always read from rawData and write to cleanData)
    for i =1:N,
        %  Generate clean and usable 'labels'
        labels_str{i} = newData{i,4};    
        if (~isempty(strfind(labels_str{i}, 'Great Antshrike')))
           rawLabels(i) = 1; 
        elseif (~isempty(strfind(labels_str{i}, 'Dusky Antbird')))
           rawLabels(i) = 2; 
        elseif (~isempty(strfind(labels_str{i}, 'Barred Antshrike')))
           rawLabels(i) = 3; 
        elseif (~isempty(strfind(oldData{i,3}, 'Cercomacra'))) % Dusky Antbird
               rawLabels(i) = 2; 
        elseif (~isempty(strfind(oldData{i,3}, 'Thamnophilus'))) % Barred Antshrike
               rawLabels(i) = 3;
        else
           rawLabels(i) = 0;
           disp(labels_str(i));
           disp(oldData{i,3});
        end 
    
		% Generate 'filename' which is basically catalog number concatanated with _44k.wav
		catalog = newData{i,2};
		filename = strcat(pathToSoundfiles, catalog, post_append);
        filenames{i} = filename;
        newData{i, d+2} = filename;

		% Ganerate 'size' column
        s = dir(filename);
        fsizeMB(i) = s.bytes/(1e+6);
        newData{i,d+1} = fsizeMB(i);
        
        % Generate 'include' column
        if (fsizeMB(i) > sizelimit),
            include(i) = 0;
        else
            include(i) = 1;
        end 
        
        % Statistics
        avg_size(rawLabels(i)) = (avg_size(rawLabels(i))*(i-1) + fsizeMB(i))/i;
    end
    
    %disp(avg_size);

end

