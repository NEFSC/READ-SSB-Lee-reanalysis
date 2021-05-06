# You've put together two weather variables that have the same geographic and temporal extents (by cbind-ing).
# You did some checks on for the same same spatial extents for the two files
# You create an "id" field





# THIS is what I need to do, in 5 parts
# Part 1 read in the data, do some rudimentary data checks.
# Part2 <- lat and lon are matrices.  We want to unstack in the same way. 
# Part3 <- unstack the data (from a matrix into a vector).  c() goes down columns from column 1 to column C.  Then it does the same for the next matrix in the arra.
#    my.array <- array(1:100, dim=c(3,4,5))
#    mvec<-c(my.array)
#Part4 <- Make a coordinate and time vector that has the right dimensions.
# Part5 <-cbind things together


library(chron)
library(ncdf4)
library(foreign)

#######################################################################
###################BEGIN data read in and verify ########################
#######################################################################

# Housekeeping - where are the nc files and where do you want the output to go
# hopefully you put the output of the netcdf stuff into data_external.
outname<-"subset_air_lcdc"


#what are the names of the files to read and the variables you need to extract?
setwd(data_main)

ncfname<-"subset_air.2m.stacked.nc"
dname<-"air"

ncfname2<-"subset_lcdc.stacked.nc"
dname2<-"lcdc"



###########################
# Read in Air temp from the first ncf file
  # Lat, lon.  Round to 3 digits and stack into 2 vectors
###########################

ncin<-nc_open(paste0(data_external,ncfname))
print(ncin)

#lat and lon are matrices with the same dimensions.  Not vectors.
lon <- ncvar_get(ncin, "lon")
lat <- ncvar_get(ncin, "lat")


z<-dim(lat)[1]*dim(lat)[2]

lat<-as.numeric(round(lat,digits=3))
lon<-as.numeric(round(lon,digits=3))

#PartA <- lat and lon are matrices.  We want to unstack in the same way. 
dim(lat)<-c(z,1)
dim(lon)<-c(z,1)

#read in time
t <- ncvar_get(ncin, "time")
tmp.array <- ncvar_get(ncin,dname)
nc_close(ncin)


###########################
# Read in LCDC from the second ncf file
# Lat, lon.  Round to 3 digits and stack into 2 vectors
###########################

ncin2<-nc_open(paste0(data_external,ncfname2))
print(ncin2)


lon2 <- ncvar_get(ncin, "lon")
lat2 <- ncvar_get(ncin, "lat")


nlat2 <- dim(lat2)
nlon2 <- dim(lon2)
print(c(nlon2, nlat2))  # confirms the dimensions of the data

#Get the time variable and its attributes using the ncvar_get() and ncatt_get() functions, and also get the number of times using the dim() function.
t2 <- ncvar_get(ncin, "time")


#Check that the time and grids are the same across the two.
identical(t,t2)
identical(lat, lat2)
identical(lon,lon2)

tmp.array2 <- ncvar_get(ncin2,dname2)


identical(dim(tmp.array), dim(tmp.array2))
nc_close(ncin2)

#######################################################################
###################END data read in and verify ########################
#######################################################################

















# Finish up part 1 by constructing an identifier for the lat- and lon.  Instead of saving 2 variables (lat and lon), I save 1 variable "coord_id" and a keyfile that relates coord_id to lat and lon. 
# Seems silly but it saves a bunch of space.
coords<-cbind(lat,lon)
coords<-cbind(coords, "coord_id"=1:nrow(coords))
colnames(coords)<-c("lat","lon","coord_id")
coords_out<-data.frame(coords)
write.dta(coords_out,paste0(data_main,"coords.dta"), version=10, convert.dates=FALSE)  






# Part3 <- unstack the data (from a matrix into a vector).  c() goes down columns from column 1 to column C.  Then it does the same for the next matrix in the arra.
#your two variables are kelvin and lcdc. Cast them to vectors.
kelvin<-c(tmp.array)
lcdc<-c(tmp.array2)




#Part 4 
  #Replicate the coordinate id variable.  This is the way to do it, even though you always get confused about how to do rep.  
  coords<-rep(coords[,3], dim(tmp.array)[3]) 
  
#Replicate the time variable.   This is the way to do it, even though you always get confused about how to do rep.  
  elapsed<-rep(t,each=z)
  #You might not want to data.frame this, depending on what you're doing.
  my.data<-data.frame(cbind(coords, elapsed, kelvin, lcdc))
#   
#   
  timer1<-Sys.time()
  #write.table(my.data, file=paste0(data_main,ncfname,".csv"),  sep=",", col.names=TRUE, row.names=FALSE, append=FALSE)
  write.dta(my.data,paste0(data_main,outname,".dta"), version=10, convert.dates=FALSE)  
  timer2<-Sys.time()
  
  
  
  
  
