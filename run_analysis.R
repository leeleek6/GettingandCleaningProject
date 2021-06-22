download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "accelerometers.zip") #downloads data folder
unzip("accelerometers.zip")

features <- unlist(read.delim("UCI HAR Dataset/features.txt",header = FALSE))
features <- lapply(strsplit(features," "), function(l) l[[2]])
activity <- unlist(read.delim("UCI HAR Dataset/activity_labels.txt",header=FALSE))
activity <- lapply(strsplit(activity," "), function(l) l[[2]])

testx <- read.delim("UCI HAR Dataset/test/X_test.txt", header = FALSE)
testy <- read.delim("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
testy <- data.frame(unlist(activity)[as.factor(unlist(testy))])
testsubj <- read.delim("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testset <- cbind(testsubj,testy,testx)
colnames(testset) <- c("subject","activity","dataset")

trainx <- read.delim("UCI HAR Dataset/train/X_train.txt", header = FALSE)
trainy <- read.delim("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
trainy <- data.frame(unlist(activity)[as.factor(unlist(trainy))])
trainsubj <- read.delim("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainset <- cbind(trainsubj,trainy,trainx)
colnames(trainset) <- c("subject","activity","dataset")


dat <- rbind(testset,trainset)

#gets set column in dat formatted into separate numbers
seprows <- function(column) {
  out <- list()
  for(i in 1:length(column)) {
    temp <- unlist(strsplit(column[i], " "))
    out[[i]] <- as.numeric(temp[-which(temp=="")])
  }
  out
}
#creates new table with each set in a row. each entry in a set is assigned to proper feature
newrows <- seprows(dat$dataset)
df <- data.frame(matrix(unlist(newrows), nrow=length(newrows), byrow=TRUE))
colnames(df) <- features
df <- select(df,contains("mean") | contains("std"))
vartable <- cbind(select(dat,subject,activity),df)
