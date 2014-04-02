columbia_e6891
============================

Repository for Columbia University course CSEE6891: Reproducing Computational Research. The work done is aimed at reproducing the paper 'Data mining applied to acoustic bird species recognition' Vilches, E., Escobar, I. A., Vallejo, E. E., &amp; Taylor, C. E. (2006, August). In Pattern Recognition, 2006. ICPR 2006. 18th International Conference on (Vol. 3, pp. 400-403). IEEE.

According to the paper, there are four stages to the project:
1- Get access to the data (and try to get the exact soundfiles which the authors use)
2- Use SoundRuler (software) to process the soundfiles and extract the features
3- Use the feature data in Weka Software to implement a decision tree algorithm, and other machine learning classifiers.
4- Compare and present the performance of classifiers.

Instructions:
- (Stage 1) In order to get started with my reproduction package, please download the bird sounds data from https://drive.google.com/file/d/0B1Ywmwt5sCj3WFZEOGlBTU5sSlE/edit?usp=sharing , unpack the .zip file in the source folder. 
- The two software packages, SoundRuler and Weka Software, have already been download and included in the repository. However, more information about the softwares can be found at http://soundruler.sourceforge.net/main/ and http://www.cs.waikato.ac.nz/ml/weka/.
- Now, there are two ways to go ahead. I have implemneted some code in both Python and Matlab. However, going forward, I will only be working on Matlab. Therefore, I am providing instructions on the use of Matlab code. 
- Run the script 'main.m'. This will upload the data and the soundfiles into Matlab, create a cell matrix with information on the soundfiles.
- (Stage 2) Extract Features ---- SoundRuler is not working. It has been extremely difficult to figure out how to use SoundRuler to extract features. The authors are not clear on 'what features they use'. The other alternative now is to write my own Matlab code to extract some common MFCC features.
- (Stage 3) Weka Software is included in the Weka folder in the repo. Once the feature data is available, import into Weka to implement a decision tree algorithm. Using this decision tree, get a list of features which are being used (and are therefore the most important). Use this features and implement other ML classifiers (Naive Bayes, KNN)
- (Stage 4) Compare the performance of these classifiers.

<!-------- dead block --------!> 
- I have not been able to extract the features, yet. I am working on my own Matlab code (which can bypass SoundRuler) and get me some imporant required features, but this is proving to be a hard task. Which means that I am on Stage 2. 

- Implement the K-NN ---- (can't do it unless I have the features)

* Please contact tja2117@columbia.edu to discuss how to get the data.

Talha Jawad Ansari (tja2117), 2014.
