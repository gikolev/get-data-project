# Getting and Cleaning Data Course Project
## README file

This repo contains the course project for the Getting and Cleaning Data course on Coursera.

The goal of the project is to collect, clean and turn a data set into tidy data that can be used for later analysis.

[CodeBook.md](https://github.com/gikolev/get-data-project/blob/master/CodeBook.md) describes the data, variables, and any transformations performed to clean up the data.

[run_analysis.R](https://github.com/gikolev/get-data-project/blob/master/run_analysis.R) contains the R script used to perform the manipulations described in CodeBook.

[tidy_data.txt](https://github.com/gikolev/get-data-project/blob/master/tidy_data.txt) is a .txt version of the tidy data frame produced by running the R script.

The R script run_analysis.R does the following:

### 1. Merges the training and the test sets to create one data set.

A file path is established to the local folder containing the data to facillitate extraction:
````R
path <- "~/Data_Analytics/R_Directory/data/UCI HAR Dataset"
````

Each data group (Activity, Subject, and Features) has been split into 'train' and 'test' files, which need to be merged, with names provided to the columns, as follows:

Merging Subject data
````R
subject_test  <- read.table(paste(path, "/test" , "/subject_test.txt", sep = ""),header = FALSE)
subject_train  <- read.table(paste(path, "/train" , "/subject_train.txt", sep = ""),header = FALSE)
subject <- rbind(subject_train, subject_test)
names(subject) = "subject"
````

Merging Activity data
````R
## Read Activity train & test files, merge them into one data frame, and provide column names
activity_test  <- read.table(paste(path, "/test" , "/y_test.txt", sep = ""),header = FALSE)
activity_train  <- read.table(paste(path, "/train" , "/y_train.txt", sep = ""),header = FALSE)
activity <- rbind(activity_train, activity_test)
names(activity) = "activity"
````

Merging Features (or variable values)
````R
variables_test  <- read.table(paste(path, "/test" , "/X_test.txt", sep = ""),header = FALSE)
variables_train  <- read.table(paste(path, "/train" , "/X_train.txt", sep = ""),header = FALSE)
variables <- rbind(variables_train, variables_test)
variable_names <- read.table(paste(path, "/features.txt", sep = ""), header = FALSE)
names(variables) <- variable_names[, 2]
````
where the column names are taken from the "features.txt" file.

The three data frames are merged via `master_data <- cbind(subject, activity, variables)`.

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

````R
subset_variable_names <- variable_names$V2[grep("mean\\(\\)|std\\(\\)", variable_names$V2)]
columns <- union(c("subject", "activity"), subset_variable_names)
data <- subset(master_data, select = columns)
````

### 3. Uses descriptive activity names (from the "activity_labels.txt" file) to name the activities in the data set

````R
labels <- read.table(paste(path, "/activity_labels.txt", sep = ""), header = FALSE)
data <- merge(data, labels, by.x = "activity", by.y = "V1")
data$activity <- data$V2
data <- select(data, -V2)
````

### 4. Appropriately labels the data set with descriptive variable names. 

Based on Week 4 lecture slides from the Getting and Cleaning Data Coursera course, names of variables should be:
- All lower case when possible
- Descriptive
- Not duplicated
- Not have underscores, dots or whitespaces

````R
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
````

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

````R
data_melted <- melt(data, id = c("subject", "activity"))
data_mean <- dcast(data_melted, subject + activity ~ variable, mean)
````

Lastly, a text file is created from the tidy data set:

````R
write.table(data_mean, file = "tidy_data.txt", row.names = FALSE)
````


