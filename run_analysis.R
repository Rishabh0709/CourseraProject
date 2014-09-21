## Read files for training data set.
x_train <- read.table("./train/X_train.txt" , header = FALSE)
y_train <- read.table("./train/y_train.txt" , header = FALSE)
sub_train <- read.table("./train/subject_train.txt" , header = FALSE)
names(y_train) <- "Activity"
names(sub_train) <- "Subject"

## Combine all the training files.
train <- data.frame(x_train , sub_train , y_train)

## Read files for test data set.
x_test <- read.table("./test/X_test.txt" , header = FALSE)
y_test <- read.table("./test/y_test.txt" , header = FALSE)
sub_test <- read.table("./test/subject_test.txt" , header = FALSE)
names(y_test) <- "Activity"
names(sub_test) <- "Subject"

## Combine all the test files.
test <- data.frame(x_test , sub_test , y_test)

## Sol 1: Merging training and test data set.
mergedData <- rbind(train , test)

## Read file including all column names.
feature <- read.table("features.txt" , header = FALSE)
names(feature) <- c("sno" , "ColName")

##Position for columns having information on mean and standard deviation.
which(grepl("std",feature[,2])) -> stdpos
which(grepl("mean",feature[,2])) -> meanpos

## Sol 2: Extracts only the measurements on the mean and standard deviation for each measurement.
mergedData_m_sd <- mergedData[,sort(c(meanpos , stdpos , ncol(mergedData)-1 , ncol(mergedData)))]

## Read file including activity labels.
labels <- read.table("activity_labels.txt" , header = FALSE)
names(labels) <- c("sno" , "ActName")

##Sol 3: Name the activities in the data set.
data_with_names <- merge(mergedData_m_sd , labels , by.x = "Activity" , by.y = "sno")
data_with_names <- data_with_names[-1]

## Changed the column names using features file.
names(data_with_names) <- c(as.character(feature[sort(c(meanpos,stdpos)),][,2]) , "Subject" , "ActivityName")

tidyDs <- melt(data_with_names , id = names(data_with_names[,1:79]) , measure.vars = c("Subject" , "ActivityName"))


