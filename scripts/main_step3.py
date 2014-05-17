# STEP 3 of the E6891 Reproducution Page - To be run only after the succesull running of STEP 1 (main_step1.m ) and STEP 2 (main_step2.py)
# Written by Talha Ansari for EECSE6891, Columbia University. May 2014.
# talhajansari@hotmail.com
# Python script to check to which features were included by the ID3 and J4.8

import csv
from important_functions import *
from custom_methods import *


data, headers = CSVToList (pathToCSV='features_nom_pulses.csv', seperator=",", header=True, debug=False)
D = len(headers)
labels = getColumn(data, D-1)

feat_id3 = []
for i in range(D):
	feat = 'F'+str(i+1)+' '
	if stringInFile(feat, 'tree_id3.txt'): 
		feat_id3.append(feat[:-1])
print ("# %d Features used by ID3: " %len(feat_id3)) + str(feat_id3)


feat_j48 = []
for i in range(D):
	feat = 'F'+str(i+1)+' '
	if stringInFile(feat, 'tree_j48.txt'): 
		feat_j48.append(feat[:-1])
print ("# %d Features used by J48: " %len(feat_j48)) + str(feat_j48)


# csvfile = open('reduced_features.csv', 'wb')
# writer = csv.writer(csvfile, delimiter=',', quotechar='\'', quoting=csv.QUOTE_NONNUMERIC)
# writer.writerow(feat_used_id3)
# writer.writerow(feat_used_j48)


data_id3, header_id3 = keepFeatures (data=data, headers=headers, keep_features=feat_id3)
data_j48, header_j48 = keepFeatures (data=data, headers=headers, keep_features=feat_j48)

assert(len(header_id3) == len(data_id3[0]))
assert(len(header_j48) == len(data_j48[0]))

writeToCSV('features_nom_id3.csv', data=data_id3, labels=labels, incldueheaders=True, headers=header_id3)
writeToCSV('features_nom_j48.csv', data=data_j48, labels=labels, incldueheaders=True, headers=header_j48)