# Reporducting Computational Results
# EECS E6891, Columbia Univeristy
# Talha Jawad Ansari

# import packages
import numpy as np
import os
import scipy as sp
import wave
from scipy.io import wavfile
#import scikits
#from scikits.audiolab import Sndfile
import struct



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
	
	# Create a copy of rawData and rawLabels to be edited
	cleanData = rawData
	cleanLabels = rawLabels

	N = len(rawData)
	if (debug):
		print(N)
	if (debug):
		print(rawData[219])

	post_append = '_44k.wav'

	# Iterate over each soundfile (always read from rawData and write to cleanData)
	for i in range(N):
		# Filename is basically catalog number concatanated with _44k.wav
		catalog = str(rawData[i][1])
		if (debug):
			print(catalog)
		filename = pathToSoundfiles + catalog + post_append

		# Do something with the files now

		# 1. Add size data to rawData:
		soundfile_size = os.stat(filename).st_size # get the file size
		cleanData[i].append(soundfile_size) 

		# 2. Ignore soundfiles with sizes larger than 4000000 bytes (4MB)
		#if (soundfile_size > 4000000):
		#rawData.pop(i)

		# 3. Load the soundfiles into the system and store into a database

		ifile = wave.open(filename)
		nf = ifile.getnframes() 
		sampwidth = ifile.getsampwidth()
		fmts = (None, "=B", "=h", None, "=l")
		fmt = fmts[sampwidth]
		dcs  = (None, 128, 0, None, 0)
		dc = dcs[sampwidth]

		rf = ifile.readframes(nf) 
		ifile.close() 
		data = struct.unpack("%sh" %nf,rf) 
		for i in range(2000): 
			print i,data[i] 


		# f = Sndfile(filename, 'r')
		# # Sndfile instances can be queried for the audio file meta-data
		# fs = f.samplerate
		# nc = f.channels
		# enc = f.encoding
		# # Reading is straightfoward
		# data = f.read_frames(1000)
		# This reads the next 1000 frames, e.g. from 1000 to 2000, but as single precision
		# data_float = f.read_frames(1000, dtype=np.float32)

		# w = wave.open(filename, 'r')
		# w2 = sp.io.wavfile.read(filename)
		# print('**********************************************************************************')
		# print(w2)
		# break
	
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
