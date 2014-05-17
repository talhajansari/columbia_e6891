%% Script: Updates using the segments

% Talha Jawad Ansari 2014 - Contact: tja2117@columbia.edu
% Columbia University in The City of New York

% 0. Setup the environment
clear all; clc;

load('soundinfo.mat')

% N = number of soundfiles
for i=1:N,
    disp(i);
    % Save the features in .mat file
    seg_tmp = load(strcat('segments_1/',info{i,2}));
    seg_tmp = seg_tmp.Y;
    n = length(seg_tmp);
    X = cell(n,1);
    for k=1:n 
       % for each seg, calculate MFCC features
       X{k} = melcepst(seg_tmp{k}, fs); 
    end
    save(strcat('features_mfcc_1/',info{i,2}), 'X');
end




%save ('seginfo.mat', 'seg', 'labels_seg');

