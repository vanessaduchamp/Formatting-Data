# This script imports the file arranged.file.csv for data degraded
# Please go through the script to complete the information
# to import more than 2 files into your dataframe, please copy the second part "2nd file to import", and
# past it at the end of the 2nd File to import.

# All Files will be merge on a dataset called "data".
# The person name (Pers1 or Pers2...) and the degradation time (3weeks or 6weeks...) are
# extracted from the data.

# Use the key "tab" for automatic completion. The files are considered to be in the same folder
setwd("~/")

########## 1st File to import
data<-read.table("arranged_file.csv",sep=",",dec=",",
                 na.strings = "",stringsAsFactors=FALSE,
                 h=TRUE)

data<-within(data, {
  Sample.N<-gsub("(.*-.*)-.*","\\1",data$Sample.Name)
  DegradationTime<-gsub(".*-(.*)-.*","\\1",data$Sample.Name)
  UserName<-gsub("(*)-.*-*","\\1",data$Sample.Name)
  
})

# we bind the new dataframe "data" with the temporary dataframe "df", as "data" is always used for new data
df<-data

########## 2nd File to import
data<-read.table("arranged_file.csv",sep=",",dec=",",
                 na.strings = "",stringsAsFactors=FALSE,
                 h=TRUE)

data<-within(data, {
  Sample.N<-gsub("(.*-.*)-.*","\\1",data$Sample.Name)
  DegradationTime<-gsub(".*-(.*)-.*","\\1",data$Sample.Name)
  UserName<-gsub("(*)-.*-*","\\1",data$Sample.Name)
  
})
df<-rbind(df,data)

##########
# Past here the section below if you want to import more than 2 files




##########

# Check that all factors are turned into character
i<-sapply(data,is.factor)
data[i]<-lapply(data[i],as.character)

# copy the temporary dataframe "df" containing all the import files under data
data<-df

# clean the environment
rm(i,df)

# we remove all the information about the Amelogenin
data<-data[!data$Marker=="AMEL",]

# convert all the variable into the numeric format for further analyses
data$Allele.1<-as.numeric(data$Allele.1)
data$Size.1<-as.numeric(data$Size.1)
data$Height.1<-as.numeric(data$Height.1)
data$Peak.Area.1<-as.numeric(data$Peak.Area.1)
data$Allele.2<-as.numeric(data$Allele.2)
data$Size.2<-as.numeric(data$Size.2)
data$Height.2<-as.numeric(data$Height.2)
data$Peak.Area.2<-as.numeric(data$Peak.Area.2)




