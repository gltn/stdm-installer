STDM Stand-Alone Installer
=======================

An NSIS script that packages PostgreSQL v9.2, PostGIS v2.1 and a custom-build of QGIS v2.4 (for STDM) into a single x86 Windows installer. The installer provides the user with the option of selecting which components to install and set the connection parameters of the STDM database if PostgreSQL and/or PostGIS components are selected.

***Note:*** This repository does not contain the individual installer packages of PostgreSQL, PostGIS and QGIS; these will be required when compiling the script. To include them, copy them into the 'Installers' package while ensuring that the individual package file names are *postgresql-9.2.exe, postgis-2.1.exe* and *QGIS-STDM-2.4.0-Setup-x86.exe*, corresponding to PostgreSQL, PostGIS and QGIS respectively. However, these file names can be manually edited directly in the script.

The following default options have been used if PostgreSQL and PostGIS components have been selected:
* Username = postgres
* Port = 5434
* STDM spatial database name = stdm

**Prerequisites:**
 1. Nullsoft Scriptable Install System - available here: [NSIS](http://nsis.sourceforge.net/Main_Page)
 2. Individual PostgreSQL, PostGIS and QGIS installers

**Support** - You can get support in the following ways:

 1. Joining the stdm-dev mailing list at: [http://lists.osgeo.org/cgi-bin/mailman/listinfo/stdm-dev](http://lists.osgeo.org/cgi-bin/mailman/listinfo/stdm-dev)
 2. Signing up on GitHub and posting a new issue at: [https://github.com/gltn/stdm-installer/issues/new](https://github.com/gltn/stdm-installer/issues/new)




