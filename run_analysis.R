## Milinda Samaraweera
## 3/21/2015

if (!("reshape2" %in% rownames(installed.packages())) ) {
  print("reshape2 package not found!! Please install it and continue")
} else {
  ## Open required libraries
  library(reshape2)
  
  
  ## Reading the required files for the task required
  activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))
  features <- read.table("features.txt")
  feature_names <- features[,2]
  testdata <- read.table("./test/X_test.txt")
  colnames(testdata) <- feature_names
  traindata <- read.table("./train/X_train.txt")
  colnames(traindata) <- feature_names
  test_subject_id <- read.table("./test/subject_test.txt")
  colnames(test_subject_id) <- "subject_id"
  test_activity_id <- read.table("./test/y_test.txt")
  colnames(test_activity_id) <- "activity_id"
  train_subject_id <- read.table("./train/subject_train.txt")
  colnames(train_subject_id) <- "subject_id"
  train_activity_id <- read.table("./train/y_train.txt")
  colnames(train_activity_id) <- "activity_id"
  test_data <- cbind(test_subject_id , test_activity_id , testdata)
  train_data <- cbind(train_subject_id , train_activity_id , traindata)
  
  ##Combine both test and train data into one dataframe
  all_data <- rbind(train_data,test_data)
  
  ##Selecting only mean and standard deviation values
  mean_col_idx <- grep("mean",names(all_data),ignore.case=TRUE)
  mean_col_names <- names(all_data)[mean_col_idx]
  std_col_idx <- grep("std",names(all_data),ignore.case=TRUE)
  std_col_names <- names(all_data)[std_col_idx]
  meanstddata <-all_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]
  
  ##Merge the activities datase with the mean/std values datase
  descrnames <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)
  
  ##Melt the dataset with the descriptive activity names for better handling
  data_melt <- melt(descrnames,id=c("activity_id","activity_name","subject_id"))
  mean_data <- dcast(data_melt,activity_id + activity_name + subject_id ~ variable,mean)
  
  ## Create the output file with the new tidy dataset
  write.table(mean_data,"./tidyData.txt")
}

