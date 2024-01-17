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


library(here)

here::i_am("R_code/data_extraction_processing/processing/weather_in_script.R")
my_projdir<-here()
source(here("R_code","project_logistics","R_paths_libraries.R"))

#######################################################################
###################BEGIN data read in and verify ########################
#######################################################################

# Housekeeping - where are the nc files and where do you want the output to go
# hopefully you put the output of the netcdf stuff into data_external.
outname<-"climate_AB_all.dta"


#what are the names of the files to read and the variables you need to extract?
#setwd(data_intermediate)

ncfname1<-"ustm.stacked.nc"
dname1<-"ustm"

ncfname2<-"vstm.stacked.nc"
dname2<-"vstm"

ncfname3<-"uwind.stacked.nc"
dname3<-"uwnd"

ncfname4<-"vwind.stacked.nc"
dname4<-"vwnd"

###########################
# Read in ustm  from the first ncf file
  # Lat, lon.  Round to 3 digits and stack into 2 vectors
###########################

ncin1<-nc_open(file.path(data_intermediate,ncfname1))
print(ncin1)

#lat and lon are matrices with the same dimensions.  Not vectors.
lon <- ncvar_get(ncin1, "lon")
lat <- ncvar_get(ncin1, "lat")


z<-dim(lat)[1]*dim(lat)[2]

lat<-as.numeric(round(lat,digits=3))
lon<-as.numeric(round(lon,digits=3))

#PartA <- lat and lon are matrices.  We want to unstack in the same way. 
dim(lat)<-c(z,1)
dim(lon)<-c(z,1)

#read in time
t <- ncvar_get(ncin1, "time")
tmp.array1 <- ncvar_get(ncin1,dname1)
nc_close(ncin1)


###########################
# Read in vstm from the second ncf file
# Lat, lon.  Round to 3 digits and stack into 2 vectors
###########################

ncin2<-nc_open(file.path(data_intermediate,ncfname2))
print(ncin2)


lon2 <- ncvar_get(ncin2, "lon")
lat2 <- ncvar_get(ncin2, "lat")

z<-dim(lat2)[1]*dim(lat2)[2]


lat2<-as.numeric(round(lat2,digits=3))
lon2<-as.numeric(round(lon2,digits=3))

#PartA <- lat and lon are matrices.  We want to unstack in the same way. 
dim(lat2)<-c(z,1)
dim(lon2)<-c(z,1)


nlat2 <- dim(lat2)
nlon2 <- dim(lon2)
print(c(nlon2, nlat2))  # confirms the dimensions of the data

#Get the time variable and its attributes using the ncvar_get() and ncatt_get() functions, and also get the number of times using the dim() function.
t2 <- ncvar_get(ncin2, "time")


#Check that the time and grids are the same across the two.
stopifnot(identical(t,t2))
stopifnot(identical(lat, lat2))
stopifnot(identical(lon,lon2))

tmp.array2 <- ncvar_get(ncin2,dname2)


stopifnot(identical(dim(tmp.array1), dim(tmp.array2)))
nc_close(ncin2)






###########################
# Read in uwind from the 3rd ncf file
# Lat, lon.  Round to 3 digits and stack into 2 vectors
###########################

ncin3<-nc_open(file.path(data_intermediate,ncfname3))
print(ncin3)


lon3 <- ncvar_get(ncin3, "lon")
lat3 <- ncvar_get(ncin3, "lat")

z<-dim(lat3)[1]*dim(lat3)[2]


lat3<-as.numeric(round(lat3,digits=3))
lon3<-as.numeric(round(lon3,digits=3))

#PartA <- lat and lon are matrices.  We want to unstack in the same way. 
dim(lat3)<-c(z,1)
dim(lon3)<-c(z,1)


nlat3 <- dim(lat3)
nlon3 <- dim(lon3)
print(c(nlon3, nlat3))  # confirms the dimensions of the data

#Get the time variable and its attributes using the ncvar_get() and ncatt_get() functions, and also get the number of times using the dim() function.
t3 <- ncvar_get(ncin3, "time")


#Check that the time and grids are the same across the two.
stopifnot(identical(t,t3))
stopifnot(identical(lat, lat3))
stopifnot(identical(lon,lon3))

tmp.array3 <- ncvar_get(ncin3,dname3)


stopifnot(identical(dim(tmp.array1), dim(tmp.array3)))
nc_close(ncin3)






###########################
# Read in vwind from the 4th ncf file
# Lat, lon.  Round to 3 digits and stack into 2 vectors
###########################

ncin4<-nc_open(file.path(data_intermediate,ncfname4))
print(ncin4)





lon4 <- ncvar_get(ncin4, "lon")
lat4 <- ncvar_get(ncin4, "lat")

z<-dim(lat4)[1]*dim(lat4)[2]


lat4<-as.numeric(round(lat4,digits=3))
lon4<-as.numeric(round(lon4,digits=3))

dim(lat4)<-c(z,1)
dim(lon4)<-c(z,1)


nlat4 <- dim(lat4)
nlon4 <- dim(lon4)
print(c(nlon4, nlat4))  # confirms the dimensions of the data

#Get the time variable and its attributes using the ncvar_get() and ncatt_get() functions, and also get the number of times using the dim() function.
t4 <- ncvar_get(ncin4, "time")


#Check that the time and grids are the same across the two.
stopifnot(identical(t,t4))
stopifnot(identical(lat, lat4))
stopifnot(identical(lon,lon4))

tmp.array4 <- ncvar_get(ncin4,dname4)


stopifnot(identical(dim(tmp.array1), dim(tmp.array4)))
nc_close(ncin4)






#######################################################################
###################END data read in and verify ########################
#######################################################################

















# Finish up part 1 by constructing an identifier for the lat- and lon.  Instead of saving 2 variables (lat and lon), I save 1 variable "coord_id" and a keyfile that relates coord_id to lat and lon. 
# Seems silly but it saves a bunch of space.
coords<-cbind(lat,lon)
coords<-cbind(coords, "coord_id"=1:nrow(coords))
colnames(coords)<-c("lat","lon","coord_id")
coords_out<-data.frame(coords)
haven::write_dta(coords_out,file.path(data_main,"coords.dta"))  


ustm<-c(tmp.array1)
vstm<-c(tmp.array2)

uwnd<-c(tmp.array3)
vwnd<-c(tmp.array4)


#Part 4 
  #Replicate the coordinate id variable.  This is the way to do it, even though you always get confused about how to do rep.  
  coords<-rep(coords[,3], dim(tmp.array1)[3]) 
  
#Replicate the time variable.   This is the way to do it, even though you always get confused about how to do rep.  
  elapsed<-rep(t,each=z)
  #You might not want to data.frame this, depending on what you're doing.
  my.data<-data.frame(cbind(coords, elapsed, uwnd, vwnd, ustm, vstm ))
#   
#   
  timer1<-Sys.time()
  haven::write_dta(my.data,file.path(data_main,outname))  
  timer2<-Sys.time()
  
  
  
  
  
