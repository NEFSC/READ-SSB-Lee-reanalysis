

########################
# Download uwnd and vwnd. Download vstm and ustm.
# subset to NER, append together and do some math
# I verified this works by checking against Lisa's R code. The windspeed variable is different by 1e-6, which I attribute to storing data as float instead of double.  
	#I wouldn't worry about this 
	#after the download step, the process takes less 1 minute to do a year of data.	
########################


# Download with wget. 
for YYYY in {2005..2023}
do
	 wget -q ftp://ftp2.psl.noaa.gov/Datasets/NARR/monolevel/uwnd.10m.$YYYY.nc  &
	 wget -q ftp://ftp2.psl.noaa.gov/Datasets/NARR/monolevel/vwnd.10m.$YYYY.nc  &
	 wget -q ftp://ftp2.psl.noaa.gov/Datasets/NARR/monolevel/vstm.$YYYY.nc  & 
	 wget -q ftp://ftp2.psl.noaa.gov/Datasets/NARR/monolevel/ustm.$YYYY.nc 
done


# subset these to my grid
for YYYY in {2005..2023} 
do 
	ncks -v vwnd  -d y,88,162 -d x,250,281 vwnd.10m.$YYYY.nc -O subset_vwind.$YYYY.nc &
	ncks -v uwnd  -d y,88,162 -d x,250,281 uwnd.10m.$YYYY.nc -O subset_uwind.$YYYY.nc 
done


for YYYY in {2005..2023} 
do 
	ncks -v vstm  -d y,88,162 -d x,250,281 vstm.$YYYY.nc -O subset_vstm.$YYYY.nc &
	ncks -v ustm  -d y,88,162 -d x,250,281 ustm.$YYYY.nc -O subset_ustm.$YYYY.nc 
done


#make a copy of uwind, since the next command merges *into* uwind

for YYYY in {2005..2023} 
do
  cp subset_uwind.$YYYY.nc subset_uwind.$YYYY.nc.bak
  cp subset_ustm.$YYYY.nc subset_ustm.$YYYY.nc.bak

done


#merge vwind into uwind. Merge vstm into ustm.
#ncks -A does a merge on lat, lon, and t. no clue what happens if these are not the same dimensions.
#Rename the "right file" (uwind) to bothwind. rename the uwind.bak to uwind


########################
# This code is untested
# make a dataset with windspeed and a dataset with direction
# if pi isn't available, you can do
# 4*atan(1.0) or 2*acos(0.0) or acosl(-1)
########################
#for YYYY in {2014..2022} 
# do
#  ncap2 -O -s 'windspeed=sqrt(uwnd^2+vwnd^2)' subset_bothwind.$YYYY.nc  speed.$YYYY.nc & 
#  ncap2 -O -s 'winddir=(270-atan2(vwnd,uwnd)*180/pi)%360 ' subset_bothwind.$YYYY.nc  direction.$YYYY.nc
#  rm subset_bothwind.$YYYY.nc
#done


########################
# Concatenate them and put the results in data/intermediate
########################

ncrcat subset_ustm.20??.nc ustm.stacked.nc
ncrcat subset_vstm.20??.nc vstm.stacked.nc

ncrcat subset_uwind.20??.nc uwind.stacked.nc
ncrcat subset_vwind.20??.nc vwind.stacked.nc


# cleanup

rm subset_ustm.*.nc
rm subset_vstm.*.nc

rm subset_uwind.*.nc
rm subset_vwind.*.nc


#rm uwnd*.nc
#rm vwnd*.nc
#rm ustm*.nc
#rm vstm*.nc

#  rm speed.20??.nc
#  rm direction.20??.nc

# copy over to the data_intermediate folder

#After this finishes executing, you can use your R code to run the weather_in_script.R


