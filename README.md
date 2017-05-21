# project3samsungActivity
Getting and cleaning data course Project

This project is part of coursera Getting and clieaning data course Project. 
It includes one R script named run_analysis.R which reads Test and Training data from a Human Activity Recognition anlysis and experiment. 
Each Test and Training data is split into 3 files:
##1. A 561-feature vector with time and frequency domain variables. 
##2. Its activity label. 
##3. An identifier of the subject who carried out the experiment.

In the script all 3 datasets are combined and then Test and Training data sets are merged. From this new dataset we select the variables that represent a mean or standard deviation and we calculate the average of these variables. 
The result is stored in a new dataset named "summ_activity_avg.txt".

The Human Activity Recognition Data including it's description can be downloaded from this site.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
