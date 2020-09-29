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

