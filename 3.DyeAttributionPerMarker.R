# This script can be run at any time, but we advise to run it after the 2.Calcul_DO.R
# It is defined for NGMSElect kit
# Thank you to Hinda Haned for her writting help.

# The different markers are attributed to their respective dyes
Blue<-c("D2S1338","D16S539", "vWA", "D10S1248")
Green<-c("D18S51" ,"D21S11", "D8S1179")
Black<-c("FGA","TH01","D19S433", "D22S1045") 
Red<-c("SE33","D12S391","D1S1656","D3S1358","D2S441")

# creation of an empty vector  
tmp<-NULL

# The loop will go through the marker column of the dataset "data", and check to which dye belong the marker
# the dye color will be stored in the temporary vector (tmp)
for(i in data$Marker)
{
  if(i %in% Blue)
    tmp<-c(tmp,"blue")
  if(i %in% Green)
    tmp<-c(tmp,"green")
  if(i %in% Black)
    tmp<-c(tmp,"black")
  if(i %in% Red)
    tmp<-c(tmp,"red")
}

# control test to check that the lenght of the temporary vector is the same as the dataframe
if (length(tmp)!=length(data$Marker)) warning("the length of the temporary vector differs from the dataset")

# Add the dye information to our dataset "data"
data$Dye<-as.factor(tmp)

# clean environment
rm(Black,Blue,Green,Red,tmp,i)

# Update of data.copy - new copy
data.copy3<-data
  