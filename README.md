linz-bernese52-util
===================

This repository adds LINZ custom components to the bernese software.  This includes a number of user programs integrated into the Bernese MENU/PCF system (bernese/GPS/PAN), and some utilities for managing bernese files.  

Note that some additional LINZ bernese utilities are maintained in the [linz-bernese52](https://github.com/linz/linz-bernese52-private) repository.  This scripts are also
tightly integrated with the perl [LINZ/BERN](https://github.com/linz/liblinz-bern-perl) and [LINZ/GNSS](https://github.com/linz/liblinz-gnss-perl) modules.

The scripts integrated into the Bernese menu system are:

* GETDATA: A script for retrieving online GNSS resources such as RINEX files, orbit data, etc.  The online resources are configured in the getdata.conf configuration file.

* IGS2STA: Creates or updates a station information file based on IGS site logs

* MAKEBLQ: Compiles ocean loading information for stations

* NZGDBCRD: Update station coordinate information from the LINZ geodetic database

* SNX2CRD: Update a station coordinate file based on a SINEX file.

This repository also contains data to pre-populate the datapool with site log data to reduce the initial download of site log data.

NOTE: the data in datapool/sitelogs will be updated by the daily maintenance scripts.  This is not
the place for additional site logs that are not maintained by this process.  They should go in the
linz-bernese-configuration repository.

## Creating ocean loading source files

The MAKEBLQ program uses ocean loading coefficient files to generate the corrections.  These have been generated using the service provided by
the Swedish Chalmers University of Technology.  The service is provided by [http://holt.oso.chalmers.se/loading/] (Note: in 2025 this was unavailable
and instead provided a link to an alternative service at [https://barre.oso.chalmers.se/loading/l.php].)

The service allows uploading a file of station ids and coordinates, and returns a file of coefficients for each station.  The upload file looks like:

```text
10011                            166.900         -46.725           0.000
10012                            166.900         -46.650           0.0000
...
```

and the file returned is

```text
$$ Ocean loading displacement
$$
$$ OTL provider: http://holt.oso.chalmers.se/loading/
$$ Created by Scherneck & Bos
$$
$$ COLUMN ORDER:  M2  S2  N2  K2  K1  O1  P1  Q1  MF  MM SSA
$$
$$ ROW ORDER:
$$ AMPLITUDES (m)
$$   RADIAL
$$   TANGENTL    EW
$$   TANGENTL    NS
$$ PHASES (degrees)
$$   RADIAL
$$   TANGENTL    EW
$$   TANGENTL    NS
$$
$$ Displacement is defined positive in upwards, South and West direction.
$$ The phase lag is relative to Greenwich and lags positive. The PREM
$$ Green's function is used. The deficit of tidal water mass in the tide
$$ model has been corrected by subtracting a uniform layer of water with
$$ a certain phase lag globally.
$$
$$ CMC:  NO (corr.tide centre of mass)
$$
$$ A constant seawater density of 1030 kg/m^3 is used.
$$
$$ A thin tidal layer is subtracted to conserve water mass.
$$
$$ FES2014b: m2 s2 n2 k2 k1 o1
$$ FES2014b: p1 q1 Mf Mm Ssa
$$
$$ END HEADER
$$
  10011
$$ FES2014b ID:2025-08-03 01:06:38
$$ Computed using CARGA
$$ 10011                   RADI TANG  lon/lat: 166.9000  -46.7250     0.000
  .01668 .00565 .00416 .00168 .00296 .00384 .00105 .00111 .00107 .00058 .00050
  .00553 .00069 .00120 .00014 .00082 .00076 .00027 .00019 .00001 .00001 .00001
  .00529 .00136 .00103 .00040 .00167 .00132 .00052 .00029 .00015 .00010 .00009
   175.9 -163.1  165.6 -171.1   91.7   41.3   76.1   31.2    9.3    4.7    0.1
   -13.6   64.3  -38.8   51.0  -71.2  -91.3  -77.0 -106.4 -151.6 -174.3 -175.8
    79.5  106.8   57.1   98.3 -166.4  173.6 -169.9  162.0 -161.2 -167.9 -178.7
$$
  10012
$$ FES2014b ID:2025-08-03 01:06:38
$$ Computed using CARGA
$$ 10012                   RADI TANG  lon/lat: 166.9000  -46.6500     0.000
  .01663 .00564 .00413 .00168 .00294 .00382 .00104 .00110 .00106 .00058 .00050
  .00557 .00070 .00121 .00014 .00082 .00076 .00027 .00019 .00001 .00001 .00001
  .00533 .00136 .00104 .00040 .00167 .00132 .00052 .00029 .00015 .00010 .00009
   174.9 -163.7  164.8 -171.7   92.4   41.5   76.7   31.3    9.3    4.7    0.1
   -13.3   63.8  -38.4   50.3  -71.0  -91.3  -76.9 -106.4 -154.6 -175.1 -175.9
    78.9  106.3   56.5   97.7 -166.2  173.8 -169.7  162.3 -161.4 -168.0 -178.7
$$
...
```

(Note - the stations are returned in alphabetic order of station id, which may be different to
the order supplied)

The MAKEBLQ program uses two files of coefficients to determine the ocean loading coefficients at each station.  

One is a "source file" of coefficients of stations by id.  This is searched for a matching id, and also requiring that
the station is within a geographic tolerance of the station in the Bernese CRD file.

The other is a grid file which is used to extrapolate coefficients at a location on the grid.  The grid file does not need
to be complete, it just needs to be organised on points of a regular grid.  The LINZ processing uses a grid covering the
land area of New Zealand.  The source for this is in [util/blq_grid/grid.txt] ([util/blq/grid.jpg])

In 2025 this file is too big to submit to the service which takes a maximum file size of 147kb(!).  This was broken into
three files to compile the grid using the linux split command:

```sh
split -l 2010 grid.txt grid-split
```

Each was submitted to the service using settings in [util/blq_grid/ocean-loading-request.jpg].  This sends the results back by
email.  It took over a day for the three grid files to be returned by the service.
