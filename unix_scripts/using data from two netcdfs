

########################
# put variables from 2 datasets together
# download, subset to NER, append together and do some math
# I verified this works by checking against Lisa's R code. The windspeed variable is different by 1e-6, which I attribute to storing data as float instead of double.  
	#I wouldn't worry abou this 
	#after the download step, the process takes less 1 minute to do a year of data.	
########################
wget ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/uwnd.10m.2014.nc
wget ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/vwnd.10m.2014.nc


ncks -v vwnd  -d y,88,162 -d x,250,281 vwnd.10m.2014.nc -O subset_vwind.2014.nc
ncks -v uwnd  -d y,88,162 -d x,250,281 uwnd.10m.2014.nc -O subset_uwind.2014.nc

#make a copy of uwind, since the next command merges *into* uwind
cp subset_uwind.2014.nc subset_uwind.2014.nc.bak

#merge vwind into uwind
#ncks -A does a merge on lat, lon, and t. no clue what happens if these are not the same dimensions.

ncks -A  subset_vwind.2014.nc  subset_uwind.2014.nc

#Rename
mv subset_uwind.2014.nc subset_bothwind.2014.nc
mv subset_uwind.2014.nc.bak subset_uwind.2014.nc 
########################
#New windspeed variable
########################
ncap -O -s "windspeed=sqrt(uwnd^2+vwnd^2)" subset_bothwind.2014.nc  speed.2014.nc

#remove the bothwind file
rm subset_bothwind.2014.nc
