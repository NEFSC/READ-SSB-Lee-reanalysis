
#  NCEP North American Regional Reanalysis: NARR


The native model grid is converted to a Northern Lambert Conformal Conic grid which is what we archive. Corners of this grid are

    1.000001N, 145.5W; 
    0.897945N, 68.32005W; 
    46.3544N, 2.569891W; 
    46.63433N, 148.6418E

Regional North American Grid (Lambert Conformal)
used by NAM, SREF and RAP.

	
    Nx 	349
    Ny 	277
    La1 	1.000N
    Lo1 	214.500E = 145.500W
    Res. & Comp. Flag 	0 0 0 0 1 0 0 0
    Lov 	253.000E = 107.000W
    Dx 	32.46341 km
    Dy 	32.46341 km
    Projection Flag (bit 1) 	0
    Scanning Mode (bits 1 2 3) 	0 1 0
    Latin1 	50.000N
    Latin2 	50.000N
    Lat/Lon values of the corners of the grid
    (1,1) 	1.000N, 145.500W
    (1,277) 	46.635N, 148.639E
    (349,277) 	46.352N, 2.566W
    (349,1) 	0.897N, 68.318W
    Pole point
    (I,J) 	(174.507, 307.764)


The grid resolution is 349x277 which is approximately 0.3 degrees (32km) resolution at the lowest latitude. A page describing the coverage along with information on reading the projection is available.

http://www.nco.ncep.noaa.gov/pmb/docs/on388/tableb.html

	
	lon[1,1]=-145.5
	lon[1,277]=148.6418
	lon[349,277]=-2.56981
	lon[349,1]=-68.32005
	

	lat[1,1]=1.000001	
	lat[1,277]=46.6344
	lat[349,277]=46.3544
	lat[349,1]=0.897945

# Other data possibilities
1. ICOADS - air temp, cloud types

# Rejected data possibilities

1. NCEP Marine (stopped in Feb 2011)
1. NOAA's Outgoing Longwave Radiation–Daily Climate Data Record (OLR–Daily CDR): PSD Interpolated Version - not what I need




# Disclaimer
This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.
