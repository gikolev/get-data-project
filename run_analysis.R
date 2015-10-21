## There are three variables in the data set - Activity, Subject and Features

## Load packages
library(dplyr)
library(reshape2)

## Establish file path
path <- "~/Data_Analytics/R_Directory/data/UCI HAR Dataset"

## Read Subject train & test files, merge them into one data frame, and provide column names
subject_test  <- read.table(paste(path, "/test" , "/subject_test.txt", sep = ""),header = FALSE)
subject_train  <- read.table(paste(path, "/train" , "/subject_train.txt", sep = ""),header = FALSE)
subject <- rbind(subject_train, subject_test)
names(subject) = "subject"


## Read Activity train & test files, merge them into one data frame, and provide column names
activity_test  <- read.table(paste(path, "/test" , "/y_test.txt", sep = ""),header = FALSE)
activity_train  <- read.table(paste(path, "/train" , "/y_train.txt", sep = ""),header = FALSE)
activity <- rbind(activity_train, activity_test)
names(activity) = "activity"

## Read variable values from train & test files, merge them into one data frame, and provide column names
variables_test  <- read.table(paste(path, "/test" , "/X_test.txt", sep = ""),header = FALSE)
variables_train  <- read.table(paste(path, "/train" , "/X_train.txt", sep = ""),header = FALSE)
variables <- rbind(variables_train, variables_test)
variable_names <- read.table(paste(path, "/features.txt", sep = ""), header = FALSE)
names(variables) <- variable_names[, 2]

## Combine all columns into one data frame
master_data <- cbind(subject, activity, variables)

## Extract only the measurements on the mean and standard deviation for each variable
subset_variable_names <- variable_names$V2[grep("mean\\(\\)|std\\(\\)", variable_names$V2)]
columns <- union(c("subject", "activity"), subset_variable_names)
data <- subset(master_data, select = columns)

## Use descriptive activity names to name the activities in the data set
labels <- read.table(paste(path, "/activity_labels.txt", sep = ""), header = FALSE)
data <- merge(data, labels, by.x = "activity", by.y = "V1")
data$activity <- data$V2
data <- select(data, -V2)

## Appropriately labels the data set with descriptive variable names. 
## From week 4 lectures, nmes of variables should be
        ## - All lower case when possible
        ## - Descriptive
        ## - Not duplicated
        ## - Not have underscores, dots or whitespaces
names(data) <- gsub("^t", "time", names(data))
names(data) <- gsub("^f", "frequency", names(data))
names(data) <- gsub("Acc", "accelerometer", names(data))
names(data) <- gsub("Gyro", "gyroscope", names(data))
names(data) <- gsub("Mag", "magnitude", names(data))
names(data) <- gsub("BodyBody", "body", names(data))
names(data) <- gsub("Body", "body", names(data))
names(data) <- gsub("Jerk", "jerk", names(data))
names(data) <- gsub("X", "x", names(data))
names(data) <- gsub("Y", "y", names(data))
names(data) <- gsub("Z", "z", names(data))
names(data) <- gsub("-", "", names(data))
names(data) <- gsub("\\()", "", names(data))

## Create a second, independent tidy data set with the average of each 
## variable for each activity and each subject.

data_melted <- melt(data, id = c("subject", "activity"))
data_mean <- dcast(data_melted, subject + activity ~ variable, mean)

## Create .txt file from tidy data set
write.table(data_mean, file = "tidy_data.txt", row.names = FALSE)

