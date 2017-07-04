## Getting and Cleaning Data Course Project 

## 1. Merge the training and test sets to create one data set 
# Read Tables included in the following link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Bind Training Data 

trainingdata<-cbind(y_train,x_train,subject_train)

# Bind Test Data

testdata<-cbind(y_test,x_test, subject_test)

# Merge trainingdata and testdata to one dataset

dataset<-rbind(trainingdata,testdata)

## 2. Extract only the measurements on the mean and standard deviation for each measurement

# Read Features Table which inlcudes mean and standard deviation column names 

features <-read.table("features.txt")

# Columns with mean or std in their names in any rows in column 2 

mean_and_Std_features<-grep("-(mean|std)\\(\\)",features[,2])

# x_train and x_test contain numeric variables 
# Bind these tables in order to subset  the mean and std columns 

xdata<-rbind(x_train,x_test)

xdata<-xdata[,mean_and_Std_features]

# Add column names into the new dataframe xdata

names(xdata)<-features[mean_and_Std_features,2]

##3. Use descriptive activity names to name the activities in the data set 

# Read Activity_Labels Table which contains full activity names 

activities<-read.table("activity_labels.txt")

# y_train and y_test contain activity related variables 
# Bind these tables in order to name the activities in the dataset 

ydata<-rbind(y_train,y_test)

# Replace activity numbers in ydata to descriptive activity names in ydata table

activityname<-activities[ydata[,1],2]

ydata[,1]<-activityname

# Give column name activity to the updated ydata 

names(ydata)<-"activity"

##4. Appropriately labels the dataset with descriptive variable names 

#Read subject_test table

subjectdata<-rbind(subject_test, subject_train)

names(subjectdata)<-"subject"


#Merge all updated tables 

updated_dataset<-cbind(xdata,ydata, subjectdata)


##5. Create a second, independently tidy data set with the average of each variable for each activity and each subject

install.packages(plyr)

library(plyr)

updated_Dataset_Averages <- ddply(updated_dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(updated_Dataset_Averages, "updated_Dataset_Averages.txt", row.name=FALSE)


