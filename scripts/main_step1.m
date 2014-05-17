%% Script: Selects the soundfiles to include in the classifier, and uses seg2calls 
% function to break the soundfiles in calls, uses seg2pulses to break down
% calls into pulses. Saves the calls and pulses data as .mat files, generates
% MFCC coefficients for both calls and pulses and saves them in .mat files. 

% Talha Jawad Ansari 2014 - Contact: tja2117@columbia.edu,
% talhajansari@hotmail.com
% Columbia University in The City of New York


%% 0. Setup the environment
clear all; clc;
addpath(genpath('feature_extraction'))
addpath(genpath('utils'))
addpath(genpath('voicebox'))

% Directories for save paths
dirs_all = {'dir_calls_1/','dir_pulses_1/', 'dir_feat_calls_mfcc_1/','dir_feat_pulse_mfcc_1/', 'dir_feat_calls_other_1/','dir_pulses_calls_other_1/', 'dir_pulses_calls_1/'};
for i=1:length(dirs_all)
    if exist(dirs_all{i},'dir')==0
        mkdir(dirs_all{i});
    end
end     
dir_calls = dirs_all{1};
dir_pulses = dirs_all{2};
dir_mfcc_calls = dirs_all{3};
dir_mfcc_pulses = dirs_all{4};
dir_otherfeat_calls = dirs_all{5};
dir_otherfeat_pulses = dirs_all{6};
dir_pulses_calls = dirs_all{7};
% Variables
fs = 30000;

%% 1. Load the info about the soundfiles from the .CSV (provided by Macaulay
% library and select which files to continue with
dropValues = [184893, 25606]; % catalog numbers of corrupt soundfiles - to be ignored
spreadsheetName = 'ML_Order_30012802014_Mar_11_17_57_44.csv';
pathToSoundfiles='../bird_sounds_data/';
[rawInfo, rawLabels] = csvToList(spreadsheetName, dropValues);
[rawInfo2, rawHeaders2, include, rawLabels2, rawFsizeMB, rawFilepath] = dataCleanup(rawInfo, rawLabels, pathToSoundfiles, 10);
rawN = length(rawLabels2);
rawD = length(rawHeaders2);

disp(strcat('- Out of',' ',int2str(rawN),', ',int2str(sum(include)),' sound files will be used'));

%% 3. Remove the files which have been marked for removal 
N = sum(include);
D = rawD;
headers = rawHeaders2;
info = cell(N,D);
labels_files = zeros(N,1);
filepath = cell(N,1);
map2raw = zeros(N,1); % which index in new data correponds to which index in the old data
cnt = 1;
for i=1:rawN,
   if include(i)==1,
      info(cnt,:) = rawInfo2(i,:); 
      labels_files(cnt) = rawLabels2(i);
      filepath(cnt) = rawFilepath(i);
      map2raw(cnt) = i;
      cnt = cnt + 1;
   end  
end
species = {'Great Antshrike', 'Dusky Antbird', 'Barred Antshrike'};
cnt_species = zeros(3,1);
cnt_species(1) = sum(labels_files==1);
cnt_species(2) = sum(labels_files==2);
cnt_species(3) = sum(labels_files==3);

% Display Info:
for i=1:length(species)
    disp(strcat('- ',' ',species(i),':',' ',int2str(cnt_species(i)),' files'));
end
save('soundfileinfo.mat','info', 'labels_files', 'filepath', 'map2raw', 'species', 'cnt_species', 'fs', 'N', 'D', 'dirs_all', 'include');

%% 4. Segment soundfiles, generate features for all the segment soundfiles, save the segments and features in .mat files

% Load or build filter for pre-processing
if exist('filter.mat', 'file')==0
    buildfilters(fs);
end
load('filters.mat')

calls_all = {};
labels_calls = [];
labels_pulses = [];
for i=1:N,
    disp(strcat(' ', num2str(i/N),'%','complete'));
    %disp(strcat('- In File:',int2str(i),'/',int2str(N)));
    % Break sound into Calls
    if exist(strcat(dir_calls,info{i,2},'.mat'), 'file')==0     % before loading the soundfile, see if is already loaded and saved into .mat before
        [y, fs_orig] = soundread(filepath{i}, 'wav');
        % Downsample
        y = resample(y, fs, fs_orig);
        y = y(fs*4:end); % Remove the first 4 seconds of the recording
        % Pass through the filters        
        if (labels_files(i)==1)
            y = filter(HL1,y);
            y = filter(HH1,y);
        elseif labels_files(i)==2
            y = filter(HL2,y);
            y = filter(HH2,y);
        elseif labels_files(i)==3
            y = filter(HL3,y);
            y = filter(HH3,y);
        end    
        calls = seg2calls(y, fs, strcat(dir_calls,info{i,2}));  % Segment recordings into calls
    else
        calls = load(strcat(dir_calls,info{i,2},'.mat'));       
        calls = calls.Y; %Y is the variable name underwhich the calls are stores in the .mat file
    end
    N_calls = numel(calls);
    %disp(strcat('- - # Calls generated: ',int2str(N_calls)));
    labels_calls(end+1:end+N_calls,1) = labels_files(i);
    mfcc_calls = cell(N_calls,1);                                   
    pulses_calls = cell(N_calls,1);
    for j=1:numel(calls) % For each call
        %disp(strcat('- - - In Call:',int2str(j),'/',int2str(N_calls)));
        if exist(strcat(dir_mfcc_calls, info{i,2},'.mat'), 'file')==0 
            mfcc_calls{j} = melcepst(calls{j}, fs);         % find the MFCC          
        else
            % load the .mat file - no need to load actually
        end
        
        % Break each call into pulses
        if exist(strcat(dir_pulses_calls, info{i,2},'_',int2str(j),'.mat'), 'file')==0   
            pulses = seg2pulse(calls{j}, fs, 1000, dir_pulses_calls, false, 'segment');
            Y=pulses;
            save(strcat(dir_pulses_calls, info{i,2},'_',int2str(j),'.mat'), 'Y');
        else
            pulses = load(strcat(dir_pulses_calls, info{i,2},'_',int2str(j),'.mat'));
            pulses = pulses.Y;
        end
        N_pulses = numel(pulses);
        pulses_calls{j} = pulses;
        %disp(strcat('- - - # Pulses generated: ',int2str(N_pulses)));
        labels_pulses(end+1:end+length(calls),1) = labels_calls(j);
        
        % For each pulse, find MFCC
        mfcc_pulses = cell(N_pulses,1);         % MFCC
        
        if exist(strcat(dir_mfcc_pulses, info{i,2},'_',int2str(j),'.mat'), 'file')==0 
            for k=1:N_pulses
                %disp(strcat('- - - - In Pulse:',int2str(k),'/',int2str(N_pulses)));
                mfcc_pulses{k} = melcepst(pulses{k}, fs);
            end
            X = mfcc_pulses;
            save(strcat(dir_mfcc_pulses, info{i,2},'_',int2str(j),'.mat'), 'X');
        else
           % do nothing
        end
    end
    Y = pulses_calls;
    save(strcat(dir_pulses,info{i,2},'.mat'), 'Y');
    X = mfcc_calls;
    save(strcat(dir_mfcc_calls, info{i,2},'.mat'), 'X');
end
   
save ('seginfo.mat', 'labels_calls','labels_pulses');


%% 5. The rest of the analysis, feature processing and .csv generation is carried out in Python 'main_step2.py'
    % *** Please run main_step2.py

%% 6. Classification (1,2,3 out of 5 approaches)

    % Open Weka Software> Explorer> OpenFile> Select: 'features_nom_revised.csv'
    
    % In Weka, go to Tab: Classification>Classifier>Open> Select:
    % 'classifier/trees/id3; -> Start. Note down the accuracy
    % *** IMPORTANT *** Copy the tree from the output of Weka (only the
    % tree) and save it in new 'tree_id3.txt' file.
    
    % In Weka, go to Tab: Classification>Classifier>Open> Select:
    % 'classifier/trees/j48; -> Start. Note down the accuracy
    % *** IMPORTANT *** Copy the tree from the output of Weka (only the
    % tree) and save it in new 'tree_j48.txt' file.
    
    % In Weka, go to Tab: Classification>Classifier>Open> Select:
    % 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
    

%% 7. Dimensionality Reduction, carried out in Python script 'main_step3.py'
    % Please run main_step3.py to create two new .csv files, with reduced
    % datasets using ID3 and J4.8. The the new datasets are named
    % 'features_nom_id3.csv' and 'features_nom_j48.csv'

%% 8. Classification again!
    % Open Weka Software> Explorer> OpenFile> Select: 'features_nom_id3.csv'
    % In Weka, go to Tab: Classification>Classifier>Open> Select:
    % 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
    
    % Open Weka Software> Explorer> OpenFile> Select: 'features_nom_j48.csv'
    % In Weka, go to Tab: Classification>Classifier>Open> Select:
    % 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy


    
    
