Getting and Cleaning Data, Course Project CodeBook
---------------------------

1. Read train data


```r
subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=F,col.names=c("subject"),colClasses="factor")
activity<-read.table("./UCI HAR Dataset/train/y_train.txt",header=F,col.names=c("activity"),colClasses="factor")
fheaders<-read.table("./UCI HAR Dataset/features.txt",header=F,sep=" ",col.names=c("serial","fcol"),colClasses=c("numeric","character"))
srcdata<-read.table("./UCI HAR Dataset/train/x_train.txt",header=F,col.names=fheaders$fcol,strip.white=T)
data<-cbind(subject,activity,group=rep(1,nrow(subject)),srcdata)
```

2. Read test data


```r
subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=F,col.names=c("subject"))
activity<-read.table("./UCI HAR Dataset/test/y_test.txt",header=F,col.names=c("activity"))

srcdata<-read.table("./UCI HAR Dataset/test/x_test.txt",header=F,col.names=fheaders$fcol,strip.white=T)
temp<-cbind(subject,activity,group=rep(2,nrow(subject)),srcdata)
```

3. Merge train and test data in a single data frame


```r
data<-rbind(data,temp)
```

```
## Warning: invalid factor level, NA generated
```
4. Convert `group` variable into factor


```r
data$group<-factor(data$group)
levels(data$group)<-c("train","test")
```

5. Calculate the mean and standard deviation of each variable


```r
mean<-apply(data[,4:564],2,mean)
sd<-apply(data[,4:564],2,sd)
```

6.Use descriptive activity name to name the activities


```r
activities<-read.table("./UCI HAR Dataset/activity_labels.txt",sep=" ",header=F,col.names=c("serial","activity"))
levels(data$activity)<-activities$activity
```

7.Appropriately labels the data set with descriptive variable names. 

This is not necessary, as this step has been done during data reading using col.names.

8.Generate a tidy dataset to include average value of each variable for each activity of each subject


```r
library(reshape2)
library(plyr)
mdata<-melt(data,id.vars=c("subject","activity","group"))
result<-ddply(mdata,c("subject","variable"),summarize,average=mean(value))
colnames(result)[2]<-"features"
write.table(result,file="tidydata.txt",sep=",")
```
