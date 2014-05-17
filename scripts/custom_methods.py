#!/usr/bin/python
from __future__ import division
from numpy.fft import rfft, irfft
from numpy import argmax, sqrt, mean, diff, log
from matplotlib.mlab import find
from scipy.signal import blackmanharris, fftconvolve
from time import time
import sys
from parabolic import parabolic
import numpy as np
import time
import os
from scipy import stats
from scipy.io import loadmat
from scipy.ndimage import measurements
import matplotlib.pyplot as plt

# Functions written by Talha Ansari for EECSE6891, Columbia University. May 2014.
# talhajansari@hotmail.com


# FUNCTION: Written by Jingwei Zhang (2014). Edited by Talha Ansari (2014)
def gen_feature_mfcc(x, debug=False):
	d = len(x[0])
	if debug: print (" - - entering gen_feature_mfcc")
	v = x[:,0:d-1] # the last column is 0, ignore it
	if np.isnan(v).any() or np.isinf(v).any():
		raise Exception('MFCC contains Nan of Inf')
	xn, (xmin, xmax), xmean, xvar, xskew, xkurt =  stats.describe(v)
	if debug: print stats.describe(v)
	d = np.diff(v, 1, 0)
	dmean = np.mean(d, 0)
	x = np.concatenate((xmean,xmin,xmax,xvar,dmean))
	if np.isnan(x).any() or np.isinf(x).any():
		raise Exception('Feature vector contains Nan of Inf')
	return x

# FUNCTION: Written by Jingwei Zhang (2014). Edited by Talha Ansari (2014)
def get_feature(mat_file, debug=False):
	if debug: print (" - - entering gen_feature")
	if debug: print (" - - - Loading %s" %(mat_file))
	if not os.path.isfile(mat_file):
		raise Exception('No feature file found, probably no segment detected')
	if debug: print (" - - - Loading %s" %(mat_file))
	data = loadmat(mat_file, variable_names=['X'])['X']
	if debug: print len(data)
	data = [x[0] for x in data]
	feature = []
	for x in data:
		xx = gen_feature_mfcc(x)
		feature.append(xx)
	if len(feature) == 0:
		#raise Exception('No features, probably no segment detected')
		return []
	return feature



# FUNCTION: Takes the feature vector (data) and the labels (labels) to produce and save a .csv file with the
# values, and the last column as the labels. Having includeheaders=True gives numbered-names to the features.
def writeToCSV(filename, data, labels, incldueheaders=False, headers=None, labelsincluded=False, debug=False):
	import csv
	D = len(data[0])
	if incldueheaders and headers is None:
		headers = []
		for i in range(D):
			headers.append('F'+str(i+1))
		if not labelsincluded: headers.append('specie')
	elif incldueheaders and headers is not None:
		headers = headers
		if not labelsincluded: headers.append('specie')
	csvfile = open(filename, 'wb')
	writer = csv.writer(csvfile, delimiter=',', quotechar='\'', quoting=csv.QUOTE_NONNUMERIC)
	if incldueheaders:
		writer.writerow(headers)
	for i in range(len(data)):
		if debug: print (i)
		line = list(data[i])
		# print line
		if not labelsincluded:
			line.append(str(labels[i]))
		writer.writerow(line)

# FUNCTION: Vector Quantitzation - Carries out Vector Quantization 
# RETURNS: Feature data with numeric values replaced by nominal values
def vectorQuantization (features, bits, debug=False):
	from scipy.cluster.vq import vq
	D = len(features[0])
	np_features = np.array(features)
	nom_features = np.empty(np_features.shape, dtype=str)
	for i in range(D):
		column = np_features[:,i]
		max_val = np.max(column)
		min_val = np.min(column)
		bits = bits
		denom = bits
		step = (max_val - min_val)/denom
		partition = [0]*(denom+1)
		codebook = [0]*(denom+1)
		for j in range(denom+1):
			partition[j] = (min_val+(step*j))
			codebook[j] = j
		column = np.array(column)
		partition = np.array(partition)
		if debug:
			print('****')
			print(column)
			print(partition)
		tmp = vq(column,partition)
		nom_col = [str(int(x)+1) for x in tmp[0]]
		if debug:
			print tmp[0]
			print nom_col
			print '****'
		nom_features[:,i] = nom_col
	return nom_features


# FUNCTION: Finds the fundamental frequency of the given signal. Written by 'endolith', available at https://gist.github.com/endolith/255291
def freq_from_fft(signal, fs):
    """Estimate frequency from peak of FFT
    
    """
    # Compute Fourier transform of windowed signal
    windowed = signal * blackmanharris(len(signal))
    f = rfft(windowed)
    
    # Find the peak and interpolate to get a more accurate peak
    i = argmax(abs(f)) # Just use this for less-accurate, naive version
    true_i = parabolic(log(abs(f)), i)[0]
    
    # Convert to equivalent frequency
    return fs * true_i / len(windowed)

# FUNCTION: Calls the main brain in the custom_methods.py file - finds the fundamental frequency and the related features of the data
def fundFreq (filepath, fs=30000):
	pulses_call = loadmat(filepath, variable_names=['Y'])['Y']
	N_pulses = len(pulses_call)
	if N_pulses == 0: return []
	#print pulses_call
	pulses_ffreq = []
	for pulse_t in pulses_call:
		#print len(pulse_t)
		pulse_t = pulse_t[0]
		#print len(pulse_t)
		pulse = []
		#print pulse_t
		for elem in pulse_t:
			pulse.append(elem[0])
		pulses_ffreq.append(freq_from_fft(pulse, fs)) # Fundamental Frequency
	if N_pulses == 1:
		ffreq_halfcall = pulses_ffreq[0]			  
	else:	
		ffreq_halfcall = sum(pulses_ffreq[int(N_pulses/2):])/(N_pulses/2) # Average Fund Frequency during last half of call
	max_ffreq = max(pulses_ffreq)
	return pulses_ffreq, ffreq_halfcall, max_ffreq



# FUNCTION: Returns true if the given string is found in the file
def stringInFile (string, filename):
	with open(filename, 'r') as inF:	
			for line in inF:
				if string in line:
					return True
	return False 

# FUNCTION: Removes all the columns of features which are not included in the keep_features array
def keepFeatures (data, headers, keep_features):
	data_out = []
	for row in data:
		row_new = []
		for i in range(len(row)):
			if headers[i] in keep_features:
				#print('TEST')
				row_new.append(row[i])
		data_out.append(row_new)
	# clean up header
	headers_new = []
	for feat in headers:
		if feat in keep_features:
			#print('TEST')
			headers_new.append(feat)
	return data_out, headers_new

# FUNCTION: Returns the 'ind' column of the data_in
def getColumn(data_in, ind):
	data_out = []
	for row in data_in:
		data_out.append(row[ind])
	return data_out

def meanOfClass(data, ind, label, y_index):
	sum_ = 0.0
	cnt = 0
	for row in data:
		if row[y_index]==label:
			#print(row[ind])
			if row[ind]!='':
				sum_ += float(row[ind])
				cnt += 1
	print sum_
	print cnt				
	mean = sum_/cnt
	return mean

def findMode(list_in, num_values):
	count = [0]*num_values
	for elem in list_in:
		if elem!='':
			count[int(float(elem))] += 1
	max_cnt = max(count)
	median = count.index(max_cnt)
	return median

def countByClass (labels):
	N = len(labels)
	cnt = [0,0,0,0]
	for i in range(N):
		l = int(labels[i])
		cnt[l] = cnt[l] +1
	return cnt
