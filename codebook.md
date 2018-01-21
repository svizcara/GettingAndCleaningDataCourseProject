---
title: "Codebook for Getting and Cleaning Data Course Project"
output:
  html_document: default
  pdf_document: default
---

## Raw data

The raw data for this project is from the link:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

Said dataset contains measurements obtained through experiments performed with 30 subjects (19-48 y.o.) who wore a smartphone (Samsung Galaxy S II) on the waist while executing each of the six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

A full description of the dataset is found in:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

For this project, the ff. files in the dataset are used:

* `features.txt` : contains the list of features that correspond to the columns of the datasets found in test and train foldrs

* `activity_labels.txt`: contains the descriptive names for the activity codes in the test and train datasets

* `test/X_test/`: contains the measurements of the features for the test set

* `test/y_test/`: contains a column of activity codes corresponding to each observation in `test/X_test/`

* `test/subjects_test/`: contains the column of subjects corresponding to each observation in `test/X_test/`

* `train/X_train/`: contains the measurements of the features for the training set

* `train/y_train/`: contains a column of activity codes corresponding to each observation in `train/X_train`

* `train/subjects_train/`: contains the column of subjects corresponding to each observation in `train/X_train/`

Raw datasets from `../Inertial Signals` were not used.

## Objective
The goal is to create a tidy dataset that satisfies the ff.:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Transformation to Tidy Data
The `dplyr` package was loaded into the environment.

### Loading of Data
The code checks if the extracted directory exists, if not, first it checks if the zipped file with the expected file name exists, if not, it downloads then the file first from the first url mentioned above, then unzip it.

Data are directly loaded from the files mentioned above using `read.table()` to corresponding dataframe objects listed as follows:

* `features.txt` : features
* `activity_labels.txt`: activity_labels
* `test/X_test/`: test
* `test/y_test/`: test_activities
* `test/subjects_test/`: test_subjects
* `train/X_train/`: train
* `train/y_train/`: train_activities
* `train/subjects_train/`: train_subjects

`col.names` and `colClasses` (except in `activity_labels`) were already specified upon loading of the datasets. The 2nd column of the `features` dataframe was passed to the `col.names` of `test` and `train`.

Later on after tidying the data, these objects are removed from the environment.


### Merging of Datasets
Step 0:
Each dataset of the test and training sets is pre-processed by combining the activity codes ("\*_activities") and subject ("\*_subjects") columns (named "actCode" and "subject", correspondingly) to the measurements dataset, and an extra column ("set") identifying to which set the observation belongs.

Step 1:
Then, the complete test and training datasets were joined using `full_join()` and stored in the object `joinedData`.

Later on after tidying the data, the object is removed from the environment.

### Extracting of Data
Step 2:
The mean and std measurements were extracted from the original merged dataset using `select()` and the select helper `contains()` specifying that the desired columns are those with the terms "mean", "std", "actCode", and "subject". The resulting dataframe is stored in the object `mean_std_measurements`.

### Applying descriptive activity names
Step 3:
`activity_labels` is merged to the `mean_std_measurements` dataframe by their common variable `actCode`. Then, the `actCode` is removed from the dataset using `select()` so that the remaining variable corresponding to activity is `activities`. Also, the dataframe is converted to a tibble and stored in the object `tidy_df`. Meanwhile, `mean_std_measurements` is removed from the environment.

### Applying descriptive variable names
Step 4:
This step is skipped since the variables are already given descriptive names by passing the 2nd column of the `features` dataframe to the column names of the `test` and `train` dataframes

### Getting the average of the measurements
Step 5:
The averages of the measurements of each feature for each activity and each subject are obtained using `group_by()` and `summarize_all()`. The dataset is also arranged by group in ascending order using `arrange()`.

The resulting dataset is stored in the `mean_tidy_df` object.

## Writing the Data
Finally, `tidy_df` and `mean_tidy_df` datasets are written to a text file in the working directory using `write.table()`, where `row.names=FALSE`.

## Description of Variable Names in the Resulting Datasets

[1] `tBodyAcc.mean...X`,  
[2] `tBodyAcc.mean...Y`,  
[3]`tBodyAcc.mean...Z` :  
mean of the body acceleration measurements in the X, Y and Z-axis obtained from time-domain signal from the accelerometer        

[4] `tGravityAcc.mean...X`,  
[5] `tGravityAcc.mean...Y`,  
[6] `tGravityAcc.mean...Z`:   

mean of the gravity acceleration measurements in the X, Y and Z-axis obtained from time-domain signal from the accelerometer

[7] `tBodyAccJerk.mean...X`,  
[8] `tBodyAccJerk.mean...Y`,  
[9] `tBodyAccJerk.mean...Z`:  
mean of the Jerk signals in the X, Y and Z-axis obtained by derivation of body linear acceleration and angular velocity in time 

[10] `tBodyGyro.mean...X`,  
[11] `tBodyGyro.mean...Y`,  
[12] `tBodyGyro.mean...Z`:  
mean of the body acceleration measurements in the X, Y and Z-axis obtained from time-domain signal from the gyroscope   

[13] `tBodyGyroJerk.mean...X`,  
[14]`tBodyGyroJerk.mean...Y`,  
[15] `tBodyGyroJerk.mean...Z`:  
mean of the Jerk signals in the X, Y and Z-axis obtained by derivation of body linear acceleration and angular velocity in time 

[16] `tBodyAccMag.mean..`,  
[17] `tGravityAccMag.mean..`,  
[18] `tBodyAccJerkMag.mean..`,  
[19] `tBodyGyroMag.mean..`,  
[20] `tBodyGyroJerkMag.mean..`:  
mean of the magnitudes of the 3-d signals calculated using the Euclidean norm

[21] `fBodyAcc.mean...X`,  
[22] `fBodyAcc.mean...Y`,  
[23] `fBodyAcc.mean...Z`,  
[24] `fBodyAcc.meanFreq...X`,  
[25] `fBodyAcc.meanFreq...Y`,  
[26] `fBodyAcc.meanFreq...Z`,  
[27] `fBodyAccJerk.mean...X`,  
[28] `fBodyAccJerk.mean...Y`,  
[29] `fBodyAccJerk.mean...Z`,  
[30] `fBodyAccJerk.meanFreq...X`,  
[31] `fBodyAccJerk.meanFreq...Y` ,  
[32] `fBodyAccJerk.meanFreq...Z`,           
[33] `fBodyGyro.mean...X`,                  
[34] `fBodyGyro.mean...Y`,                  
[35] `fBodyGyro.mean...Z`,                  
[36] `fBodyGyro.meanFreq...X`,              
[37] `fBodyGyro.meanFreq...Y`,              
[38] `fBodyGyro.meanFreq...Z`,              
[39] `fBodyAccMag.mean..`,                  
[40] `fBodyAccMag.meanFreq..`,              
[41] `fBodyBodyAccJerkMag.mean..`,          
[42] `fBodyBodyAccJerkMag.meanFreq..`,      
[43] `fBodyBodyGyroMag.mean..`,             
[44] `fBodyBodyGyroMag.meanFreq..`,         
[45] `fBodyBodyGyroJerkMag.mean..`,         
[46] `fBodyBodyGyroJerkMag.meanFreq..`:  
mean of the frequency-domain signals obtained by applying Fast Fourier Transform (FFT), where meanFreq is obtained using the weighted average of the frequency components

[47] `angle.tBodyAccMean.gravity.`,         
[48] `angle.tBodyAccJerkMean..gravityMean.`,  
[49] `angle.tBodyGyroMean.gravityMean.`,    
[50] `angle.tBodyGyroJerkMean.gravityMean.`,  
[51] `angle.X.gravityMean.`,                
[52] `angle.Y.gravityMean.`,                
[53] `angle.Z.gravityMean.`:
mean of the angle between the two vectors

Similary, 
[54] `tBodyAcc.std...X`,                    
[55] `tBodyAcc.std...Y`,                    
[56] `tBodyAcc.std...Z`,
standard deviation of the body acceleration measurements in the X, Y and Z-axis obtained from time-domain signal from the accelerometer

[57] `tGravityAcc.std...X`,                 
[58] `tGravityAcc.std...Y`,                 
[59] `tGravityAcc.std...Z`:
standard deviation of the gravity acceleration measurements in the X, Y and Z-axis obtained from time-domain signal from the accelerometer

[60] `tBodyAccJerk.std...X`,                
[61] `tBodyAccJerk.std...Y`,                
[62] `tBodyAccJerk.std...Z`:
standard deviation of the Jerk signals in the X, Y and Z-axis obtained by derivation of body linear acceleration and angular velocity in time 

[63] `tBodyGyro.std...X`,                   
[64] `tBodyGyro.std...Y`,                   
[65] `tBodyGyro.std...Z`: 
standard deviation of the body acceleration measurements in the X, Y and Z-axis obtained from time-domain signal from the gyroscope 

[66] `tBodyGyroJerk.std...X`,               
[67] `tBodyGyroJerk.std...Y`,               
[68] `tBodyGyroJerk.std...Z`:
standard deviation of the Jerk signals in the X, Y and Z-axis obtained by derivation of body linear acceleration and angular velocity in time 

[69] `tBodyAccMag.std..`,                   
[70] `tGravityAccMag.std..`,                
[71] `tBodyAccJerkMag.std..`,               
[72] `tBodyGyroMag.std..`,                  
[73] `tBodyGyroJerkMag.std..`:
standard deviation of the magnitudes of the 3-d signals calculated using the Euclidean norm

[74] `fBodyAcc.std...X`,                    
[75] `fBodyAcc.std...Y`,                    
[76] `fBodyAcc.std...Z`,                    
[77] `fBodyAccJerk.std...X`,                
[78] `fBodyAccJerk.std...Y`,                
[79] `fBodyAccJerk.std...Z`,                
[80] `fBodyGyro.std...X`,                   
[81] `fBodyGyro.std...Y`,                  
[82] `fBodyGyro.std...Z`,                   
[83] `fBodyAccMag.std..`,                   
[84] `fBodyBodyAccJerkMag.std..`,           
[85] `fBodyBodyGyroMag.std..`,              
[86] `fBodyBodyGyroJerkMag.std..`:  
standard deviation of the frequency-domain signals obtained by applying Fast Fourier Transform (FFT), where meanFreq is obtained using the weighted average of the frequency components

[87] `subject` : specifies the id of the subject from whom the measurement was obtained                            
[88] `activity` : specifies which of the six(6) activities : WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING, is performed for the observation
