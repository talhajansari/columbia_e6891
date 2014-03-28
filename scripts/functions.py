# Reporducting Computational Results
# EECS E6891, Columbia Univeristy
# Talha Jawad Ansari

# import packages
import numpy as np
import os
import scipy as sp
import wave

debug = True


# Load and make the soundfiles name and info dataset
def csvToList(filename, dropValues=[], ignoreFirstRow=False, debug=False):
	rawData_temp = open(filename, 'r')
	rawData = [];
	for row in rawData_temp:
		row_data = row.strip().split(',')
		# Check to see if the particular recording is to be dropped
		if (row_data[1] not in dropValues):
			rawData.append(row_data)
		else:
			print('Dropped!' + str(row_data[1]))
	# Drop the first row, as it only contains labels			
	if (ignoreFirstRow):
		rawLabels = rawData.pop(0)
	else:
		rawLabels = rawData[0]
	if (debug):
		print(rawData)
	return rawData, rawLabels

def dataCleanup(rawData, rawLabels, pathToSoundfiles=''):
	# iterate over each soundfile
	N = len(rawData)
	print(N)
	post_append = '_44k.wav'

	if (debug)
		print(rawData[219])

	for i in range(N):
		if (debug)
			print(i)
		catalog = str(rawData[i][1])
		if (debug)
			print(catalog)
		filename = pathToSoundfiles + catalog + post_append

		# Do something with the files now
		# 1. Add size data to rawData:
		soundfile_size = os.stat(filename).st_size
		rawData[i].append(soundfile_size)

		# 2. Ignore soundfiles with sizes larger than 4000000 bytes (4MB)
		#if (soundfile_size > 4000000):
		#rawData.pop(i)

		# 3. Load the soundfiles into the system and store into a database
		temp_wav = wave.open(filename)
	
	rawLabels.append('size')
	return rawData, rawLabels



################### SCRIPT ###################

dropValues = ['184893'] # Catalog numbers of soundfiles to be ignored
spreadsheetName = 'ML_Order_30012802014_Mar_11_17_57_44.csv'
pathToSoundfiles='../bird_sounds_data/'

rawData, rawLabels = csvToList(spreadsheetName, dropValues=dropValues, ignoreFirstRow=True, debug=debug)
cleanData, cleanLabels = dataCleanup(rawData, rawLabels, pathToSoundfiles)


print(rawLabels)
print(rawData[0])
