# This script follows the script 1.Determination_H.R
# All the peak heights below the threshold previously set are replaced by "NA"

# 1.DROPOUT PER ALLELE
####################################### 
# the original dataset "data" is split in 2, in order to have one dataset with all the homozygous allele (data.hom)
# and one dataset with all the heterozygous allele (data.het)
data.hom<-subset(data, is.na(data$Allele.2))
data.het<-subset(data,!is.na(data$Allele.2))

# /!\ If you are using only heterozygous data (by example DNA007), you need to skip the part below on homozygous
if (is.data.frame(data.hom) && nrow(data.hom)==0) warning("no homozygous data")

####################################### 
# For heterozygous alleles, we look successively if the peak height from Allele 1 is "NA"
# then if the peak height from Allele 2 is "NA". If it is, we report 1 dropout, otherwise 0.

data.het<-within(data.het,{
        DO.H2<-ifelse(is.na(data.het$Height.2),1,0)
        DO.H1<-ifelse(is.na(data.het$Height.1),1,0)
})

# The column "Locus.DO" records if the 2 alleles are missing.
data.het<-within(data.het,{
  Locus.DO<-ifelse(is.na(data.het$Height.1)& is.na(data.het$Height.2),1,0)
})

####################################### 
# For homozygous allele, only the peak height from Allele 1 is consider and the eventuel
# dropout is reported in the column DO.H1 (2 if there is dropout, 0 if not)
# the column "Locus.DO" record 1 if the Allele 1 is missing, 0 otherwise

data.hom<-within(data.hom,{
        Locus.DO<-ifelse(is.na(data.hom$Height.1),1,0)
        DO.H2<-NA
        DO.H1<-ifelse(is.na(data.hom$Height.1),2,0)
})

####################################### 
# we bind the two datasets 
data<-rbind(data.hom,data.het)

# clean environment
rm(data.het,data.hom)

# 2.DROPOUT PER PROFILE
####################################### 
# in a temporaty dataframe "mat", we store the sample name and the H of each sample 
# sn (for sample.name) store the sample name from the temporary dataframe
mat<-unique(data[c("Sample.Name","H")])
sn<-mat$Sample.Name

# Sum of the dropout number per profile based on the dropout calculation 2.Calcul.DO.R
for(i in 1:length(sn)){
  # profile extraction corresponding to the name
  data.i<-data[data$Sample.Name==sn[i],]
  mat$DO.tot[i]<-sum(data.i$DO.H1,data.i$DO.H2,na.rm=TRUE)
}
rm(list=c("data.i","i","sn"))

data<-merge(data,mat,by=c("Sample.Name","H"))
rm(mat)
# Update of data.copy - new copy
data.copy2<-data

