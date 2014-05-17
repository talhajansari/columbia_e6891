%% Script: Updates using the segments

% Talha Jawad Ansari 2014 - Contact: tja2117@columbia.edu
% Columbia University in The City of New York

% 0. Setup the environment
clear all; clc;

load('soundinfo.mat')

seg = {};
labels_seg = [];

for i=1:N,
    disp(i);
    seg_tmp = load(strcat('segments_1/',info{i,2}));
    seg_tmp = seg_tmp.Y;
    
    % generate one big segment array
    % seg = [seg; seg_tmp];
    % generate variables
    labels_seg(end+1:end+length(seg_tmp)) = labels(i);
end




%save ('seginfo.mat', 'seg', 'labels_seg');

