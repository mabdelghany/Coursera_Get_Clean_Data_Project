---
title: "ReadMe File"
author: "Mohamed Abdel Latif"
date: "November 18, 2015"
output: html_document
---

# Coursera Getting and Cleaning Data Final Project

Mohamed Abdel Latif

Repository for the course project for the Coursera Getting and Cleaning Data course.

# Overview
This project serves to demonstrate the collection and cleaning of a date set downloaded and turning it to a tidy data set that can be used for subsequent analysis. A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for this project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Making Modifications to This Script
Once you have obtained and unzipped the source files, you will need to unzip the file in a folder named `data` in your working directory. i.e. All the files and subfolders must be in `./data/UCI HAR Dataset/`

### Project Summary
The following are the project instructions

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Project Steps in more details:

#### Section 1. Merge the training and the test sets to create one data set.
After setting the source directory for the files, read into tables the data located in
- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

Assign column names and merge to create one data set.

#### Section 2. Extract only the measurements on the mean and standard deviation for each measurement. 
Using `grep` to take the subset of the column names that have mean, std in them
Subset this data to keep only the necessary columns.

#### Section 3. Use descriptive activity names to name the activities in the data set
Merge data subset with the activityType table to cinlude the descriptive activity names

#### Section 4. Appropriately label the data set with descriptive activity names.
Use gsub function for pattern replacement to clean up the data labels.

#### Section 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
Per the project instructions, we need to produce only a data set with the average of each veriable for each activity and subject

### Additional Information
You can find additional information about the variables, data and transformations in the CodeBook.MD file.