#CodeBook
Describes the variables, the data, and any transformations performed to clean up the data.

##Data
The data were collected from the accelerometers from the Samsung Galaxy S smartphone. 

The data were sourced from:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The experiments were video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##Variables

Each record contains the following:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

##Transformations

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
