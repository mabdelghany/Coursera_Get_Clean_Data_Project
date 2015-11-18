## Clear the Workspace

rm(list=ls())

# Read the Different Files

features     = read.table('./data/UCI HAR Dataset/features.txt',header=FALSE); #imports features.txt
activityType = read.table('./data/UCI HAR Dataset/activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./data/UCI HAR Dataset/train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./data/UCI HAR Dataset/train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./data/UCI HAR Dataset/train/y_train.txt',header=FALSE); #imports y_train.txt

# Assigin column names to the data imported above
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# Create the final training set by merging yTrain, subjectTrain, and xTrain
trainingData = cbind(yTrain,subjectTrain,xTrain);

# Read in the test data
subjectTest = read.table('./data/UCI HAR Dataset/test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./data/UCI HAR Dataset/test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./data/UCI HAR Dataset/test/y_test.txt',header=FALSE); #imports y_test.txt

# Assign column names to the test data imported above
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2];
colnames(yTest)       = "activityId";

# Create the final test set by merging the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest);

### Combine training and test data to create a final data set
finalData = rbind(trainingData,testData);

# Create a vector for the column names from the finalData, which will be used
# to select the desired columns
colNames  = colnames(finalData)

### Extract only the measurements on the mean and standard deviation for each measurement. 
featuresWanted <- grep(".*mean.*|.*std.*|subjectId|activityId", colNames)
featuresWanted.names <- colNames[featuresWanted]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

extractedData = finalData[,featuresWanted]
finalExtractedData = merge(extractedData,activityType,by='activityId',all.x=TRUE)
colNames  = colnames(finalExtractedData)

### Creating descriptive activity names to name the activities in the data set

for (i in 1:length(colNames)) 
{
        colNames[i] = gsub("\\()","",colNames[i])
        colNames[i] = gsub("-std$","StdDev",colNames[i])
        colNames[i] = gsub("-mean","Mean",colNames[i])
        colNames[i] = gsub("^(t)","time",colNames[i])
        colNames[i] = gsub("^(f)","frequency",colNames[i])
        colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] = gsub("AccMag","AccelerationMagnitude",colNames[i])
        colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccelerationJerkMagnitude",colNames[i])
        colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
        colNames[i] = gsub("Freq","Frequency",colNames[i])
}

### Appropriately labels the data set with descriptive variable names
colnames(finalExtractedData) = colNames;

finalDataExtractedNAT  = finalExtractedData[,names(finalExtractedData) != 'activityType'];

## Summarizing the finalDataExtractedNAT table to include just the mean of each variable for each activity and each subject
tidyData    = aggregate(finalDataExtractedNAT[,names(finalDataExtractedNAT) != c('activityId','subjectId')],by=list(activityId=finalDataExtractedNAT$activityId,subjectId = finalDataExtractedNAT$subjectId),mean);

# Merging the tidyData with activityType
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Ordering the Data in the table based on activityId and then subjectId
# Looks nicer this way!
tidyData = tidyData[order(tidyData$activityId,tidyData$subjectId),]

### Export the tidyData set 
write.table(tidyData, './data/UCI HAR Dataset/tidyData.txt',row.names=FALSE,sep='\t')
