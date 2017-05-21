##Load Libraries used in this script

library(readr)
library(dplyr)
library(tidyr)

##read file "features.txt" to get the column names of the features included in file 
##"/test/X_test.txt" and "/test/X_train.txt"

##Some variable names are duplicated and will cause a warning but since they won't be 
##used in this project th warning will be ignored.
features<-read_delim("./project3/UCI HAR Dataset/features.txt", " ", col_names = c("f_id", "feature"), n_max=561)
colNames<-features$feature

##561 columns of 16 char each.
colWidths<-rep(16,561)

##1. Merges the training and the test sets to create one data set.
##Read test and train data from files. Each train/test data sets are split in three files
##1. A 561-feature vector with time and frequency domain variables. 
##2. Its activity label. 
##3. An identifier of the subject who carried out the experiment.
##First join these three files per test/train group and then merge both data sets.

##Read Test Features
X_test<-read_fwf("./project3/UCI HAR Dataset/test/X_test.txt", fwf_widths(colWidths, col_names = colNames))
##Read Test labels
Y_test<-read_delim("./project3/UCI HAR Dataset/test/Y_test.txt", " ", col_names = c("activity_id"))
##Read Test Subjects
subject_test<-read_delim("./project3/UCI HAR Dataset/test/subject_test.txt", " ", col_names = c("subject"))
##Merge columns for Test Data
testdata<-bind_cols(subject_test, Y_test, X_test)
                    
##Read Train Features
X_train<-read_fwf("./project3/UCI HAR Dataset/train/X_train.txt", fwf_widths(colWidths, col_names = colNames))
##Read Test labels
Y_train<-read_delim("./project3/UCI HAR Dataset/train/Y_train.txt", " ", col_names = c("activity_id"))
##Read Test Subjects
subject_train<-read_delim("./project3/UCI HAR Dataset/train/subject_train.txt", " ", col_names = c("subject"))
##Merge columns for Test Data
traindata<-bind_cols(subject_train, Y_train, X_train)

activityData<-dplyr::union(mutate(traindata, tgroup="train"), mutate(testdata, tgroup="test"))

##check for duplicate records and add a unique key to each record
activityData<-unique(activityData) %>% 
        mutate(recordN=row_number())

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

##Keep Columns with mean and STdev

selectactivityData<-select(activityData, recordN,subject, activity_id, tgroup, matches("[Mm]ean[(]|[Ss]td[(]"))

## We could colapse the columns if required for a more Tidy Dataset.
##%>%
##           gather(featurevariable, value, -c(recordN, subject,activity_id, tgroup), na.rm=T) %>%
##                separate(featurevariable, c("feature", "variable", "axis")) %>%
##                spread(variable, value)


##3. Uses descriptive activity names to name the activities in the data set

##Read activity labels file from "activity_labels.txt"

label_dim<-read_delim("./project3/UCI HAR Dataset/activity_labels.txt"," ", col_names = c("activity_id", "activity_nm"), n_max = 6)

selectactivityData<-left_join(selectactivityData, label_dim, by="activity_id")


## 4. ppropriately labels the data set with descriptive variable names.
colNames<-names(selectactivityData)
colNames<-gsub("mean","Mean",colNames)
colNames<-gsub("std","Std",colNames)
colNames<-sub("^t","Time",colNames)
colNames<-sub("^f","Freq",colNames)
colNames<-gsub("-|\\()","",colNames)
names(selectactivityData)<-colNames


##5. From the data set in step 4, creates a second, independent tidy data set with 
##the average of each variable for each activity and each subject.

# Generate second dataset with the averages by activity and subject
averageactivitydata<-select(selectactivityData,-recordN, -activity_id, -Timegroup) %>%
        group_by(activity_nm, subject) %>%
        summarize_each(funs(mean))

write.table(averageactivitydata,"./summ_activity_avg.txt", quote=FALSE, sep=" ",row.names=FALSE)
