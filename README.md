STDM Stand-Alone Installer
=======================

An NSIS script that packages PostgreSQL v9.5, PostGIS v2.2 and a custom-build of QGIS v2.18 (for STDM) into a single x86 Windows installer. The installer provides the user with the option of selecting which components to install and set the connection parameters of the STDM database if PostgreSQL and/or PostGIS components are selected.

***Note:*** This repository does not contain the individual installer packages of PostgreSQL, PostGIS and QGIS; these will be required when compiling the script. To include them, copy them into the 'Installers' directory while ensuring that the individual package file names are *postgresql-9.5.exe, postgis-2.2.exe* and *STDM-QGIS-2-18-Setup-x86_64.exe*, corresponding to PostgreSQL, PostGIS and QGIS respectively. However, these file name references can be directly edited in the script.

The following default connection properties have been used for PostgreSQL and PostGIS component selections:
* Username = postgres
* Port = 5433
* STDM spatial database name = stdm

**Prerequisites:**
 1. Nullsoft Scriptable Install System - available here: [NSIS](http://nsis.sourceforge.net/Main_Page)
 2. Individual PostgreSQL, PostGIS and QGIS installers

**Support** - You can get support in the following ways:

 1. Joining the stdm-dev mailing list at: [http://lists.osgeo.org/cgi-bin/mailman/listinfo/stdm-dev](http://lists.osgeo.org/cgi-bin/mailman/listinfo/stdm-dev)
 2. Signing up on GitHub and posting a new issue at: [https://github.com/gltn/stdm-installer/issues/new](https://github.com/gltn/stdm-installer/issues/new)




