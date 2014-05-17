# STEP 2 of the E6891 Reproducution Page - To be run only after the succesull running of STEP 1, main_step1.m 
# Written by Talha Ansari for EECSE6891, Columbia University. May 2014.
# talhajansari@hotmail.com


from important_functions import *
from custom_methods import *



data_raw, headers_raw = CSVToList (pathToCSV='features_nom_pulses.csv', seperator=",", header=True, debug=False)

data = data_raw
headers = headers_raw
labels = getColumn(data_in=data, ind=len(data[0])-1)
N = len(labels)
D = len(data[0])

print headers_raw
print data[0]



ratio = [0, 21, 5, 0.9]
cnt = countByClass(labels)
print ("Initial count per class is: " + str(cnt))
num_1 = cnt[1]
num_2 = int((cnt[1]/ratio[1])*ratio[2])
num_3 = int((cnt[1]/ratio[1])*ratio[3])
num_req = [0, num_1, num_2, num_3]
print ("Number required is: " + str(num_req))

# code to maintain 21:9:0.9 ratio between species
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
print headers_raw
writeToCSV('features_nom_revised.csv', data=data_new, labels=labels_new, incldueheaders=True, headers=headers, labelsincluded=True)




