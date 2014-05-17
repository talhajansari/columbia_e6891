# STEP 2 of the E6891 Reproducution Page - To be run only after the succesull running of STEP 1, main_step1.m 
# Written by Talha Ansari for EECSE6891, Columbia University. May 2014.
# talhajansari@hotmail.com

#!/usr/bin/python
import numpy as np
import time
import os
from scipy import stats
from scipy.io import loadmat
from scipy.ndimage import measurements
import matplotlib.pyplot as plt
from custom_methods import *
from important_functions import *


TYPE = 'P' # Leave this to type 'P', meaning that we are using pulse level features. The other value, 'C' for calls has not been tested

##  Load info about the sound files
soundinfo = loadmat('soundfileinfo', variable_names=['info','filepath', 'labels_files', 'dirs_all'])
info = soundinfo['info']
filepath = soundinfo['filepath']
labels_old = soundinfo['labels_files']
dirs_all = soundinfo['dirs_all']
dirs_all = dirs_all[0]
N = len(info)
N_files = N
print ("Number of files: %d" %(N));
catalog = []
for i in range(N):
	catalog.append(info[i][1][0])

## Load calls features into Python
calls_perfile = [0]*N
features_calls = []
labels_calls = []
for i in range(N):
	x = get_feature(dirs_all[2][0]+str(catalog[i])+'.mat', debug=False)
	calls_perfile[i] = len(x)
	for call in x:
		features_calls.append(call)
		labels_calls.append(labels_old[i][0])
N_calls = len(features_calls)
D_calls = len(features_calls[0])
print ("Number of calls: %d" %(N_calls)); 

if TYPE=='C':
	features = features_calls
	labels = labels_calls
	file_name = 'features_nom_calls.csv'
elif TYPE=='P':
	## Load pulses features into Python
	features_pulses = []
	audio_pulses = []
	labels_pulses = []
	for i in range(N):
		for j in range(calls_perfile[i]):
			call_ffreq, call_ffreq_lasthalf = fundFreq(dirs_all[6][0]+str(catalog[i])+'_'+str(j+1)+'.mat') #dominant freq vector, and mean of dominant freq in the last half of call
			num_pulses = len(call_ffreq) # number of pulses in a call
			x = get_feature(dirs_all[3][0]+str(catalog[i])+'_'+str(j+1)+'.mat', debug=False) # MFCC features
			for k in range(len(x)):
				pulse_feat = x[k].tolist()
				pulse_feat.append(call_ffreq[k]) # fundamental freq
				pulse_feat.append(call_ffreq_lasthalf) # fundamental freq of last half of call
				pulse_feat.append(num_pulses) # number of pulse
				features_pulses.append(pulse_feat)
				labels_pulses.append(labels_old[i][0])
	N_pulses = len(features_pulses)
	D_pulses = len(features_pulses[0])
	print ("Number of pulses: %d" %(N_pulses)); 
	features = features_pulses
	labels = labels_pulses
	file_name = 'features_nom_pulses.csv'

## Carry out Vector Quantization (function defined in custom_methods.py) and save the features in a .csv file
features_nom = vectorQuantization(features, bits=6)
writeToCSV(file_name, data=features_nom, labels=labels, incldueheaders=True)


## Carry out RATIO fixing in the dataset
data_raw, headers_raw = CSVToList (pathToCSV='features_nom_pulses.csv', seperator=",", header=True, debug=False)
data = data_raw
headers = headers_raw
labels = getColumn(data_in=data, ind=len(data[0])-1)
N = len(labels)
D = len(data[0])

ratio = [0, 21, 5, 0.9]
cnt = countByClass(labels)
print ("Initial count per class is: " + str(cnt))
num_1 = cnt[1]
num_2 = int((cnt[1]/ratio[1])*ratio[2])
num_3 = int((cnt[1]/ratio[1])*ratio[3])
num_req = [0, num_1, num_2, num_3]
print ("Number required is: " + str(num_req))

# Code to maintain 21:9:0.9 ratio between species
data_split = [[], [],[],[]]
for row in data:
	lab = int(row[D-1])
	data_split[lab].append(row)

data_new = data_split[1]
data_sp2 = data_split[2]
cnt = 0
N_s2 = len(data_sp2) # is changed in the loop
for i in range(num_2):
	r = randint(0,N_s2-1)
	data_new.append(data_sp2.pop(r))
	cnt = cnt + 1
	N_s2 = N_s2 - 1

data_sp3 = data_split[3]
cnt = 0
N_s3 = len(data_sp3) # is changed in the loop
for i in range(num_3):
	r = randint(0,N_s3-1)
	data_new.append(data_sp3.pop(r))
	cnt = cnt + 1
	N_s3 = N_s3 - 1

labels_new = getColumn(data_in=data_new, ind=D-1)
data_new
cnt_new = countByClass(labels_new)
print ("Revised count per class is: " + str(cnt_new))
writeToCSV('features_nom_revised.csv', data=data_new, labels=labels_new, incldueheaders=True, headers=headers, labelsincluded=True)


## Plot vector quantization plots
x_list = np.array(features)
x_list_nom = np.array(features_nom)
Fig21 = plt.figure(21)
ax = Fig21.add_subplot(211)
ax.set_title('original signal')
ax.plot(x_list[1:500,3], c='b')
ax.set_ylabel('value')
bx = Fig21.add_subplot(212)
bx.plot(x_list_nom[1:500,3], c='g')
bx.set_title('quantized signal')
bx.set_xlabel('sample')
bx.set_ylabel('value')

plt.savefig('vectorquanitization_fig.png')


