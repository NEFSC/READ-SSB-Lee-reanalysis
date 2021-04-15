# This is a Bash script to download, subset, and stack  NARR (reanalysis) data from NCEP
# In this case, I am getting air speed at 2m and cloud cover. You may want something else
# You need NCO

########################################################################
#https://www.esrl.noaa.gov/psd/data/gridded/data.narr.html
#	I chose this because the grid (approx 0.3 degrees) is smaller than the NCEP/NCAR
#	It is grid 221.https://www.esrl.noaa.gov/psd/data/narr/format.html
#	8x daily and daily are available.
#	The grid is irregular, which means that instead of an lat- and lon- vector,  there are lat- and and lon-matrices. It really messes with my head.

#Variables
#	air.2m: Air Temperature at 2 meters
#	LCDC : low cloud area fraction
########################################################################


########################
#Download them with wget:
########################

for YYYY in {2004..2019} 
	do wget ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/air.2m.$YYYY.nc&
	 wget ftp://ftp.cdc.noaa.gov/Datasets/NARR/monolevel/lcdc.$YYYY.nc&
done

########################
#Subset them with ncks
########################
for YYYY in {2004..2017} 
	do ncks -v air  -d y,88,162 -d x,250,281 air.2m.$YYYY.nc -O subset_air.2m.$YYYY.nc &
done
for YYYY in {2004..2017} 
	do ncks -v lcdc  -d y,88,162 -d x,250,281 lcdc.$YYYY.nc -O subset_lcdc.$YYYY.nc &
done

#ncks options  are:
#	-v <varname> 
#	-d y,88,162 -d x,250,281
#
#	  This extracts the y cells that are 88-162 and the x cells that are 250-281. This corresponds to the NER. I figured this out by using netcdf and extracting the lat and #        lon matrices, stacking them together and looking at them.  The base grid is 349x277, and I'm using a 32x74 unit subset.
#	Another way is to extract from y and x using the latitude and longitude
		#	-d latitude,40.,45. -d lon,-75.,-70.
		#	Note the periods.
		# I couldn't do this because the latitudes and longitudes are not vectors and i didn't quite know how to pass that in.
#	-O output file. I don't know why this is a capital O and not a lowercase o.

########################
#Concatenate them (optional step if you want to read 1 file into R instead of Many.
########################

ncrcat subset_air.2m.20??.nc subset_air.2m.stacked.nc
ncrcat subset_lcdc.20??.nc subset_lcdc.stacked.nc


# Should probably write somethine here to delete the large files that are left behind 
# rm air.2m*.nc lcdc.2m*.nc should work to get rid of the big files. 

