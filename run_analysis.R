download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "accelerometers.zip") #downloads data folder
gzfile("accelerometers.zip")
unzip("accelerometers.zip")

testx <- read.delim("UCI HAR Dataset/test/X_test.txt", header = FALSE)
testy <- read.delim("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
testsubj <- read.delim("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
testset <- cbind(testx,testy,testsubj)
colnames(testset) <- c("set","label","subject")

trainx <- read.delim("UCI HAR Dataset/train/X_train.txt", header = FALSE)
trainy <- read.delim("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
trainsubj <- read.delim("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
trainset <- cbind(trainx,trainy,trainsubj)
colnames(trainset) <- c("set","label","subject")

features <- read.delim("UCI HAR Dataset/features.txt",header = FALSE)
dat <- rbind(testset,trainset)




#each set has a value for each feature
tidygoof <- as.numeric(goof[[1]][-c(which(goof[[1]]==""))]) #goof is the set in a rows
