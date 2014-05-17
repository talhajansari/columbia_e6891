#!/usr/bin/python
import numpy as np
import time
import os
from scipy import stats
from scipy.io import loadmat
from scipy.ndimage import measurements


# FUNCTION: Written by Jingwei Zhang, 2014. 
def gen_feature_mfcc(x):
	v, asp = x
	#print len(x)
	#print len(x[0])
	#print len(x[1])
	try:
		if np.isnan(v).any() or np.isinf(v).any():
			raise Exception('MFCC contains Nan of Inf')
		xn, (xmin, xmax), xmean, xvar, xskew, xkurt =  stats.describe(v)
		d = np.diff(v, 1, 0)
		#print len(d)
		dmean = np.mean(d, 0)
		feat = np.reshape((measurements.center_of_mass(v)[0],
			measurements.center_of_mass(asp)[0], measurements.maximum_position(asp)[0]),(3,))
		hist = 1.0*measurements.histogram(asp, 0, 1, 4) / asp.shape[0]/asp.shape[1]
		x = np.concatenate((xmean,xmin,xmax,xvar,dmean,feat,hist[-1:]))
		if np.isnan(x).any() or np.isinf(x).any():
			raise Exception('Feature vector contains Nan of Inf')
	except:
		#print d, dd
		print xmin.shape
		raise
	return x.T

# FUNCTION: Written by Jingwei Zhang, 2014
def get_feature(mat_file):
	if not os.path.isfile(mat_file):
		raise Exception('No feature file found, probably no segment detected')
	data = loadmat(mat_file, variable_names=['X'])['X']
	data = [x[0][0][0] for x in data]
	
	data = [(x[0].T,x[1].T) for x in data]
	
	feature = []
	for x in data:
		xx = gen_feature_mfcc(x)
		feature.append(xx)
	if len(feature) == 0:
		raise Exception('No features, probably no segment detected')
	return feature

# FUNCTION: Takes the feature vector (data) and the labels (labels) to produce and save a .csv file with the
# values, and the last column as the labels. Having includeheaders=True gives numbered-names to the features.
def writeToCSV(filename, data, labels, incldueheaders=False):
	import csv
	D = len(data[0])
	if incldueheaders:
		headers = []
		for i in range(D):
			headers.append('F'+str(i+1))
		headers.append('specie')
	csvfile = open(filename, 'wb')
	writer = csv.writer(csvfile, delimiter=',', quotechar='\'', quoting=csv.QUOTE_NONNUMERIC)
	if incldueheaders:
		writer.writerow(headers)
	for i in range(len(data)):
		print (i)
		line = list(data[i])
		# print line
		line.append(str(labels[i]))
		writer.writerow(line)

# FUNCTION: Vector Quantitzation - Carries out Vector Quantization on the numeric feature data
# RETURNS: Feature data with numeric values replaced by nominal values
def vectorQuantization (features, bits):
	from scipy.cluster.vq import vq
	D = len(features[0])
	np_features = np.array(features)
	nom_features = np.empty(np_features.shape, dtype=str)
	for i in range(D):
		column = np_features[:,i]
		max_val = np.max(column)
		min_val = np.min(column)
		bits = bits
		denom = ( 2**(bits-1) - 1)
		step = (max_val - min_val)/denom
		partition = [0]*(denom+1)
		codebook = [0]*(denom+1)
		for j in range(denom+1):
			partition[j] = (min_val+(step*j))
			codebook[j] = j
		column = np.array(column)
		partition = np.array(partition)
		print('****')
		print(column)
		print(partition)
		tmp = vq(column,partition)
		nom_col = [str(int(x)+1) for x in tmp[0]]
		print tmp[0]
		print nom_col
		print '****'
		nom_features[:,i] = nom_col
	#nom_features = np.int_(nom_features)
	return nom_features



# Load all the .mat files into Python
soundinfo = loadmat('soundinfo', variable_names=['info','filepath', 'labels', 'features'])
info = soundinfo['info']
filepath = soundinfo['filepath']
labels_old = soundinfo['labels']
N = len(info)
catalog = []
for i in range(N):
	catalog.append(info[i][1][0])
features = []
labels = []
for i in range(N):
	x = get_feature('dotMatFiles/'+str(catalog[0])+'.mat')
	for call in x:
		features.append(call)
		labels.append(labels_old[i][0])

print len(features)
print len(labels)

N = len(features)
D = len(features[0])




features_nom = vectorQuantization(features, bits=6)
print (features_nom)
print len(labels)
writeToCSV('features_nom.csv', data=features_nom, labels=labels, incldueheaders=True)

# # Naive Bayes
# from sklearn.naive_bayes import GaussianNB
# gnb = GaussianNB()
# clf = gnb.fit(features, labels)
# y_pred = clf.predict(features)
# print("Number of mislabeled points : %d" % (labels != y_pred).sum())


