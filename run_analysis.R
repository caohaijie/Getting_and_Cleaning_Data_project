library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset") { 
        unzip(filename) 
}

## read the activity and the features
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
activity$V2<-as.character(activity$V2)
features<-read.table("UCI HAR Dataset/features.txt")
features$V2<-as.character(features$V2)

## extract the features needed en mean and standard deviation
featuresNum<-grep(".*mean.*|.*std.*",features$V2)
featuresNames<-features[featuresNum,2]
featuresNames<-gsub("-mean","Mean",featuresNames)
featuresNames<-gsub("-std","Std",featuresNames)
featuresNames<-gsub("[()-]","",featuresNames)

## loads the test data
x_test<-read.table("UCI HAR Dataset/test/x_test.txt")[,featuresNum]
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
test<-cbind(test_subject,y_test,x_test)

## loads the train data
x_train<-read.table("UCI HAR Dataset/train/x_train.txt")[,featuresNum]
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
train<-cbind(train_subject,y_train,x_train)

## Merges the training and the test sets to create one data set
## Appropriately labels the data set with descriptive variable names.
dataSet<-rbind(test,train)
colnames(dataSet)<-c("subject","activity",featuresNames)

## Uses descriptive activity names to name the activities in the data set
dataSet$activity<-factor(dataSet$activity,levels=activity[,1],labels = activity[,2])
dataSet$subject<-as.factor(dataSet$subject)

## write the cleaning data
write.table(dataSet,"clean_data.txt",row.names=FALSE)

## creates a second, independent tidy data set with the average of 
##  each variable for each activity and each subject.

dataSetMelted <- melt(dataSet, id = c("subject", "activity"))
dataMean <- dcast(dataSetMelted, subject + activity ~ variable, mean)

## write the new average data 
write.table(dataMean, "average_data.txt", row.names = FALSE, quote = FALSE)
