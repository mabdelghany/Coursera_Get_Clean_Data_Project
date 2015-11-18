# Read the Different Files

# Features and Activities Types
feat <- read.table('./data/UCI HAR Dataset/features.txt',header=FALSE)
activityType <- read.table('./data/UCI HAR Dataset/activity_labels.txt',header=FALSE)
# Training Data
subjectTr <- read.table('./data/UCI HAR Dataset/train/subject_train.txt',header=FALSE)
xTr <- read.table('./data/UCI HAR Dataset/train/x_train.txt',header=FALSE)
yTr <- read.table('./data/UCI HAR Dataset/train/y_train.txt',header=FALSE)
# Test Data
subjectTe <- read.table('./data/UCI HAR Dataset/test/subject_test.txt',header=FALSE)
xTe <- read.table('./data/UCI HAR Dataset/test/x_test.txt',header=FALSE)
yTe <- read.table('./data/UCI HAR Dataset/test/y_test.txt',header=FALSE)

# Assigin column names to the data imported above
colnames(activityType) <- c('activityId','activityType') 
colnames(subjectTr) <- "subjectId" 
colnames(xTr) <- feat[,2]  
colnames(yTr) <- "activityId"
colnames(subjectTe) <- "subjectId" 
colnames(xTe) <- feat[,2] 
colnames(yTe) <- "activityId" 

# Merging yTr, subjectTr, and xTr
trData <- cbind(yTr,subjectTr,xTr) 

# Create the final test set by merging the xTe, yTe and subjectTe data
teData <- cbind(yTe,subjectTe,xTe) 

### Concatenating training and test data to create a final data set
finalData <- rbind(trData,teData) 

# Create a vector for the column names from the finalData
colNames  <- colnames(finalData)

### Extract only the measurements on the mean and standard deviation for each measurement. 
featNew <- grep(".*mean.*|.*std.*|subjectId|activityId", colNames)
featNew.names <- colNames[featNew]
featNew.names <- gsub('-mean', 'Mean', featNew.names)
featNew.names <- gsub('-std', 'StdDev', featNew.names)
featNew.names <- gsub('[-()]', '', featNew.names)

extractedData <- finalData[,featNew]
finalExtractedData <- merge(extractedData,activityType,by='activityId',all.x=TRUE)
colNames  <- colnames(finalExtractedData)

### Creating descriptive activity names to name the activities in the data set
for (i in 1:length(colNames)) 
{
        colNames[i] <- gsub("\\()","",colNames[i])
        colNames[i] <- gsub("-std$","StdDev",colNames[i])
        colNames[i] <- gsub("-mean","Mean",colNames[i])
        colNames[i] <- gsub("^(t)","time",colNames[i])
        colNames[i] <- gsub("^(f)","frequency",colNames[i])
        colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] <- gsub("AccMag","AccelerationMagnitude",colNames[i])
        colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccelerationJerkMagnitude",colNames[i])
        colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
        colNames[i] <- gsub("Freq","Frequency",colNames[i])
}

### Appropriately labels the data set with descriptive variable names
colnames(finalExtractedData) <- colNames 

# Temporarily Removing the activityType to calculate the mean
finalDataExtractedNAT  <- finalExtractedData[,names(finalExtractedData) != 'activityType'] 

## Summarizing the finalDataExtractedNAT table to include just the mean of each variable for each activity and each subject
tidyData    <- aggregate(finalDataExtractedNAT[,names(finalDataExtractedNAT) != c('activityId','subjectId')],by=list(activityId=finalDataExtractedNAT$activityId,subjectId = finalDataExtractedNAT$subjectId),mean) 

# Merging the tidyData with activityType again
tidyData    <- merge(tidyData,activityType,by='activityId',all.x=TRUE) 

# Ordering the Data in the table based on activityId and then subjectId
tidyData <- tidyData[order(tidyData$activityId,tidyData$subjectId),]

### Export the tidyData set 
write.table(tidyData, './data/UCI HAR Dataset/tidyData.txt',row.names=FALSE,sep='\t')
