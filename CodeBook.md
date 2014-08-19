
## Processing steps to clean the accelerometer data for the Getting and Cleaning Data Course Project

###  Accelerometer data is read in from the current directory


```r
   xtrain <- read.table("data/train/X_train.txt")
   ytrain <- read.table("data/train/Y_train.txt")
   strain <- read.table("data/train/subject_train.txt")
   xtest <- read.table("data/test/X_test.txt")
   ytest <- read.table("data/test/Y_test.txt")
   stest <- read.table("data/test/subject_test.txt")
```


###  The initial test and train datasets were combined
####   -X has the accelerometer results 
####   -Y has the activity values
####   -subject has the subject values


```r
   X <- rbind(xtrain,xtest)
   Y <- rbind(ytrain,ytest)
   subject <- rbind(strain,stest)
```


###  The labels from the accelerometer results are loaded to the table

```r
   feature_names <- read.table("data/UCI HAR Dataset/features.txt")
   colnames(X) <- feature_names$V2
```


###  Columns that do not have -mean and -std in the name are removed

```r
   X <- X[grep("-mean|-std",names(X))]   
```


###  A single dataset is created to combine the accelerometer results with the subject and activity values

```r
   merged_data <- cbind(subject,Y,X)
   colnames(merged_data)[1:2] <- c("subject","activity")
```


###  The activity column is changed to a factor value and reassigned with the activity description

```r
   activity_names <- read.table("data/UCI HAR Dataset/activity_labels.txt")
   merged_data$activity <- cut(merged_data$activity,6,labels=activity_names$V2)
```


###  Create an tidy data set with the average of each variable by activity and subject

```r
   tidy <- aggregate(merged_data[,3:ncol(merged_data)], list(subject = merged_data$subject, activity = merged_data$activity), mean)
```


###  Upload tidy data set as txt file

```r
   write.table(tidy, file="data/tidy_data.txt", row.name=FALSE)
```
