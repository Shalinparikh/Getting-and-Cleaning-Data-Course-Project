library(dplyr)

x_train <- read.table('train/X_train.txt')
y_train <- read.table('train/y_train.txt')
x_test <- read.table('test/X_test.txt')
y_test <- read.table('test/y_test.txt')
sub_train <- read.table('train/subject_train.txt')
sub_test <- read.table('test/subject_test.txt')
activities <- read.table('activity_labels.txt')
features <- read.table('features.txt')


#1. Merges the training and the test sets to create one data set.

x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(sub_train,sub_test)


#2. Extracts only the measurements on the mean and standard deviation for each measurement.
mainfeatures <- features[grep('mean\\(\\)|std\\(\\)',features[,2]),]
x <- x[,mainfeatures[,1]]


#3. Uses descriptive activity names to name the activities in the data set

y <- merge(y,activities,sort = FALSE)
colnames(y)<- c('Activity','Activitylabel')


#4. Appropriately labels the data set with descriptive variable names.

colnames(x) <- mainfeatures[,2]


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(subject) <- 'Subject'
final <- cbind(x,y,subject)
final_mean<- final%>%group_by(Activitylabel,Subject)%>%summarize_each(funs(mean))
write.table(final_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)


