# Subsetting Grid 221. 
# The grid is 349x277.  This covers north america.
# There are 349x277 latitude points and 349x277 longitude points. They are stored in two separate matrices in netcdf.
# It's very unituitive to me.  
# In order to subset with NCKS, you need to describe the coordinates that you want by using the cell indices.
# Basically: draw a box.  Then figure out the index positions corresponding to the them.  
# It's very messy though, because the box is sheared 


# let's pull out a subset:
# In order to subset, you need to find the cell indices in lat and lon.  


# the grid isn't "square", so that's kind of awkward.  

library(chron)
library(ncdf4)
library(foreign)
library(reshape)

datadir<-"/home/mlee/Documents/projects/weather/raw_narr/"
savedir<-"/home/mlee/Documents/projects/weather/raw_narr/"
setwd(savedir)

ncfname<-"yycompos.155.206.138.89.85.6.43.59.nc"

ncin<-nc_open(paste0(datadir,ncfname))
print(ncin)

lon <- ncvar_get(ncin, "lon")
lat <- ncvar_get(ncin, "lat")




latits<-data.frame(lat)
write.dta(latits,paste0(savedir,"latits.dta"), version=10, convert.dates=FALSE)  

longit<-data.frame(lon)
write.dta(longit,paste0(savedir,"longit.dta"), version=10, convert.dates=FALSE)  
