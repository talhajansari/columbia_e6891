columbia_e6891
============================

Reproduction Package for Final Project of Columbia University course EECS E6891: Reproducing Computational Research. The work done is aimed at reproducing the paper 'Data mining applied to acoustic bird species recognition' by Vilches, E., Escobar, I. A., Vallejo, E. E., &amp; Taylor, C. E. (2006, August). In Pattern Recognition, 2006. ICPR 2006. 18th International Conference on (Vol. 3, pp. 400-403). IEEE.

Software Pre-requisites. In order to run the project, you should:
* Have Python installed. The project was build on Python 2.7.6
2. Have the following Python libraries installed: numpy, matplotlib, scipy
3. Have Matlab 
4. Download Weka Softwate version 3.4.19 (http://www.cs.waikato.ac.nz/ml/weka/) from http://sourceforge.net/projects/weka/files/weka-3-4/


Data:
Data is provided by Macaulay Library at Cornell University. I am still finding an efficient way to share the date. Please email me at tja2117@columbia.edu for a quick access to the data. 
There are two ways to proceed with the project from the perspective of data. 1) Use the original sound recordings which have been provided under license by the Macaulay Library, 2) Use .mat files, which already contain the segmented sound data and its MFCC features. Using the later approach will save a lot of time (as sounds will not have to be segmented) but .mat files take up about 15GB of space. Using the first approach requires less initial data, around 3 GB, but takes massive processing time. On my Macbook air, just running the segmentation algorithm on all calls took over 17 hours to complete! The scripts are designed to work with both the approaches, without any manual interference. If a .mat file is available for any file/call, the script use them instead of creating them from scratch.



Step by step Instructions:
* Download the Github repository to your local computer
2. Go to the directory named ‘scripts’
3. Open Matlab and run main_step1.m (wait for it to finish)
4. Run main_step2.py in Python
5. Classification (1,2,3 out of 5 approaches)
  * Open Weka Software> Explorer> OpenFile> Select: 'features_nom_revised.csv'
Select Filters > unsupervised > attributes > numericToNominal, and apply!
 
    * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/trees/id3; -> Start. Note down the accuracy *** IMPORTANT *** Copy the tree from the output of Weka (only the tree) and save it in new 'tree_id3.txt' file.
    
    * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/trees/j48; -> Start. Note down the accuracy *** IMPORTANT *** Copy the tree from the output of Weka (only thetree) and save it in new 'tree_j48.txt' file.
    
    * In Weka, go to Tab: Classification>Classifier>Open> Select: 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
7. Dimensionality Reduction, carried out in Python script 'main_step3.py'
    * Please run main_step3.py to create two new .csv files, with reduced
    * datasets using ID3 and J4.8. The the new datasets are named
    * 'features_nom_id3.csv' and 'features_nom_j48.csv'

    * Open Weka Software> Explorer> OpenFile> Select: 'features_nom_id3.csv'
    * In Weka, go to Tab: Classification>Classifier>Open> Select:
    * 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy
    
    * Open Weka Software> Explorer> OpenFile> Select: 'features_nom_j48.csv'
    * In Weka, go to Tab: Classification>Classifier>Open> Select:
    * 'classifier/bayes/NaiveBayes; -> Start. Note down the accuracy



If you have any questions, feel free to email at tja2117@columbia.edu

Talha Jawad Ansari (tja2117), 2014.
