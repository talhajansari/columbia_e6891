#!/usr/bin/python
import numpy as np
import time
import os
from scipy import stats
from scipy.io import loadmat
from scipy.ndimage import measurements
import cPickle

data = loadmat(mat_file, variable_names=['X'])['X']

X = get_feature('dotMatFiles/62008.mat')

def gen_feature_mfcc(x):
	v, asp = x
	try:
		if np.isnan(v).any() or np.isinf(v).any():
			raise Exception('MFCC contains Nan of Inf')
		xn, (xmin, xmax), xmean, xvar, xskew, xkurt =  stats.describe(v)
		d = np.diff(v, 1, 0)
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

def get_feature(mat_file):
	if not os.path.isfile(mat_file):
		raise Exception('No feature file found, probably no segment detected')
	data = loadmat(mat_file, variable_names=['X'])['X']
	print len(data)
	#print data[0][0][0]
	data = [x[0][0][0] for x in data]
	#print len(data)
	#print data[0][0][0] 
	data = [(x[0].T,x[1].T) for x in data]
	##print len(data)
	print data[0][0][0]
	feature = []
	for x in data:
		xx = gen_feature_mfcc(x)
		feature.append(xx)
	if len(feature) == 0:
		raise Exception('No features, probably no segment detected')
	return feature

def predict(clf, X):
	pred = clf.predict_proba(X)
	pred = np.row_stack(pred)
	pred.sort(0)
	N = np.ceil(pred.shape[0]*.6)
	pred = pred[-int(N+1):,:]
	pred = pred.sum(0) / pred.sum()
	print '***'
	return pred

# if __name__ == '__main__':
# 	with open('clf.pickle', 'r') as f:
# 		clf = cPickle.load(f)
# 	start_time = time.time()
# 	matFilePath = '1.mat'
# 	X = get_feature('test.mat')
# 	print predict(clf, X)
# 	end_time = time.time()
# 	print "Elapsed time is %g seconds" % (end_time - start_time)

with open('clf.pickle', 'r') as f:
	clf=cPickle.load(f)
#start_time = time.time()
matFilePath = 'dotMatFiles/7052.mat'
X = get_feature('dotMatFiles/62008.mat')
print X
print predict(clf, X)
#end_time = time.time()
#print "Elapsed time is %g seconds" % (end_time - start_time)
