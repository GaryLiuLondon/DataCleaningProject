subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=F,col.names=c("subject"),colClasses="factor")
activity<-read.table("./UCI HAR Dataset/train/y_train.txt",header=F,col.names=c("activity"),colClasses="factor")
fheaders<-read.table("./UCI HAR Dataset/features.txt",header=F,sep=" ",col.names=c("serial","fcol"),colClasses=c("numeric","character"))
srcdata<-read.table("./UCI HAR Dataset/train/x_train.txt",header=F,col.names=fheaders$fcol,strip.white=T)
data<-cbind(subject,activity,group=rep(1,nrow(subject)),srcdata)

subject<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=F,col.names=c("subject"))
activity<-read.table("./UCI HAR Dataset/test/y_test.txt",header=F,col.names=c("activity"))

srcdata<-read.table("./UCI HAR Dataset/test/x_test.txt",header=F,col.names=fheaders$fcol,strip.white=T)
temp<-cbind(subject,activity,group=rep(2,nrow(subject)),srcdata)
data<-rbind(data,temp)

data$group<-factor(data$group)
levels(data$group)<-c("train","test")

mean<-apply(data[,4:564],2,mean)
sd<-apply(data[,4:564],2,sd)

activities<-read.table("./UCI HAR Dataset/activity_labels.txt",sep=" ",header=F,col.names=c("serial","activity"))
levels(data$activity)<-activities$activity

library(reshape2)
mdata<-melt(data,id.vars=c("subject","activity","group"))
result<-ddply(mdata,c("subject","variable"),summarize,average=mean(value))
colnames(result)[2]<-"features"
write.table(result,file="tidydata.txt",sep=",")
