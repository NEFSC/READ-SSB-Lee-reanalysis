/* this should work, but I have not tested it recently */
/*All of the data from 2004-2006 for buoys 44005, 44008, 44009, 44011, and 44025 
are not getting processed properly. */

cd "${data_raw}"
pause on

local stationlist  44011 44008  44020  44090 44065 44099 44096 44005 44098 44013  44029 44027 44097 41062  44095 41025 44037 wahv2 44007 44025 44091 44034 44025 44017 44402 44066 44009 44088 44014 44018 robn4 44069 lwsd1 mtkn6 ntkm3 buzm3 mdrm1 mism1 iosn3 44150 44024 psbm1 cfwm1  atgm1 44033 44032 44030



foreach station of local stationlist{
foreach year of numlist 2004(1)2016{
	/* modfiy this to check if I already have the txt.gz, don't download it. */

	capture confirm file `station'h`year'.txt.gz
	if _rc==0{

	}
	else {
	capture copy http://www.ndbc.noaa.gov/data/historical/stdmet/`station'h`year'.txt.gz `station'h`year'.txt.gz
	}
}
}
pause
! gunzip -k *.gz



*local myflist: dir "http://www.ndbc.noaa.gov/data/historical/stdmet" files "*.txt"

local myflist: dir . files "*.txt"

quietly foreach l of local myflist{
	clear
	tempfile new
	local NEWfiles `"`NEWfiles'"`new'" "'  

	import delimited using `l', delimiter(space, collapse) varnames(1) rowrange(3:)
	gen str15 source="`l'"
	destring, replace
	capture rename v5 minutes
	save `new'
}

dsconcat `NEWfiles'
	renvarlab, lower
	compress
*	rename v5 minutes
	replace yy=yyyy if yy==.
	drop yyyy

split source, parse(".") gen(sa)
gen year=real(substr(sa1,-4,4))
gen buoy=substr(sa1,1,5)
drop source sa2

*Some of the 2004 data has no  minutes variable.
replace minutes=0 if year==2004 & minutes==.
gen mydate=mdyhms(mm,dd,year,hh,minutes,0)
format mydate %tc

order buoy mydate
sort buoy year mm mydate

drop yy mm dd hh minutes

encode buoy, gen(myid)
drop buoy
rename myid buoy

bysort buoy mydate: gen marker=_N
sort buoy mydate marker pres
gen dropper=0
bysort buoy mydate marker (pres): replace dropper=1 if marker==2 & _n>=2
drop if dropper==1
drop dropper marker
xtset buoy mydate
compress
replace atmp=. if atmp>=999
gen atmpf=32+9/5*atmp
drop sa1 year
note atmpf: air temp fahrenheit
save "/${data_main}/stacked_weather_data.dta", replace

keep buoy 
gen mark=0
bysort buoy: replace mark=1 if _n==1
keep if mark==1


gen lat=0
gen lon=0

decode buoy, gen(myb)
rename buoy myid
rename myb buoy

replace lat=40.251 if strmatch(buoy,"44025")
replace lon=73.164 if strmatch(buoy,"44025")


replace lat=44.287 if strmatch(buoy,"44027")
replace lon=67.307 if strmatch(buoy,"44027")

replace lat=42.523 if strmatch(buoy,"44029")
replace lon=70.566 if strmatch(buoy,"44029")


replace lat=42.798 if strmatch(buoy,"44098")
replace lon=70.168 if strmatch(buoy,"44098")
replace lat=43.20 if strmatch(buoy,"44005")
replace lon=69.12 if strmatch(buoy,"44005")

replace lat=40.37 if strmatch(buoy,"44065")
replace lon=73.70 if strmatch(buoy,"44065")


replace lat=41.397 if strmatch(buoy,"buzm3")
replace lon=71.033 if strmatch(buoy,"buzm3")


replace lat=41.048 if strmatch(buoy,"mtkn6")
replace lon=71.959 if strmatch(buoy,"mtkn6")

replace lat=41.08 if strmatch(buoy,"44011")
replace lon=66.62 if strmatch(buoy,"44011")

replace lat=40.50 if strmatch(buoy,"44008")
replace lon=69.23 if strmatch(buoy,"44008")

replace lat=41.285 if strmatch(buoy,"ntkm3")
replace lon=70.096 if strmatch(buoy,"ntkm3")

replace lat=41.439 if strmatch(buoy,"44020")
replace lon=70.186 if strmatch(buoy,"44020")

replace lat=43.525 if strmatch(buoy,"44007")
replace lon=70.141 if strmatch(buoy,"44007")



replace lat=39.778 if strmatch(buoy,"44091")
replace lon=73.769 if strmatch(buoy,"44091")



replace lat=43.491 if strmatch(buoy,"44037")
replace lon=67.879 if strmatch(buoy,"44037")

replace lat=43.969 if strmatch(buoy,"mdrm1")
replace lon=68.238 if strmatch(buoy,"mdrm1")




replace lat=40.694 if strmatch(buoy,"44017")
replace lon=72.048 if strmatch(buoy,"44017")



replace lat=39.298 if strmatch(buoy,"44402")
replace lon=70.659 if strmatch(buoy,"44402")


replace lat=39.57 if strmatch(buoy,"44066")
replace lon=72.58 if strmatch(buoy,"44066")

replace lat=38.45 if strmatch(buoy,"44009")
replace lon=74.70 if strmatch(buoy,"44009")

replace lat=42.327 if strmatch(buoy,"44024")
replace lon=65.912 if strmatch(buoy,"44024")

replace lat=36.612 if strmatch(buoy,"44088")
replace lon=74.838 if strmatch(buoy,"44088")

replace lat=36.611 if strmatch(buoy,"44014")
replace lon=74.843 if strmatch(buoy,"44014")

replace lat=42.500 if strmatch(buoy,"44150")
replace lon=64.02 if strmatch(buoy,"44150")

replace lat=42.119 if strmatch(buoy,"44018")
replace lon=69.7 if strmatch(buoy,"44018")

replace lat=43.784 if strmatch(buoy,"mism1")
replace lon=68.855 if strmatch(buoy,"mism1")




replace lat=35.750 if strmatch(buoy,"44095")
replace lon=75.33 if strmatch(buoy,"44095")

replace lat=35.778 if strmatch(buoy,"41062")
replace lon=75.095 if strmatch(buoy,"41062")

replace lat=35.005 if strmatch(buoy,"41025")
replace lon=75.403 if strmatch(buoy,"41025")


replace lat=37.023 if strmatch(buoy,"44096")
replace lon=75.809 if strmatch(buoy,"44096")

replace lat=36.915 if strmatch(buoy,"44099")
replace lon=75.72 if strmatch(buoy,"44099")



replace lat=38.783 if strmatch(buoy,"lwsd1")
replace lon=75.119 if strmatch(buoy,"lwsd1")

replace lat=39.357 if strmatch(buoy,"acyn4")
replace lon=74.418 if strmatch(buoy,"acyn4")


replace lat=37.608 if strmatch(buoy,"wahv2")
replace lon=75.686 if strmatch(buoy,"wahv2")


replace lat=40.699 if strmatch(buoy,"44069")
replace lon=73.087 if strmatch(buoy,"44069")


replace lat=40.657 if strmatch(buoy,"robn4")
replace lon=74.065 if strmatch(buoy,"robn4")

replace lat=40.969 if strmatch(buoy,"44097")
replace lon=71.127 if strmatch(buoy,"44097")


replace lat=41.840 if strmatch(buoy,"44090")
replace lon=70.329 if strmatch(buoy,"44090")


replace lat=42.346 if strmatch(buoy,"44013")
replace lon=70.651 if strmatch(buoy,"44013")


replace lat=43.181 if strmatch(buoy,"44030")
replace lon=70.428 if strmatch(buoy,"44030")


replace lat=43.716 if strmatch(buoy,"44032")
replace lon=69.355 if strmatch(buoy,"44032")

replace lat=44.106 if strmatch(buoy,"44034")
replace lon=68.109 if strmatch(buoy,"44034")

replace lat=44.055 if strmatch(buoy,"44033")
replace lon=68.998 if strmatch(buoy,"44033")

replace lat=44.392 if strmatch(buoy,"atgm1")
replace lon=68.204 if strmatch(buoy,"atgm1")

replace lat=44.905 if strmatch(buoy,"psbm1")
replace lon=66.983 if strmatch(buoy,"psbm1")

replace lat=44.657 if strmatch(buoy,"cfwm1")
replace lon=67.205 if strmatch(buoy,"cfwm1")

replace lat=42.967 if strmatch(buoy,"iosn3")
replace lon=70.623 if strmatch(buoy,"iosn3")









rename lon blon
rename lat blat
drop buoy mark
rename myid buoy
save "${data_main}/buoy_key.dta", replace
!rm *.txt

cd ..



/* NDBC has
	SRAD1, SWRAD: Average shortwave radiation in watts per square meter for the preceding hour. Sample frequency is 2 times per second (2 Hz). If present, SRAD1 is from a LI-COR LI-200 pyranometer sensor, and SWRAD is from an Eppley PSP Precision Spectral Pyranometer.


Longwave Radiation (LWRAD)
	Average downwelling longwave radiation in watts per square meter for the preceding hour. Sample frequency is 2 times per second (2 Hz). If present, LWRAD is from an Eppley PIR Precision Infrared Radiometer


ATMP 	Air temperature (Celsius). For sensor heights on buoys, see Hull Descriptions. For sensor heights at C-MAN stations, see C-MAN Sensor Locations




When I grabbed these data, I didn't find SRAD1, SWRAD, or LWRAD. I did get ATMP





Both Realtime and Historical files show times in UTC only


#yr  mo dy hr mn degT m/s  m/s     m   sec   sec degT   hPa  degC  degC  degC  nmi  hPa    ft




Stations:
MTKN6 Montauk 41.048 71.959
44011 - Georges 41.08N 66.62W
44008 - nantucket lightship 40.50N 69.23W
NTKM3 nantucket 41.285 70.096
44020 nantucket sound 41.439 70.186

BUZM3 -- buzzards bay 41.397 71.033
44065 - Breezy harbor 40.37N 73.70W
44005 - GOM Portsmouth  43.20N 69.12W
44098 - Jeffreys Ledge 42.798 70.168 
44029 NERACOOS Mass Bay 42.523 70.566
44027 Jonesport 44.287 67.307

44037 JOrdan basin 43.491 67.879 
MDRM1 Mount desert rock island 43.969 68.238
44007 Portland 43.525 70.141 
44025 40.251 73.164
44091 - Barnegat 39.778N 73.769W
44025 - Long island 40.25N 73.15W
44017 - Montauk Point 40.694 72.048
44402 - SE block canyon 39.298 70.659
44066 - Texas Tower Hudson canyon 39.57N 72.58W
44009 - Delaware bay 38.45N 74.70W
44088 - scrippps VB 36.612 74.838
44014 VG 36.611 74.843
*44089 Wallops 37.757 75.334 (not enough data)
44018 42.119 69.7
MISM1 - Manticus Rock, ME  43.784 68.855  http://www.ndbc.noaa.gov/data/historical/stdmet/mism1h2004.txt.gz
*/

