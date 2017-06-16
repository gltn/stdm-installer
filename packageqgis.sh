# packageqgis.sh
#
# Usage: 
# ./packageqgis.sh
#
###################################################################################

MAJOR=""
MINOR=""
RELEASE=""
ARCH=""

QGIS_VERSION=""
VERSION_NAME=""
FILENAME=""
PACKAGE_NAME=""
SRC_PATH=""

function copy_custom_qgis()
{
    if [ ! -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/$PACKAGE_NAME" ]; then
        echo "ERROR: ($PACKAGE_NAME) - Package not found!."
        exit 1
    fi

    mv "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/qgis-bin.exe" "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/old-qgis-bin.exe"
    mv "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/qgis-browser-bin.exe" "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/old-qgis-browser-bin.exe"

    cp "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/$PACKAGE_NAME/bin/qgis.exe" "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/qgis-bin.exe"
    cp "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/$PACKAGE_NAME/bin/qbrowser.exe" "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/qgis-browser-bin.exe"

    rm "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/old-qgis-bin.exe"
    rm "$SRC_PATH/osgeo4w/unpacked-$ARCH/bin/old-qgis-browser-bin.exe"
}

function add_stdm_third_party_libs()
{
    echo "Adding stdm third party libraries ..."
    cp -R ../../STDM/dev/third_party/geoalchemy2 "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages"
    cp -R ../../STDM/dev/third_party/reportlab "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages"
    cp -R ../../STDM/dev/third_party/geraldo "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages"
    cp -R ../../STDM/dev/third_party/ttfquery "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages"
    cp -R ../../STDM/dev/third_party/fontTools "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages"
    cp -R ../../STDM/dev/third_party/xml2ddl "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages"
}

function remove_stdm_third_party_libs()
{
    echo "Removing STDM third party libraries ..."

    if [ -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/geoalchemy2" ]; then
        rm -r "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/geoalchemy2"
    fi

    if [ -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/reportlab" ]; then
        rm -r "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/reportlab"
    fi

    if [ -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/geraldo" ]; then
        rm -r "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/geraldo"
    fi

    if [ -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/ttfquery" ]; then
        rm -r "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/ttfquery"
    fi

    if [ -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/fontTools" ]; then
        rm -r "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/fontTools"
    fi

    if [ -d "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/xml2ddl" ]; then
        rm -r "$SRC_PATH/osgeo4w/unpacked-$ARCH/apps/python27/lib/site-packages/xml2ddl"
    fi

    echo "Finished STDM third party removing process."

}

function exec_create_installer()
{
    CFG_FILE="$1"

    CURR_DIR=`pwd`

    if [ "$ARCH" = "x86_64" ]; then
        ARCH_PATH="64bit"
    else
        ARCH_PATH="32bit"
    fi

    echo "PATH: $ARCH_PATH"

    SETUP_PATH="STDM/setup/$ARCH_PATH/"
    cd "$SETUP_PATH"
    ./createinstaller.sh -f "$CURR_DIR/$CFG_FILE"
    exit 1
}

#############################################################################
#
# Main Body
#
#############################################################################

ARCH_PACK="64" # default packaging architecture

echo "Packaging QGIS started ..."

while getopts ":a:" opt; do
    echo "Argument: $OPTARG"
    case $opt in
       a) ARCH_PACK="$OPTARG"
       ;;
       \?) echo "Invalid option  - $OPTARG" >&2
       ;;
    esac
done

if [ "$ARCH_PACK" = "64" ]; then
    CONFIG_FILE="qgis64.config"
fi

if [ "$ARCH_PACK" = "32"  ]; then
    CONFIG_FILE="qgis32.config"
fi
    
if [ ! -f "$CONFIG_FILE" ]; then
    echo "QGIS config file NOT found! Exiting QGIS packaging ..."
    exit 1
fi

#. qgis64.config
. $CONFIG_FILE

echo "Branch..........: $BRANCH"
echo "Architecture ...: $ARCH"
echo "Version Name ...: $VER_NAME"
echo "Package Name ...: $PACKAGE"

exec_create_installer $CONFIG_FILE
sleep 3
exit 1

IFS='.'
READ_CMD='read -ra BA <<< "$BRANCH"'

eval $READ_CMD

if [ ${#BA[@]} -ne 3 ]; then
    echo "Branch value not correct! "
    exit 1;
fi

SEP="_"
MAJOR="${BA[0]}"
MINOR="${BA[1]}"
RELEASE="${BA[2]}"

QGIS_VERSION=$BRANCH
VERSION_NAME=$VER_NAME
FILENAME="STDM-QGIS-$MAJOR-$MINOR-Setup-$ARCH.exe"  # STDM packaging script should be aware of the ARCH format
INCL_STDM_THIRD_PARTY=0
PACKAGE_NAME=$PACKAGE

while getopts "i:" opt; do
    case $opt in
       i) INCL_STDM_THIRD_PARTY="$OPTARG"
       ;;
       \?) echo "Invalid option - $OPTARG" >&2
       ;;
    esac
done

SRC_PATH="release-$MAJOR$SEP$MINOR$SEP$RELEASE/ms-windows"

echo "$SRC_PATH"

if [ "$INCL_STDM_THIRD_PARTY" = "1" ]; then
    add_stdm_third_party_libs
else
    remove_stdm_third_party_libs
fi

copy_custom_qgis

CURR_DIR=`pwd`
cd "$SRC_PATH"

echo "CURRENT FOLDER: $SRC_PATH"

. make_qgis_package.sh -b "$BRANCH" -v "$VERSION_NAME" -f "$FILENAME" -a "$ARCH"

cd "$CURR_DIR"

# execute the main STDM installer for everthing
exec_create_installer $CONFIG_FILE

echo "Finished."

exit 0


