############################################
# Getting and Cleaning Data - Course Project
#
# R.A. Hansen - 21 Feb 2015
#
# Assumptions:
#     1. The project Zip file has been extracted into folders and the "UCI HAR Dataset" folder is the working directory.
#     2. The 'reshape2' package must be installed.

print("Starting run_analysis.R script.")

# Test assumption 1
if ( basename(normalizePath(".")) != "UCI HAR Dataset") print("Warning: the 'UCI HAR Dataset' folder is not set as your current working directory.")

# First we want to read the original data files and extract just the information we are interested in.
# We are only interested in "mean" and "Standard deviation" data.

# Determine which columns we want to keep.
print("Reading variable labels.")
# "features.txt" contains the labels for the data columns in the "X_" files.
all_labels <- read.table("features.txt")

print("Tidying labels.")
# There is a discrepancy between the labels in "features.txt" and the documentation in "features_info.txt"; 
# some of the labels have "body" doubled. We do a search and replace so that our data matches the documentation.
all_labels_corrected <- gsub("BodyBody", "Body", all_labels[,2])
# also there is an extra ")" in one location; fix it:
all_labels_corrected <- gsub("),", ",", all_labels_corrected)

# Define the labels we want to keep.
# We keep labels that contain one of the following strings:
desired_label_strings <- c("mean()", "std()") ## Edit this vector to change which data items are extraced.

# Determine which labels contain the desired strings (i.e., which columns we want to keep):
columns_to_keep <- as.logical(rowSums(sapply(desired_label_strings, grepl, all_labels_corrected, fixed=TRUE)))

# column names can not have certain characters such as "()-," so we need to modify the names to be acceptable R column names
all_labels_corrected <- gsub("(", "", all_labels_corrected, fixed=TRUE)   # delete "("
all_labels_corrected <- gsub(")", "", all_labels_corrected)   # delete ")"
all_labels_corrected <- gsub(",", ".", all_labels_corrected)   # convert comma to period
all_labels_corrected <- gsub("-", "_", all_labels_corrected)   # convert dash to underscore


# Read the raw data files
print("Reading variables data files.")
raw_test <- read.table("test/X_test.txt", col.names=all_labels_corrected)
raw_train <- read.table("train/X_train.txt", col.names=all_labels_corrected)
# Remove those columns that are not of interest
print("Selecting columns of interest; i.e., those measurement names that contain the following strings:"); print(desired_label_strings)
x_test <- raw_test[columns_to_keep]
x_train <- raw_train[columns_to_keep]

print("Merging data.")
# Read the subject files
subject_test <- read.table("test/subject_test.txt", col.names="subject")
subject_train <- read.table("train/subject_train.txt", col.names="subject")

# Read the Activity files
activity_legend <- read.table("activity_labels.txt")
act_test <- read.table("test/y_test.txt", col.names="activity")
act_train <- read.table("train/y_train.txt", col.names="activity")

# Append the subject and activity to the measurement data
x_test <- data.frame(subject_test, activity=activity_legend[act_test[,1],2], x_test)
x_train <- data.frame(subject_train, activity=activity_legend[act_train[,1],2], x_train)

# Merge the "test" and "train" data together
wearable_data <- rbind(x_train, x_test)
print("The data frame 'wearable_data' contains the complete data set of interest.")


# Create a new data set (and write to a file) with the average of each variable for each activity and each subject

# create some convenience variables
num_subjects <- nrow(unique(rbind(subject_test, subject_train)))
num_activities <- nrow(unique(activity_legend))
num_variables <- ncol(wearable_data)-2

# library 'reshape2' must be installed
library(reshape2)

# Create a summary data set of the means for each measurement by activity and subject
wd_long <- melt(wearable_data, id=c("subject", "activity"))
wearable_data_means <- dcast(wd_long, subject + activity ~ variable, mean)
print("The data frame 'wearable_data_means' contains the average of each measurement for each subject and activity.")

# Write the means to a file
write.table(wearable_data_means, file="wearable_data_means.txt", row.names=FALSE)
print("The 'wearable_data_means' data frame has been written to file: 'wearable_data_means.txt'.")
print("run_analysis.R script is complete")

# The following is used to help prepare a CodeBook for this project
if(FALSE)
{
  cat("Subjects=", num_subjects, " Activities=", num_activities, " Variables=", num_variables)
  cat("wearable_data: rows=", nrow(wearable_data), " columns=", ncol(wearable_data))
  cat("wearable_data_means: rows=", nrow(wearable_data_means), " columns=", ncol(wearable_data_means))
  cat("Activities:")
  activity_legend
  write.table(colnames(wearable_data), file = "names.txt", row.name = FALSE, quote = FALSE)
}