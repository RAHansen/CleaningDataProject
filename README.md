## Course Project for Getting and Cleaning Data Course

This project summarizes measurement data used in the study of wearable computing devices.
The original study is referenced here: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The original data is cleaned, named, and organized making it ready for further analysis.

The R script ```run_analysis.R``` is loaded and run to perform the data cleansing and summary.

**Assumptions:**
In order to run the script, the following assumptions are made:

    A. The project Zip file has been extracted into its component folders and the "UCI HAR Dataset" folder has been set as the working directory.
    B. The 'reshape2' package has been installed.

Here is the overall process that the script follows:

  1. Read the original data files and extract just the information we are interested in.
      + We are only interested in "mean" and "standard deviation" data. To extract these measurements, we search the variable names for the strings "mean()" and "std()". The "desired_label_strings" vector can be changed to search for different strings (line 32).
  2. Clean up variable names. The original names contain characters that are illegal as names in R; there are also a number of mistakes that need to be corrected.
  3. Combine the subject and activity data with the measurement data.
  4. The origial data was divided into two sets: test data and training data; these two sets are merged into a single data set.
  5. The final data set (**wearable_data**) consists of 10299 observations (rows) of 66 measurement values, plus the subject and activity type (68 columns).
  6. A new data set is also created (**wearable_data_means**) that contains the averages of the measurements broken down by subject and activity. (30 subjects __x__ 6 activities = 180 rows) (66 columns of average measurement values, plus 1 column for subject and 1 column for activity)
  7. The **wearable_data_means** data set is also written to a file called "wearable_data_means.txt"

