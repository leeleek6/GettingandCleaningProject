download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "accelerometers.zip") #downloads data folder
gzfile("accelerometers.zip")
unzip("accelerometers.zip")