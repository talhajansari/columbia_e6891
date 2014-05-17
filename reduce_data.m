clear;
load('scripts/soundfileinfo.mat', 'info', 'N');

dest_dirpath = 'bird_sounds_data_reduced/'; % Path where only the required soundfiles will be stored
orig_dirpath = 'bird_sounds_data/';         % Path where all of the soundfiles are stores

%% 1.  Check/Create the directory to put files in
if exist(dest_dirpath, 'dir')==0
    mkdir(dest_dirpath);
else
   % do nothing 
end
   

%% 2. Copy the required files to the new directory

for i=1:N
    fprintf('*** i = %d\n', i);
    dest_filepath = strcat(dest_dirpath, info{i,2}, '_44k.wav');
    orig_filepath = strcat(orig_dirpath, info{i,2}, '_44k.wav');
    fprintf('Copying %s --> %s\n',orig_filepath, dest_filepath);
    
    copyfile(orig_filepath, dest_filepath);
    
end


