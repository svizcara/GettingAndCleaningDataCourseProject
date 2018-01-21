library(dplyr)

## Check if data directory or zipped file exists,
## if it doesn't exists, download files from source
if(!dir.exists(file.path(getwd(),"UCI HAR Dataset"))){
    if(!file.exists("samsungdata.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                      destfile = file.path(getwd(),"samsungdata.zip"),
                      mode="wb")
        }
    unzip("samsungdata.zip")
}

#load features.txt as dataframe to be used as descriptive column names
features <- read.table(file.path(getwd(),"UCI HAR Dataset/features.txt"),
                       colClasses="character")
colNames <- as.vector(features[,2])
#load activity labels to be merged later as descriptive activity names
activity_labels <- read.table(file.path(getwd(),
                                       "UCI HAR Dataset/activity_labels.txt"),
                             col.names = c("actCode","activity"))

## FOLLOWING CODES LOADS the TEST dataset
#load test/y_test.txt to be merged to test data as activity codes (actCode)
test_activities <- read.table(file.path(getwd(),
                                        "UCI HAR Dataset/test/y_test.txt"), 
                         col.names="actCode", colClasses="numeric")
#load text/subject_test.txt to be merged to test data as subjects (subject)
test_subjects <- read.table(file.path(getwd(),
                                        "UCI HAR Dataset/test/subject_test.txt"), 
                              col.names="subject", colClasses="numeric")

#load values from text/X_test.txt as test dataframe
test <- read.table(file.path(getwd(),"UCI HAR Dataset/test/X_test.txt"),
                    col.names = colNames,
                    colClasses="numeric")

#add 'actCode' & 'subject' columns to test dataframe
test$actCode <- test_activities[,1]
test$subject <- test_subjects[,1]

#add 'set' variable to test for sorting purposes
test <- mutate(test, set = "test")

## FOLLOWING CODES LOADS the TRAINING dataset
#load train/y_train.txt to be merged to train data as activity codes (actCode)
train_activities <- read.table(file.path(getwd(),
                                         "UCI HAR Dataset/train/y_train.txt"), 
                             col.names="actCode", colClasses="numeric")
#load train/subject_train.txt to be merged to train data as subjects (subject)
train_subjects <- read.table(file.path(getwd(),
                                      "UCI HAR Dataset/train/subject_train.txt"), 
                            col.names="subject", colClasses="numeric")

#load values from train/X_train.txt as train dataframe
train <- read.table(file.path(getwd(),"UCI HAR Dataset/train/X_train.txt"),
                    col.names = colNames,
                    colClasses="numeric")

#add 'actCode' and 'subject' columns to train dataframe
train$actCode <- train_activities[,1]
train$subject <- train_subjects[,1]

#add 'set' variable to train for sorting purposes
train <- mutate(train, set = "train")


## FOLLOWING CODES follow the target transformation of the datasets
## Step 1: Merge the training and the test sets to create one data set
joinedData <- full_join(test,train)

## Step 2: Extract only the measurements on the mean and standard deviation
## for each measurement
mean_std_measurements <- select(joinedData, c(contains("mean"),
                                              contains("std"),
                                              contains("actCode"),
                                              contains("subject")))

##Step 3:Use descriptive activity names to name the activities in the data set
mean_std_measurements <- merge(mean_std_measurements, activity_labels)
mean_std_measurements <- select(mean_std_measurements,-actCode)
tidy_df <- tbl_df(mean_std_measurements)
##Step 4: Appropriately label the data set with descriptive variable names
## this step is skipped since the variables are already given descriptive
## names upon loading of the data

## Remove unneccessary objects for output
rm(test,test_activities,test_subjects,train,train_activities,
   train_subjects,activity_labels,features,joinedData,mean_std_measurements,
   colNames)

##Step 5: From the data set in step 4, create a second, independent tidy data 
##set with the average of each variable for each activity and each subject
mean_tidy_df <- tidy_df %>% 
                group_by(subject,activity) %>%
                summarize_all(funs(mean)) %>%
                arrange(.by_group=TRUE)


## Write data
write.table(tidy_df,
            file=file.path(getwd(),"tidy_df.txt"),
            row.names=FALSE)
write.table(mean_tidy_df,
            file=file.path(getwd(),"mean_tidy_df.txt"),
            row.names=FALSE)

