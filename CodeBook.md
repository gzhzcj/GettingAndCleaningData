# CodeBook for the tidy dataset

## The Source Data
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Description for the source data
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Transform

### 1. Download and unzip
### 2. Read Variable names from ./UCI HAR Dataset/features.txt
### 3. Read Activity names from ./UCI HAR Dataset/activity_labels.txt, with column name "activity", and "activity.name".
### 4. Reform Traning set
### 4.1. Read from ./UCI HAR Dataset/train/subject_train.txt, with column name "subject". Each row refer to a volunteer.
### 4.2. Read from ./UCI HAR Dataset/train/subject_X.txt, with column names read from ./UCI HAR Dataset/features.txt. Each row has 561 variables.
### 4.3. Read from ./UCI HAR Dataset/train/y_train.txt, with column name "activity". Each row refer to a activity, in numeric. Left join with data read from ./UCI HAR Dataset/activity_labels.txt
### 4.4. Create a new dataframe, first column with name "set", fixed value "training", 2nd column with name "subject", 3rd column with name "activity.name", the rest 561 columns from ./UCI HAR Dataset/features.txt, remain the names.
### 5. Reform Test set, Do the same with the Training set. Only paths and object names are different.
### 6. Merge the Training set and the Test set, use the rbind function to merge the two sets since the column names are the same.
### 7. Extract only variables with names like "mean"" and "std" (standard deviation) 
### 8. Group by subjects and activities and calculate the average value for each, as the final tidy dataset.
### 9. Write the tidy dataset to file.






