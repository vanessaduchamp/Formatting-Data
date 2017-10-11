# This script follows the script 0.DataImportation.R
# it will determine for each replica, the H as defined by Tvedebrink et all 2009.

# Set a Threshold
Threshold<-30

# All the peak height from allele 1 and allele 2 which fall below the treshold will be
# replace by NA
data$Height.1<- replace(data$Height.1, data$Height.1 <Threshold, NA)
data$Height.2<- replace(data$Height.2, data$Height.2 <Threshold, NA)

# We order the data by sample name
data<-data[order(data$Sample.Name),]

# Samples name are extracted, as well of the run name
AllSampleName<-unique(data[c("Sample.Name","Run.Name")])

####################################### 
### H determination

# We create a temporary matrix which allow us to store the calculation before to merge them
# with the initial dataset.
final.mat<-matrix(nrow=nrow(AllSampleName), ncol=5)
colnames(final.mat)<-c("Sample.Name","Run.Name","Peak.Height.Sum","Nb.Allele","H")

# The first column of the final matrix contains all the sample name
# The second column contains all the run name.
final.mat[,1]<-AllSampleName[,1]
final.mat[,2]<-AllSampleName[,2]

# In a loop, we extract all the line corresponding to a sample i, called bellow data.i. 
# The loop stops once all the samples analysed
for(i in 1:nrow(AllSampleName)){
        data.i<-data[data$Sample.Name == AllSampleName[i,1]&
                             data$Run.Name == AllSampleName[i,2],]
        
        # We calculate the peak height sum for data.i
        final.mat[i,3]<-sum(data.i$Height.1,data.i$Height.2,na.rm=TRUE)
        
        # we initialise a new variable in charge to count the   
        # number of present allele in the profile
        # we need to make a difference between homozygous and heterozygous alleles
        count.a<-0
        # A new loop goes from line to line along the column of data.i and count the number
        # of allele present. 
        # It adds 1 per heterozygous allele present and 2 for an homozygous allele present
        for (j in 1:nrow(data.i)){
                
          # For height.1, allele 1 is always present, but if there is a dropout, count.a doesn't increase
          # if allele 1 is amplified (no dropout), it could be either an homozygous or heterozygous allele
          if(is.na(data.i[j,"Height.1"]=="TRUE")){count.a<-count.a}
          else{
            # If there is no dropout, look if Allele 2 is present. If yes +1 (heterozygous) if no +2 (homozygous)
            if (is.na(data.i[j,"Allele.2"]=="TRUE")){count.a<-count.a+2}
            else{count.a<-count.a+1}}
          # Then we check if there is an allele amplified for under height 2. If no allele, it could be either
          # a dropout, either an homozygous, so count.a doesn't increase.
          # if there is no dropout +1
          if(is.na(data.i[j,"Height.2"]=="TRUE")){count.a<-count.a}
          else{count.a<-count.a+1}
          
        }
        
        # In the matrix, we transfer the number of allele defined bellow
        final.mat[i,4]<-count.a
        # then we calculate the H as the sum of the peak height divided by the number of allele 
        # rounded at 2 decimal.
        final.mat[i,5]<-round(as.numeric(final.mat[i,3])/as.numeric(final.mat[i,4]),2)
        
}

####################################### 
# We merge the matrix previously used to store our new data with our initial dataset.
data<-merge(data,final.mat,by=c("Sample.Name","Run.Name"))

# We check that our H is evaluated by R as numeric
data$H<-as.numeric(as.character(data$H))

# We remove all the values and data that we don't need anymore
rm(count.a,i,j,data.i,final.mat,AllSampleName)


####################################### 
# In a new column, we determine if the allele are homozygote (0) or heterozygote (1)
data<-within(data,{
  Type<-ifelse(is.na(data$Allele.2),0,1)
})

####################################### 
# Clean the data frame by removing Peak.Height.Sum and Nb.Allele
data$Peak.Height.Sum<-NULL
data$Nb.Allele<-NULL

# Update of data.copy - new copy
data.copy1<-data
