/* change this to your datadir */
cd "$data_main"


use latits
count

gen id=_n

reshape long X, i(id) j(lon_id)
rename X lat

tempfile l2
save `l2'


use longit
count

gen id=_n

reshape long X, i(id) j(lon_id)
rename X lon

tempfile lons

merge 1:1 id lon_id using `l2'
assert _merge==3
drop _merge
rename id lat_id

/*
the grid isn't "square", so that's kind of awkward.  
 I pulled down a random map, just to get a look.
 eyeballing it: 

YOUR Bottom left point
Your Top right point
 Alaska
 	Top Left : 72N,180W
 	Top Right: 72N,125W
 	Bottom Right: 45N, 125W
 	B-L: 45N, 180W


 
local TR_lat 72
local TR_lon -125

local BL_lat 45
local BL_lon -180


*/






local TR_lat 45
local TR_lon -60

local BL_lat 30
local BL_lon -80
 


/* dist will help you pull out the bottom left point */


gen dist=abs(`BL_lon'-lon)+abs(`BL_lat'-lat)
gen dist2=abs(`TR_lon'-lon)+abs(`TR_lat'-lat)


gen dist=abs(`my_lon_max'-lon)+abs(`my_lat_min'-lat)
gen dist2=abs(lon+60)+abs(45-lat)


sort dist
list if _n<=5
/* lat_id=257 or 258 and lon_id 88 or 89 is the bottom left point.There's a little slop

       +-------------------------------------------------------------+
       |  id   lon_id         lon        lat        dist       dist2 |
       |-------------------------------------------------------------|
    1. | 257       88   -80.14423   29.93357   .21066284   35.210663 |
    2. | 257       89   -80.03181   30.19219   .22399712   34.839617 |
    3. | 258       88   -79.84637   29.83606   .31757355   35.010307 |
    4. | 258       89   -79.73294   30.09415   .36120987    34.63879 |
    5. | 258       87   -79.95891   29.57817   .46292114   35.380737 |
       +-------------------------------------------------------------+


*/

sort dist2 
list if _n<=5
/* lat_id=281 and lon_id 162 is the top right point



       +-------------------------------------------------------------+
       |  id   lon_id         lon        lat        dist       dist2 |
       |-------------------------------------------------------------|
    1. | 281      161   -60.05504   45.14521   35.090172   .20024872 |
    2. | 282      160   -59.96411   44.73898   34.774868   .29690933 |
    3. | 282      161   -59.72226   44.97387    35.25161   .30387115 |
    4. | 281      160   -60.29619   44.90951   34.613323   .38667679 |
    5. | 281      162   -59.81174   45.38045    35.56871   .56871033 |
       +-------------------------------------------------------------+

 */


/*  Those answers feed into the ncks 
 
ncks -v air  -d y,88,162 -d x,257,281 air.2m.2004.nc -O subset_air.2m.2004.nc


*/


