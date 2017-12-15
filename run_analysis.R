### coursera.org   Getting and Cleaning Data 
### Week 4 Course Project

### Create an independent tidy dataset based on the original dataset.
### Original dataset 
### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
### Original description
### http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


library(dplyr)

## 0. Download the zipfile and unzip.
destfile <- file.path(getwd(), "smartphone.zip")
if (!file.exists(destfile)){
        #.../dataset.zip not exist.
        message(paste(destfile, "does not exist."))
        
        url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        message(paste("Downloading", url, "and save as dataset.zip."))
        
        if (grep("Windows", Sys.getenv("OS"))>0){
                download.file(url, destfile)
        }else{
                download.file(url, destfile, method="curl")
        }
                
        message("Download completed.")
}

file <- file.path(getwd(), "UCI HAR Dataset/README.txt")
if(!file.exists(file)){
        message("Unzipping files...")
        unzip(destfile, exdir=".")
        message("Unzip completed.")
}

### 1. Merges the training and the test sets to create one data set.
## 1.1. Preparation

## 1.1.1 Read variable names for X
file <- file.path(getwd(), "UCI HAR Dataset/features.txt")
message(paste("Reading from", file))
features <- read.table(file, header = FALSE, col.names=c("feature.id", "feature"))
variable_names_x <- features[,2]

## 1.1.2 Read activity names
file <- file.path(getwd(), "UCI HAR Dataset/activity_labels.txt")
message(paste("Reading from", file))
activities<-read.table(file, header = FALSE, col.names=c("activity.id", "activity.name"))

## 1.2. Training set
## 1.2.1 subject_train.txt
file <- file.path(getwd(), "UCI HAR Dataset/train/subject_train.txt")
message(paste("Reading from", file))
subject_train <- read.table(file, header = FALSE, col.names="subject")

## 1.2.2. X_train.txt
file <- file.path(getwd(), "UCI HAR Dataset/train/X_train.txt")
message(paste("Reading from", file))
x_train <- read.table(file, header = FALSE, col.names=variable_names_x )

## 1.2.3. y_train.txt
file <- file.path(getwd(), "UCI HAR Dataset/train/y_train.txt")
message(paste("Reading from", file))
y_train <- read.table(file, header = FALSE, col.names = "activity.id" )
activities_train <- left_join(y_train, activities, by="activity.id")

## 1.2.4. transform
set_train <- rep("training", nrow(y_train))
data_train <- data.frame(set = set_train, subject_train, 
                         activity = activities_train[,2], x_train)
dims<-dim(data_train)
message(paste("Training set:", dims[1], "obs. of", dims[2], "variables"))

## 1.3. Test set
## 1.3.1. subject_test.txt
file <- file.path(getwd(), "UCI HAR Dataset/test/subject_test.txt")
message(paste("Reading from", file))
subject_test <- read.table(file, header = FALSE, col.names="subject")

## 1.3.2. X_test.txt
file <- file.path(getwd(), "UCI HAR Dataset/test/X_test.txt")
message(paste("Reading from", file))
x_test <- read.table(file, header = FALSE, col.names=variable_names_x )

## 1.3.3. y_test.txt
file <- file.path(getwd(), "UCI HAR Dataset/test/y_test.txt")
message(paste("Reading from", file))
y_test <- read.table(file, header = FALSE, col.names = "activity.id" )
activities_test <- left_join(y_test, activities, by="activity.id")

## 1.3.4. transform
set_test <- rep("test", nrow(y_test))
data_test <- data.frame(set = set_test, subject_test,
                activity = activities_test[,2], x_test)
dims<-dim(data_test)
message(paste("Test set:", dims[1], "obs. of", dims[2], "variables"))

## 1.4. Merge the training set and the test set.
message("Merging the training set and the test set...")
data<-rbind(data_train, data_test)
dims<-dim(data)
message(paste("Merged:", dims[1], "obs. of", dims[2], "variables"))

### 2. Extracts only the measurements on the mean and standard deviation 
###    for each measurement
message("Only the measurements on the mean and standard deviation remain.")
measurements <- grep(".*[M|m]ean.*|.*[S|s]td.*", variable_names_x)
## first 3 columns are set, subject, activity, needs an offset.
column_list <- c(2:3, measurements + 3)
target_data <- data[, column_list]
#print(names(target_data))
dims<-dim(target_data)
message(paste("Merged:", dims[1], "obs. of", dims[2], "variables"))

### 3. Uses descriptive activity names to name the activities in the data set
#--- Already done in step 1.2.3 and 1.3.3

### 4. Appropriately labels the data set with descriptive variable names.
#--- Already done in step 1.2.2 and 1.3.2

### 5. From the data set in step 4, creates a second, independent tidy data set
###    with the average of each variable for each activity and each subject.
tidy_set <- target_data %>%
        group_by(activity, subject) %>%
        summarise_all(mean)
destfile <- "tidy_set.csv"
message(paste("Writing to", destfile))
write.csv(tidy_set, destfile, row.names = FALSE)


