/* run this after you run the unix scripts to extract and stack the data*/
use "${data_raw}/subset_air.2m.stacked.nc.dta" if _n<=10000, replace
keep if elapsed==elapsed[1]
count
keep lat lon
egen gridpoint=group(lat lon)

order gridpoint
compress
save "${data_main}/grid_key.dta", replace

/*  cross grid_key with trip lats and lons to add cells to trips
	keep if distance is small (4 nearest points)
	merge the gridkey with the weather data to add weather data to the trips.	
   
The gridkey makes mergeing a little easier.


 */

tempfile t1
use subset_air.2m.stacked.nc.dta, clear
merge m:1  lat lon using "/${data_main}/grid_key.dta", nogenerate
drop lat lon
save `t1'


use subset_lcdc.stacked.nc.dta, clear
merge m:1  lat lon using "$data_main/grid_key.dta", nogenerate
drop lat lon

merge 1:1 gridpoint elapsed using `t1', nogenerate
save "${data_main}/combined_weather.dta", replace
