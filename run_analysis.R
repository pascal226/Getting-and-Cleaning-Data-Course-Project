# Step 1 
# Merge Data to training data (70%) and test data (30%) by columns.
# Merge training data and test data by their rows to one full Data Set.

trainingSubj  <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainingData  <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingAct   <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainingData  <- cbind(trainingData, trainingAct, trainingSubj)

testSubj  <- read.table("UCI HAR Dataset/test/subject_test.txt")
testData  <- read.table("UCI HAR Dataset/test/X_test.txt")
testAct   <- read.table("UCI HAR Dataset/test/Y_test.txt")
testData  <- cbind(testData, testAct, testSubj)

FullDataset <- rbind(trainingData, testData)

# Step 2
# Load labels and transfer it as character 
# Extracts measurements on the "mean" and "std" for each measurement.
# Replace NA's with nothing - make them descriptive (Step 3)

activityLabels     <- read.table("UCI HAR Dataset/activity_labels.txt")
features           <- read.table("UCI HAR Dataset/features.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features[,2]       <- as.character(features[,2])

desiredFeatures        <- grep(".*mean.*|.*std.*", features[,2])
desiredFeatures.names  <- features[desiredFeatures,2]
desiredFeatures.names  = gsub('-mean', 'Mean', desiredFeatures.names)
desiredFeatures.names  = gsub('-std', 'Std', desiredFeatures.names)
desiredFeatures.names  <- gsub('[-()]', '', desiredFeatures.names)
colnames(FullDataset)  <- c("subject", "activity", desiredFeatures.names)

FullDataset$activity <- factor(FullDataset$activity, levels = activityLabels[,2], labels = activityLabels[,2])
FullDataset$subject  <- as.factor(FullDataset$subject)

write.table(FullDataset, "tidy.txt", row.names = FALSE)

# Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each 
# variable for each activity and each subject.

library(reshape2)
library(reshape)

FullDataset.melted <- melt(FullDataset, id = c("subject", "activity"))
FullDataset.mean <- dcast(FullDataset.melted, subject + activity ~ variable, mean)

write.table(FullDataset.mean, "tidyMean.txt", row.names = FALSE)
