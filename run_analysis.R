# change the working directory to the correct one
setwd("C://Users//Romano//Desktop//Coursera//Certificate Data Analisys//Cleaning Data//UCI HAR Dataset")

features<-read.table("features.txt")

# 1. Merges the training and the test sets to create one data set

# read test and train x data, join them and assign right column names

x_test<-read.table("test//x_test.txt")
x_train<-read.table("train//x_train.txt")
x <- rbind(x_train, x_test)
colnames(x)<-features$V2

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
mean <- grep("mean", names(x))	# select index columns where is mean in x data set
std <- grep("std", names(x))		# select index columns where is std in x data set
mean_std<-c(mean, std)			# index columns where is mean or std in x data set
mean_std<-mean_std[order(mean_std)]	# order index columns
data <-x[,mean_std]			# subset data 

# Continue 1.
# read test and train y data, join them and assign right column name
y_test<-read.table("test//y_test.txt")
y_train<-read.table("train//y_train.txt")
y <- rbind(y_train, y_test)
colnames(y)<-"activity_label"

# read test and train subject data, join them and assign right column name
subject_train<-read.table("train//subject_train.txt")
subject_test<-read.table("test//subject_test.txt")
subject<-rbind(subject_train, subject_test)
colnames(subject)<-"subject"

# join x data with activity and subject
data<-cbind(data, y, subject)

# 3. Uses descriptive activity names to name the activities in the data set 
data$activity_label<-gsub("1", "WALKING", data$activity_label)
data$activity_label<-gsub("2", "WALKING_UPSTAIRS", data$activity_label)
data$activity_label<-gsub("3", "WALKING_DOWNSTAIRS", data$activity_label)
data$activity_label<-gsub("4", "SITTING", data$activity_label)
data$activity_label<-gsub("5", "STANDING", data$activity_label)
data$activity_label<-gsub("6", "LAYING", data$activity_label)
data$activity_label<-as.factor(data$activity_label)
data$subject<-as.factor(data$subject)

# 4. Appropriately labels the data set with descriptive variable names
names(data)<-gsub("^t", "Time-", names(data))
names(data)<-gsub("^f", "Frequency-", names(data))
names(data)<-gsub("Acc", "-Accelerometer-", names(data))
names(data)<-gsub("Gyro", "-Gyroscope-", names(data))
names(data)<-gsub("Mag", "-Magnitude-", names(data))
names(data)<-gsub("--", "-", names(data))

# 5. From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.

library(dplyr)
newdata <- data %>% group_by(subject, activity_label) %>% summarise_each(funs(mean))
write.csv(newdata, "data.csv")

#library(reshape2)
#newdata<-melt(data, id = c("subject", "activity_label"))
#newdata<-dcast(newdata, subject + activity_label ~ variable, mean)


