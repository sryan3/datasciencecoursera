run_analysis <- function() {

   #read input files
   xtrain <- read.table("data/train/X_train.txt")
   ytrain <- read.table("data/train/Y_train.txt")
   strain <- read.table("data/train/subject_train.txt")
   xtest <- read.table("data/test/X_test.txt")
   ytest <- read.table("data/test/Y_test.txt")
   stest <- read.table("data/test/subject_test.txt")
   
   #Merge the training and the test sets 
   X <- rbind(xtrain,xtest)
   Y <- rbind(ytrain,ytest)
   subject <- rbind(strain,stest)
   
   #Label the data set with descriptive variable names
   feature_names <- read.table("data/UCI HAR Dataset/features.txt")
   colnames(X) <- feature_names$V2
   
   #Extract only the measurements on the mean and standard deviation for each measurement. 
   #remove columns that do not have -mean and -std in the name
   X <- X[grep("-mean|-std",names(X))]   
   
   #create one dataset
   merged_data <- cbind(subject,Y,X)
   colnames(merged_data)[1:2] <- c("subject","activity")

   #Use descriptive activity names to name the activities in the data set
   activity_names <- read.table("data/UCI HAR Dataset/activity_labels.txt")
   merged_data$activity <- cut(merged_data$activity,6,labels=activity_names$V2)

   #Create an tidy data set with the average of each variable by activity and subject
   tidy <- aggregate(merged_data[,3:ncol(merged_data)], list(subject = merged_data$subject, activity = merged_data$activity), mean)

   #upload tidy data set as txt file
   write.table(tidy, file="data/tidy_data.txt", row.name=FALSE)
}