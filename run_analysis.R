#setting directory
setwd("UCI HAR Dataset")

#loading libraries
library(plyr)

#Reading data
train_x <- read.table("train/x_train.txt", header = FALSE)
train_y <- read.table("train/y_train.txt", header = FALSE)
train_subject_test <- read.table("train/subject_train.txt", header = FALSE)
test_x <- read.table("test/x_test.txt", header = FALSE)
test_y <- read.table("test/y_test.txt", header = FALSE)
test_subject_test <- read.table("test/subject_test.txt", header = FALSE)
features <- read.table("features.txt", header = FALSE, colClasses = c("numeric","character"), col.names = c("FeatureID","FeatureName"))
activity <- read.table("activity_labels.txt", header = FALSE,colClasses = c("numeric","character"), col.names = c("ActivityID","ActivityName"))
 
#1 - Merges the training and the test sets to create one data set.

#vector holding feature names
tnames <- lapply(features[,2], as.character)

#a- Merge train dataset
#adding subject IDs and activity IDs  
train <- cbind(train_subject_test,train_y)
colnames(train) <- c("SubjectID", "ActivityID") 
colnames(train_x) <- tnames
#adding train_x to the train dataset
train <-cbind(train, train_x)

#b- Merge test dataset
#adding subject IDs and activity IDs  
test <- cbind(test_subject_test,test_y)
colnames(test) <- c("SubjectID", "ActivityID") 
colnames(test_x) <- tnames
#adding test_x to the test dataset
test <-cbind(test, test_x)

#c- Merging train and test data
data <- rbind(test,train)




#2 - Extracts only the measurements on the mean and standard deviation for each measurement.

#Going through all column names starting at 3:
dcol <- colnames(data)
colnum <- length(colnames(data))
for (i in seq_along(colnames(data)) )
{  
        #if the name contains either mean or std, and is not the first two, then remove it:
        if(!grepl("mean", dcol[i]) & !grepl("std", dcol[i]) & i>2)
                {data[,dcol[i]] <- NULL}        
}
   


#3 - Uses descriptive activity names to name the activities in the data set

#Adding the activity labels from the activity_labels.txt file
data <- join(data, activity, by = "ActivityID")

#reording columns to display the labels in the second column
data <- data[,c(1,82,2:81)]

#removing the no longer needed ActivityID column
data[,3] <- NULL
head(names(data))





#4 - Appropriately labels the data set with descriptive variable names. 

#traversing through column names
tnames <- colnames(data)
for (i in seq_along(tnames))
{
        #if the column name contains "()" or "-" remove them, and capitalize Mean and Std
     tnames[i] <-   gsub("\\()", "", tnames[i])
     tnames[i] <-   gsub("-mean", "Mean", tnames[i])
     tnames[i] <-   gsub("-std", "Std", tnames[i])
}

#reset with the modified names
colnames(data) <- tnames




#5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Calculating and adding the mean column:
AverageData <- ddply( data, .(SubjectID, ActivityName), numcolwise(mean))

#Ordering columns by activity name
AverageData <- AverageData[with(AverageData, order(ActivityName)), ]

#Outputting .txt file
write.table(AverageData,"data_set_of_mean_values.txt",row.name=FALSE)
