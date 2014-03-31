
debug = true;
dropValues = [184893]; % Catalog numbers of soundfiles to be ignored;
spreadsheetName = 'ML_Order_30012802014_Mar_11_17_57_44.csv';
pathToSoundfiles='../bird_sounds_data/';

[rawData, rawLabels] = csvToList(spreadsheetName, dropValues, debug);
[cleanData, cleanLabels] = dataCleanup(rawData, rawLabels, pathToSoundfiles);


disp(rawLabels)
disp(rawData(1,:))
