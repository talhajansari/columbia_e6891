function [rawData, rawLabels] = csvToList(filename, dropValues)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    fid = fopen(filename, 'r');
    C = textscan(fid, repmat('%q',1,33), 'delimiter',',', 'CollectOutput',true);
    rawData = C{1};
    rawLabels = rawData(1,:);
	rawData(1,:) = [];
    
    % Remove the entries which are listed in dropped values
    for i=1:length(dropValues),
        drop = dropValues(i);
        catalog = rawData(:,2);
        index = find(strcmp(catalog,num2str(drop)));
        rawData(index,:) = [];
    end

end

