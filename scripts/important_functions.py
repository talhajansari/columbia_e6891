
## Useful functions for the Machine Learning class
# Talha Jawad Ansari, 2014
# talhajansari@hotmail.com

# IMPORTS 
import numpy as np
import matplotlib.pyplot as plt
from random import randint
import csv


# INPUT: Takes a 'path to a CSV file' to read
# RETURN: an array/list in a python variable, representing the CSV data
def CSVToList (pathToCSV, seperator=",", header=False, debug=False):
	data_file = open(pathToCSV, 'rb')
	reader = csv.reader(data_file, delimiter=',', quotechar='\'')
	data = []
	for row in reader:
		data.append(row)
	if header:
		header = data.pop(0)
	return data, header


# INPUT: Takes in data as an input, and the index within the data which represents the class variable
# RETURN: Two seperate lists, feature data and the y data
def seperateIntoXY (data_list, indexOfY, debug=False):
	data_list_tmp = data_list
	y_list = []
	x_list = []
	count = 0;
	for row in data_list_tmp:
		row_tmp = row
		if (debug):
			print(row_tmp)
		y_list.append(row_tmp.pop(indexOfY)) 
		x_list.append(['1'])
		x_list[count].extend(row_tmp)
		count = count + 1
	return x_list, y_list


# Python implementation of Linear Regression Normal equation

# INPUT: Array representing the feature data (X_data), Column Array representing the dependent variable (Y_data)
# OUTPUT: Returns an array with Beta paramaters, generated through Normal Equation methodology
def normalEquation (x_list, y_list, MSE=True, debug=False):
	if (debug):
		print(type(y_list))
		print(type(x_list))
	if (type(y_list) is list or type(x_list) is list):
		y_list = np.array(y_list, dtype=float)
		x_list = np.array(x_list, dtype=float)
		if (debug):
			print(type(y_list))
			print(type(x_list))
	if (type(y_list) is np.ndarray or type(x_list) is np.ndarray):
		if (debug):
			print('Running Normal Equation on the given data...')
		beta_n = np.dot(np.linalg.inv(np.dot(x_list.transpose(),x_list)), np.dot(x_list.transpose(), y_list))
		if (debug):
			print ('Beta values using normal equation are:')
			print(beta_n)
			print('Normal equation function ended')
		if (MSE):
			mse_n = calcMSE(beta_n, x_list, y_list)
			return beta_n, mse_n
		else:
			return beta_n
	else:
		print ("ERROR: Type of input arguments is not list or np.ndarray")
	
def calcMSE(B, X, Y, debug=False):
	n = len(X)
	d = len(B)
	if (debug):
		print(type(B))
		print(B)
		print(X)
	F = np.dot(X,B)     # F(X)
	L = Y - F           # Loss
	return (np.sum(L**2)/n)

def removeFeature(x_list, x_index=1, debug=False):
	N = x_list.shape[0]
	d = x_list.shape[1] # num of feature dimensions 
	x_list_tmp = np.empty([N,d-1], dtype=float) 
	for i in range(N): # iterate through the rows
		row = x_list(i)

# include polynomials in the data - iterate through each row, and then add all the required polynomials , uptil d
def includePoly (x_list, x_index, degree=1, debug=False):
	if (degree==1):
		return x_list
	elif (degree==0): # basically, remove the feature altogether
		return np.delete(x_list, x_index, 1) # third parameter is the 'axis', meaning that the column should be deleted
	else: 
		N = x_list.shape[0]
		f = x_list.shape[1] # num of feature dimensions 
		x_list_tmp = np.empty([N,f+degree-1], dtype=float) # num of features after adding polynomials are old_features + d-1 new features
		for i in range(N): # iterate through the rows
			row = x_list[i]
			if (debug):
				print('i='+str(i))
				print(row)
			for j in range(2,degree+1): # iterate through the degree of polynomials
				row = np.append(row,row[x_index]**j)
				if (debug):
					print(j)
					print('--' + str(row))
			if (debug):
				print(x_list_tmp[i])
				print(row)
			x_list_tmp[i] = row
		return x_list_tmp

def getYHat (Beta, x_list):
	if (type(x_list) is list):
		if (len(Beta)!=len(X)):
			print('Error: Dimensions of beta and features are not the same')
		else:
			n = len(Beta)
			y = 0
			for i in range(len(Beta)):
				y += Beta[i]*x_list[i]
			return y
	elif (type(x_list) is np.ndarray):
		if (len(Beta)!= x_list.shape[1]):
			print('Error: Dimensions of beta and features are not the same')
		else:
			return np.dot(x_list,Beta)  


def plotRegressionLine (figNo, x_list, y_list, x_index, Y_hat, saveFileName, xlabel='', ylabel='', title='', debug=False):
	if (debug):
		print('- Plotting the regression function...')
	x_list = x_list[:,x_index]
	fig1 = plt.figure(figNo)
	plt.scatter(x_list, y_list)
	plt.xlabel(xlabel)
	plt.ylabel(ylabel)
	plt.title(title)
	plt.hold(True)
	plt.plot(x_list, Y_hat)
	plt.savefig(saveFileName)
	if (debug):
		print('- -  Plot saved as ' + saveFileName)


# FUNCTION: Splits data into training and test set, accroding to the given ratio of training samples to total samples (train_ratio), and maintains the positive-to-negative sample ratio
def crossValidationSplit(raw_data, train_ratio, y_index, debug=False):
	assert (train_ratio < 1.0)
	N = len(raw_data)
	data = raw_data
	# Find the propotion of positive and negative
	pos_ratio = positiveRatio (data, y_index, positiveLabel='yes')
	if debug: print ('N='+str(N)+', PosRatio='+str(pos_ratio))
	N_tr = int(N*train_ratio) 		# number of elements in training set
	N_ts = int(N - N_tr)		 	# number of elements in testing set
	N_p_tr = int(pos_ratio*N_tr) 	# number of positive elements in training set
	N_n_tr = int(N_tr - N_p_tr) 	# number of negative elements in training set
	N_p_ts = int(pos_ratio*N_ts)	# number of positive elements in testing set
	N_n_ts = int(N_ts - N_p_ts) 	# number of negative elements in testing set
	if debug: print(N_tr, N_ts, N_p_tr, N_n_tr, N_p_ts, N_n_ts)
	test_data = []
	pos_cnt = 0
	neg_cnt = 0
	while len(test_data)<N_ts:
		r = randint(0,N-1)
		if debug: print('N='+str(N)+', r='+str(r))
		row = data[r]
		if row[y_index]=='yes' and pos_cnt<N_p_ts :
			if debug: print('Yes')
			test_data.append(data.pop(r))
			N -= 1
			pos_cnt += 1
		elif row[y_index]=='no' and neg_cnt<N_n_ts :
			if debug: print('No')
			test_data.append(data.pop(r))
			neg_cnt += 1
			N -= 1
	train_data = data
	return train_data, test_data



