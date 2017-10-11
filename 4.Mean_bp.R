# This script can be run at any time, but we advise to run it after the 3.DyeAttributionPerMarker.R
# An Estimated mean size (Est.bp) will be calculated for each allele of each marker.

# The following lines will ensure that the columns Allele 1 and 2 and Size 1 and 2 are in 
# a numeric format
data$Allele.1<-as.numeric(data$Allele.1)
data$Allele.2<-as.numeric(data$Allele.2)
data$Size.1<-as.numeric(data$Size.1)
data$Size.2<- as.numeric(data$Size.2)

# size 1 will be defined by the aggregation of the marker and the allele 1 and the mean size will be computed
# the same is done for size 2.
# by default, the "NA" values are ignored on the calculation
ave.bp1 <- aggregate(Size.1~Marker+Allele.1,data=data,mean)
ave.bp2<- aggregate(Size.2~Marker+Allele.2,data=data,mean)
names(ave.bp1)[3] <- "Est.bp1"
names(ave.bp2)[3] <- "Est.bp2"

# Est.bp1 and 2 are rounded 2 decimals after the comma
ave.bp1$Est.bp1 <- round(ave.bp1$Est.bp1,2)
ave.bp2$Est.bp2 <- round(ave.bp2$Est.bp2,2)

# The Estimated mean size for Allele1 is incorporated into the dataset "data"
# merge by Marker and Allele.1
data<-merge(data,ave.bp1,by=c("Marker","Allele.1"))

# The Estimated mean size for Allele2 is incorporated into the dataset "data"
# merge by Marker and Allele.1
# the argument all.x = TRUE will add NA in case of homozygote or missing allele2

data<-merge(data,ave.bp2,by=c("Marker","Allele.2"),all.x = TRUE)
rm(ave.bp1,ave.bp2)
data.copy4<-data

