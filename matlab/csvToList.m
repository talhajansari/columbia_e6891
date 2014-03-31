%% Reproducing Computational Research

%% Read the CSV file
%% Load and make the soundfiles name and info dataset
function [rawData, rawLabels] = csvToList(filename, dropValues, ignoreFirstRow, debug):
	fid = fopen(filename, 'r')
    C = textscan(fid, repmat('%q',1,33), 'delimiter',',', 'CollectOutput',true);
    rawData = cell2mat(C{1})
    rawLabels = rawData(1,:)
	rawData(1,:) = [];
    
    % Remove the entries which are listed in dropped values
    for i=1:length(dropValues),
        drop = dropValues(i)
        catalog = rawData(:,2)
        index = find(strcmp(catalog,num2str(drop)))
        rawData(index,:) = []
    end
end

function [cleanData, cleanLabels] = dataCleanup (rawData, rawLabels, pathToSoundfiles)
	
	N = length(rawData)
    d = length(rawLabels)
    
    % Create a copy of rawData and rawLabels to be edited
    newFields = {'Size', 'Drop'} % new fields to be added
    sz = size(rawData)
    sz(2) = sz(2) + length(newFields) % increase the columns to accomodate new fields
    
	cleanData = cell(sz);
    cleanData(:,1:d) = rawData;
    
    cleanLabels = [rawLabels, newFields];
    cleanSounds = cell(N,1);

	post_append = '_44k.wav'

	% Iterate over each soundfile (always read from rawData and write to cleanData)
	for i =1:N,
		% Filename is basically catalog number concatanated with _44k.wav
		catalog = rawData{i,2};
		filename = strcat(pathToSoundfiles, catalog, post_append);


		% 1. Add size data to rawData:
        s = dir(filename)
        fsizeKB = s.bytes/1000
        cleanData{i,d+1} = fsizeKB
        
        if (fsizeKB > 4000),
            cleanData(i,end) = 1;
        else
            cleanData(i,end) = 0;
        end
        
        % 3. Load the soundfiles into the system and store into a database
        if (cleanData(i,end)==0),
            sfile = audioread(filename);
            cleanSounds(i) = sfile;
        end
    end
end
	

% ################### SCRIPT ###################

dropValues = [184893] % Catalog numbers of soundfiles to be ignored
spreadsheetName = 'ML_Order_30012802014_Mar_11_17_57_44.csv'
pathToSoundfiles='../bird_sounds_data/'

rawData, rawLabels = csvToList(spreadsheetName, dropValues=dropValues, ignoreFirstRow=True, debug=debug)
cleanData, cleanLabels = dataCleanup(rawData, rawLabels, pathToSoundfiles)


print(rawLabels)
print(rawData[0])
