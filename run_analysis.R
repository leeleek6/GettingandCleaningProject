##downloading data and loading appropriate packages
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "accelerometers.zip") 
unzip("accelerometers.zip")
library(dplyr)
library(tidyr)

##reading activities and features
features <- unlist(read.delim("UCI HAR Dataset/features.txt",header = FALSE))
features <- lapply(strsplit(features," "), function(l) l[[2]])
activity <- unlist(read.delim("UCI HAR Dataset/activity_labels.txt",header=FALSE))
activity <- lapply(strsplit(activity," "), function(l) l[[2]])
activity <- sub("_"," ",tolower(activity))

##reading/binding test data, uses descriptive activity names
testx <- read.delim("UCI HAR Dataset/test/X_test.txt", header = FALSE)
testy <- read.delim("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
testy <- data.frame(unlist(activity)[as.factor(unlist(testy))])
testsubj <- read.delim("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testset <- cbind(testsubj,testy,testx)
colnames(testset) <- c("subject","activity","dataset")

##reading/binding train data, uses descriptive activity names
trainx <- read.delim("UCI HAR Dataset/train/X_train.txt", header = FALSE)
trainy <- read.delim("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
trainy <- data.frame(unlist(activity)[as.factor(unlist(trainy))])
trainsubj <- read.delim("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainset <- cbind(trainsubj,trainy,trainx)
colnames(trainset) <- c("subject","activity","dataset")

##merge train and test data
dat <- arrange(rbind(testset,trainset),subject)

#seprows formats entries in a column of data as separate numeric
seprows <- function(column) {
  out <- list()
  for(i in 1:length(column)) {
    temp <- unlist(strsplit(column[i], " "))
    out[[i]] <- as.numeric(temp[-which(temp=="")])
  }
  out
}

##separates data in dataset column and creates dataframe with each value associated with corresponding variable
newrows <- seprows(dat$dataset)
df <- data.frame(matrix(unlist(newrows), nrow=length(newrows), byrow=TRUE))
colnames(df) <- features

##extracts variables for std and mean only
df <- select(df,contains("mean") | contains("std"))
vartable <- cbind(select(dat,subject,activity),df)


##descriptively renames variables
colnames(vartable) <- sub("-mean","Mean",names(vartable))
colnames(vartable) <- sub("-std","Std",names(vartable))
colnames(vartable) <- sub("-X","X",names(vartable))
colnames(vartable) <- sub("-Y","Y",names(vartable))
colnames(vartable) <- sub("-Z","Z",names(vartable))
colnames(vartable) <- sub("BodyBody","Body",names(vartable))
colnames(vartable) <- sub("\\()","",names(vartable))

##creates dataframe with average of each variable for each activity and subject
means <- vartable %>% group_by(subject,activity) %>% summarize_all(list(mean))

