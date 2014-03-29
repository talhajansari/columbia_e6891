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

function [cleanData, cleanLabels] = dataCleanup (rawData, rawLabels, pathToSoundfiles):
	
	% Create a copy of rawData and rawLabels to be edited
	cleanData = rawData
	cleanLabels = rawLabels
    cleanSounds = cell(N,1)

	N = length(rawData)
	post_append = '_44k.wav'

	% Iterate over each soundfile (always read from rawData and write to cleanData)
	for i =1:N,
		% Filename is basically catalog number concatanated with _44k.wav
		catalog = rawData(i,1)
		filename = strcat(pathToSoundfiles, catalog, post_append)

		% Do something with the files now

		% 1. Add size data to rawData:
		%soundfile_size = os.stat(filename).st_size # get the file size
		%cleanData[i].append(soundfile_size) 

		% 2. Ignore soundfiles with sizes larger than 4000000 bytes (4MB)
		%if (soundfile_size > 4000000):
		%rawData.pop(i)

		% 3. Load the soundfiles into the system and store into a database
        
	
	rawLabels.append('size')
	return rawData, rawLabels



################### SCRIPT ###################

dropValues = [184893] % Catalog numbers of soundfiles to be ignored
spreadsheetName = 'ML_Order_30012802014_Mar_11_17_57_44.csv'
pathToSoundfiles='../bird_sounds_data/'

rawData, rawLabels = csvToList(spreadsheetName, dropValues=dropValues, ignoreFirstRow=True, debug=debug)
cleanData, cleanLabels = dataCleanup(rawData, rawLabels, pathToSoundfiles)


print(rawLabels)
print(rawData[0])
