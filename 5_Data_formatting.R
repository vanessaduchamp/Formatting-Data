# This script follows the script 4.Mean_bp.R

# Reshape the data by copying the main information: Sample.Name, Marker, RealQuantity, TheoreticalQuantity
# H, Dye, Type, Locus.DO, DO.tot and transferring the information concerning Allele.2 in the same column
# as Allele.1

data.reshaped <- reshape(data,direction="long",
                         idvar=c("Run.Name","Sample.File","Panel","Sample.Name","Marker","RealQuantity","TheoreticalQuantity","H","Dye","Type","Locus.DO","DO.tot"),
                         varying=matrix(paste(rep(c("Allele.","Size.","Height.","Peak.Area.","DO.H","Est.bp"),
                                                 each=2),rep(1:2,6),sep=""),6,2,byrow=TRUE))

# Remove Allele.1 containing NA. They were previously Allele.2 homozygote
data.reshaped<-data.reshaped[!is.na(data.reshaped$Allele.1),]

# scaling the data by subtracting the mean and dividing by the standard deviation
data.reshaped$H.scale<-scale(data.reshaped$H,center = TRUE,scale = TRUE)
data.reshaped$Est.bp1.scale<-scale(data.reshaped$Est.bp1,center = TRUE,scale = TRUE)
data.reshaped$Size.1.scale<-scale(data.reshaped$Size.1,center = TRUE,scale = TRUE)

# Extracting from Sample.Name, the sample number (removing information about replica)
data.reshaped$Sample.N<-gsub("(.*-.*)-.*","\\1",data.reshaped$Sample.Name)
rownames(data.reshaped)<-NULL

data.reshaped$time<-NULL

data.reshaped$TheoreticalQuantity <- as.numeric(data.reshaped$TheoreticalQuantity)

data<-data.reshaped
data.reshaped.copy1<-data
rm(data.reshaped,df)
