#!/bin/bash
###########################################################################
#    make_qgis_package.sh
#
###########################################################################

QGIS_VERSION=""
VERSION_NAME=""
FILENAME=""
ARCH=""

while getopts "b:v:f:a:" opt; do
    case $opt in
       b) QGIS_VERSION="$OPTARG"
       ;;
       v) VERSION_NAME="$OPTARG"
       ;;
       f) FILENAME="$OPTARG"
       ;;
       a) ARCH="$OPTARG"
       ;;
       \?) echo "Invalid option  - $OPTARG" >&2
       ;;
    esac
done

echo "Make QGIS Package started..."
echo ""
echo "QGIS_VERSION.....:$QGIS_VERSION"
echo "VERSION_NAME.....:$VERSION_NAME"
echo "FILENAME.........:$FILENAME"
echo "ARCH.............:$ARCH"

sleep 2

if [ -z "$QGIS_VERSION" ]; then
    echo "Missing QGIS version number!"
    exit 1
fi

if [ -z "$VERSION_NAME" ]; then
    echo "Missing QGIS version name."
    exit 1
fi

if [ -z "$FILENAME" ]; then
    echo "Missing file name"
    exit 1
fi

if [ -z "$ARCH" ]; then
    echo "Missiong build architecture!"
    exit 1
fi

/c/PROGRA~2/NSIS/makensis \
-DVERSION_NUMBER="$QGIS_VERSION" \
-DVERSION_NAME="$VERSION_NAME" \
-DSVN_REVISION="0" \
-DQGIS_BASE="QGIS $VERSION_NAME ($QGIS_VERSION) for STDM" \
-DINSTALLER_NAME="$FILENAME" \
-DDISPLAYED_NAME="QGIS $VERSION_NAME ($QGIS_VERSION) for STDM 64bit" \
-DBINARY_REVISION=3 \
-DINSTALLER_TYPE=OSGeo4W \
-DPACKAGE_FOLDER=osgeo4w/unpacked-"$ARCH" \
-DSHORTNAME=qgis \
-DLICENSE_FILE=license.tmp \
-DARCH="$ARCH" \
-V4 \
QGIS-Installer.nsi

cp -v "$FILENAME" /d/home/QGISApp/STDM/setup/64bit/installers/

#exit 0
