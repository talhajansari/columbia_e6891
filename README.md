columbia_e6891
============================

Reproduction Package for Final Project of Columbia University course EECS E6891: Reproducing Computational Research. The work done is aimed at reproducing the paper 'Data mining applied to acoustic bird species recognition' by Vilches, E., Escobar, I. A., Vallejo, E. E., &amp; Taylor, C. E. (2006, August). In Pattern Recognition, 2006. ICPR 2006. 18th International Conference on (Vol. 3, pp. 400-403). IEEE.

Software Pre-requisites. In order to run the project, you should:
* Have Python installed. The project was build on Python 2.7.6
2. Have the following Python libraries installed: numpy, matplotlib, scipy
3. Have Matlab 
4. Download Weka Softwate version 3.4.19 (http://www.cs.waikato.ac.nz/ml/weka/) from http://sourceforge.net/projects/weka/files/weka-3-4/


**Data:**
Data is provided by Macaulay Library at Cornell University. 
There are two ways to proceed with the project in terms of data. 1) Use the original sound recordings which have been provided under license by the Macaulay Library, 2) Use .mat files, which already contain the segmented sound data and its MFCC features. Using the later approach will save a lot of time (as sounds will not have to be segmented) but .mat files take up about 15GB of space. Using the first approach requires less initial data, around 3 GB, but takes massive processing time. On my Macbook air, just running the segmentation algorithm on all calls took over 17 hours to complete! The scripts are designed to work with both the approaches, without any manual interference.
There is, however, a third approach too, a reduced data set containing only the sound files which were used in the project. This is the data set which is being used in the reproduction instructions below.


#Step by step Instructions:
1. Clone the Github repository to your local computer
* Download the zipped file *bird_sounds_data_reduced.zip* from *link will be provided later* and put it in the source folder (directory where the *script* folder is), unzip *bird_sounds_data_reduced.zip* and rename the unzipped folder *bird_sounds_data_reduced* to *bird_sounds_data*.
* Go to the directory named *scripts*
* Open Matlab and run main_step1.m (wait for it to finish)
* Run main_step2.py in Python
* Classification (1,2,3 out of 5 approaches)
  * Open Weka Software> Explorer> OpenFile> Select: 'features_nom_revised.csv'
  * In Weka, go to Tab Explorer>Filters> select: unsupervised > attributes > numericToNominal, and apply!
  * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/trees/id3; -> Start. Note down the accuracy *** IMPORTANT *** Copy the tree from the output of Weka (only the tree) and save it in new 'tree_id3.txt' file.
  * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/trees/j48; -> Start. Note down the accuracy *** IMPORTANT *** Copy the tree from the output of Weka (only thetree) and save it in new 'tree_j48.txt' file.
  * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
* Dimensionality Reduction, carried out in Python script 'main_step3.py'. Please run main_step3.py to create two new .csv files, with reduced datasets using ID3 and J4.8. The the new datasets are named 'features_nom_id3.csv' and 'features_nom_j48.csv'
* Classification (4, 5 approach)
    * Open Weka Software> Explorer> OpenFile> Select: 'features_nom_id3.csv'
    * In Weka, go to Tab Explorer>Filters> select: unsupervised > attributes > numericToNominal, and apply!
    * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
    * Open Weka Software> Explorer> OpenFile> Select: 'features_nom_j48.csv'
    * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
* Compare the accuracies of the five approaches to classification


If you have any questions, feel free to email at tja2117@columbia.edu
Talha Jawad Ansari (tja2117), 2014.
