# Getting And Cleaning Data Course Project

The following information are also found in the codebook:

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

Data are directly loaded from the directory using `read.table()` to corresponding dataframe objects listed as follows:

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
