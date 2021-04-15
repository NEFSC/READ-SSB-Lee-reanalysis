clear
cd "${data_main}"
import delimited {$data_main}/myfile.csv
save test.dta, replace

use test.dta, replace
gen double mytime=msofhours(elapsed) + mdyhms(1,1,1800,0,0,0)
format mytime %tc
order mytime
drop elapsed timestep
reshape long lat, i(lon mytime) j(glat)
rename lat kelvin
rename lon glon

assert glat>=10000
replace glat=glat/1000
order glat glon mytime
egen gridno=group(glat glon)
replace kelvin=round(kelvin,0.1)
order gridno mytime kelvin
save test.dta, replace
