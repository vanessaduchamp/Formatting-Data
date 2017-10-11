# This script imports the file arranged.file.csv
# Please go through the script to complete the information
# to import more that 2 files into your dataframe, please copy the second part "2nd file to import", and
# past it at the end of the 2nd File to import.

########## 1st File to import
# set the pass to your file. Use the key "Tab" for automatic completion
setwd("~/")
data<-read.table("arranged.file.csv",sep=",",dec=".",na.strings = "",h=TRUE)

# Add a column "TheoreticalQuantity". The theoretical quantity will be extracted from the Sample Name
data<-within(data, {
  TheoreticalQuantity<-gsub(".*-(.*)-.*","\\1",data$Sample.Name)
})
data$TheoreticalQuantity<-gsub("[^0-9.]","",data$TheoreticalQuantity)

# Add a column with the real, measured quantity
# firstly we copy the information from the Theoretical Quantity column
# secondly we assign the measured DNA quantities
data<-within(data,{
  RealQuantity<-data$TheoreticalQuantity 
})

# replace 0.0 by the Theoretical Quantities
# replace 1.1 by the Real Quantities
data$RealQuantity[data$RealQuantity==0.0]<-1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<-1.1

# Check that all factors are turned into character
i<-sapply(data,is.factor)
data[i]<-lapply(data[i],as.character)

# copy the dataframe "data" in a temporary dataframe "df"
df<-data

########## 2nd File to import
# change the pass if the file is not on the same folder. The script is the same as below
#setwd("~/")
data<-read.table("arranged.file.csv",sep=",",dec=".",na.strings = "",h=TRUE)
# Add a column "TheoreticalQuantity". The theoretical quantity will be extracted from the Sample Name
data<-within(data, {
  TheoreticalQuantity<-gsub(".*-(.*)-.*","\\1",data$Sample.Name)
})
data$TheoreticalQuantity<-gsub("[^0-9.]","",data$TheoreticalQuantity)

# Add a column with the real, measured quantity
# firstly we copy the information from the Theoretical Quantity column
# secondly we assign the measured DNA quantities
data<-within(data,{
  RealQuantity<-data$TheoreticalQuantity 
})

# replace 0.0 by the Theoretical Quantities
# replace 1.1 by the Real Quantities
data$RealQuantity[data$RealQuantity==0.0]<-1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<- 1.1
data$RealQuantity[data$RealQuantity==0.0]<-1.1

# Check that all factors are turned into character
i<-sapply(data,is.factor)
data[i]<-lapply(data[i],as.character)

# we bind the new dataframe "data" with the temporary dataframe "df", as "data" is always used for new data
df<-rbind(df,data)
##########
# Past here the section below if you want to import more than 2 files




########## 
# copy the temporary dataframe "df" containing all the import files under data
data<-df
# we remove all the information about the Amelogenin
data<-data[!data$Marker=="AMEL",]
# we make a backup of the dataframe "data"
data.copy0<-data 
# clean the environment by 
rm(i, df)



