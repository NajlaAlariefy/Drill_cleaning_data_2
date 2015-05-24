 
#Project Overview
----

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available [at the site where the data was obtained.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

#Raw Data
----
[Here are the data for the project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
 

## Files
+ For information about the project, read README.txt. 
+ For information about the features, read features_info.txt. 

### “UCI HAR Dataset” Folder

| File |  Variable | Unit|Status|
|-|-|
|activity_labels.txt| ActivityID| Numeric|used to connect activity names with the tidy dataset|
|activity_labels.txt| __ActivityName__| Character| __included__ |
|features.txt| FeatureID| Numeric|an unused index column|
|features.txt| __FeatureName__| Character|__included__ to map column names for the tidy dataset|


###"test" Folder

|  File  |  Variable | Unit|Description/Status|
|-|-|
|subject_test.txt| SubjectID| Numeric|__included__|
|X_test.txt| __561 Variables__| Numeric| __included__. 561 features, they are mapped to FeatureName (features.txt)|
|y_test.txt| ActivityID| Numeric|it is the classified activity column, used to map activity names in STEP 3|

###"train" Folder

|  File  |  Variable | Unit|Description/Status|
|-|-|
|subject_train.txt| SubjectID| Numeric|__included__|
|X_train.txt| __561 Variables__| Numeric| __included__. 561 features, they are mapped to FeatureName (features.txt)|
|y_train.txt| ActivityID| Numeric|it is the classified activity column, used to map activity names in STEP 3|





#Tidy Data
----
1. Train and Test data merged into one

   + Train dataset created with files "y_train.txt", "subject_train.txt", and "X_train.txt".
   + They was given column names of ""SubjectID, ActivityID" and the names from the "feature.txt" respectively. 
  
 ```R
head(names(train))
[1] "SubjectID"         "ActivityID"        "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" 
```
   + Test dataset created with files "y_train.txt", "subject_train.txt", and "X_train.txt".
   + Test was given column names of "SubjectID, ActivityID" and the names from the "feature.txt" respectively. 
  
 ```R
 head(names(test))
[1] "SubjectID"         "ActivityID"        "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" 
```
   + Test and Train datasets were merged into "data"
2. Only mean and std calculated features are selected
   + Using __grepl__, the column names of data were traversed 
   + All that contain "mean" or "std" strings were included
   + Otherwise they were removed
  
    ```R 
if(!grepl("mean", dcol[i]) & !grepl("std", dcol[i]) & i>2)
        {data[,dcol[i]] <- NULL}       
```
3. Activity IDs have been replaced with Activity Names
   + Using the **join** function, a column of activity names from "Activity_labels.txt" was added to "data" joined by the ActivityID column
    ```R 
data <- join(data, activity, by = "ActivityID")
    ```
  + The ActivityID column was removed
  + Columns were reordered to the following
    ```R
> head(names(data))
[1] "SubjectID"      "ActivityName"   "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" 
```

4. Feature Names have been modified and made easier to read.
  + "data" column names were modified to remove all "()" and "-"s, the "mean" and "std" substrings have been capitalized: "Mean", "Std" 
    ```R
> head(names(data))
[1] "SubjectID"      "ActivityName"   "tBodyAccMean-X" "tBodyAccMean-Y" "tBodyAccMean-Z" "tBodyAccStd-X" 
```
  
5. A second dataset ("data_set_of_mean_values.txt") is created holding mean values
  +  Using the **ddply** function, rows were collapsed to show only the mean of the variables of all combination of the 30 Subjects and the different activities ("standing" "walking"..etc)
  +  The rows were ordered by ActivityName to further easen the process of datamining
  +  The dataset was outputted to the file: "data_set_of_mean_values.txt"

 
 

 
 

 
