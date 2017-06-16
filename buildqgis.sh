# buildqgis.sh
#
# Usage:
# ./buildqgis.sh [options]
#
# options:
#        - b <branch_number>
#        - x <express>        # No validation, just do the build
#
# Example: ./buildqgis.sh -b 2.18.4 -x 1
#
# if command line arguments are not supplied, buildqgis reads parameters from the qgis.config 
# written by cloneqgis.sh
#
##############################################################################################

CONFIG_FILE="qgis.config"
PACKAGE_NAME=""
ARCH="x86_64"
MESSAGE=""
ARG_BRANCH=""
ARG_EXPRESS=0
ARG_PACKAGE_NAME=""

function usage()
{
   echo "Usage: "
   echo "buildqgis.sh [options]"
   echo "options:"
   echo " -b branch_number 'X.X.X"
   echo " -x [0]- default run script to the end;"
   echo "    [1]- Dont check for modified files just build immediately;"
   echo "Example:"
   echo "./buildqgis.sh -b 2.18.5 -x 1"
   exit 1
}

function file_in_res_folder()
{
    if [ ! -f "$1" ]; then
        echo "ERROR: ('$1') - File missing in folder 'res' "
        exit 1
    fi
}

# copy resource files to relevant qgis folders
function copy_file()
{
    FILE_NAME="$1"
    DST_DIR="$2"
    SRC_FILE="res/$FILE_NAME"
    DST_FILE="$QGIS_BRANCH$DST_DIR$FILE_NAME"

    file_in_res_folder "$SRC_FILE"

    if [ ! -f "$DST_FILE" ]; then
        cp -v "$SRC_FILE" "$DST_FILE"
    else
        echo "$SRC_FILE"
        SRC_HASH='$(git hash-object "$SRC_FILE")'
        DST_HASH='$(git hash-object "$DST_FILE")'

        if [ "$SRC_HASH" != "$DST_HASH" ]; then
            cp -v "$SRC_FILE" "$DST_FILE"
        else
            echo "$FILE_NAME: File upto-date."
        fi
    fi
}

function compare_files()
{
    echo "- $1"
    FILE_NAME="$1"
    DST_DIR="$2"
    MSG="$3"

    SRC_FILE="store/$BRANCH/$FILE_NAME"
    DST_FILE="$QGIS_BRANCH$DST_DIR$FILE_NAME"

    SRC_HASH='$(git hash-object "$SRC_FILE")'
    DST_HASH='$(git hash-object "$DST_FILE")'

    if [ "$SRC_HASH" = "$DST_HASH" ]; then
        echo "ERROR: ($DST_FILE). Please make relevant modifications to this file then continue with the build."
        printf "Suggestion:\n"
        printf "$3"
        echo " "
        exit 1
    else
        echo "File OK."
    fi
}

function comp_qgsapplication()
{
    compare_files "qgsapplication.cpp" "/src/core/" "
    QString QgsApplication::appIconPath() \n
    {\n
        return iconsPath() + 'qgis-icon-60x60.png'; <----- Replace this with 'stdm.ico'\n
    }\n"
}

function comp_qgis_h()
{
    compare_files "qgis.h" "/src/core/" "
    class CORE_EXPORT QGis
    { \n
        public:\n
            ...
            static QString STDM_ID;   <------ Add a static QString for STDM title in class CORE_EXPORT \n
    "
}

function comp_qgis_cpp()
{
    compare_files "qgis.cpp" "/src/core/" "
    ... \n
    // development version \n
    const char* QGis::QGIS_DEV_VERSION = QGSVERSION; \n

    QString QGis::STDM_ID = ' for STDM '; <----- Assign the stdm title to static string 'STDM_ID' \n
    "

}

function comp_qgisapp_cpp()
{
    compare_files "qgisapp.cpp" "/src/app/" "
    ... \n
    static void setTitleBarText_( QWidget & qgisApp )\n
    {\n
        QString caption = QgisApp::tr( 'QGIS ' );\n

        if ( QGis::QGIS_RELEASE_NAME == 'Master' )\n
            {\n
                caption += QGis::STDM_ID + QString( 'x1' ).arg( QGis::QGIS_DEV_VERSION );\n
                                   ^----- Append stdm title here\n
            }\n
        else\n
            {\n
                caption += QGis::QGIS_VERSION + QGis::STDM_ID; <----- Append stdm title here \n
            }\n
            ...
    "
}


function comp_qextserialenumerator_cpp()
{
    compare_files "qextserialenumerator.cpp" "/src/core/gps/qextserialport/" "
    Comment out code refering to 'SetupDiGetDeviceRegistryProperty' windows API method. This code is in the following methods : \n
      - QString QextSerialEnumerator::getDeviceProperty(HDEVINFO devInfo, PSP_DEVINFO_DATA devData, DWORD property)\n
      - void QextSerialEnumerator::enumerateDevicesWin( const GUID & guid, QList<QextPortInfo>* infoList )\n
      - bool QextSerialEnumerator::matchAndDispatchChangedDevice(const QString & deviceID, const GUID & guid, WPARAM wParam)\n
      - bool QextSerialEnumerator::getDeviceDetailsWin( QextPortInfo* portInfo, HDEVINFO devInfo, PSP_DEVINFO_DATA devData, WPARAM wParam )\n
    "
}

function comp_installer_data()
{
    compare_files "installer_data.py" "/python/pyplugin_installer/" "
     see the installer_data.py template file for areas to modify
    "
}

function comp_qgis_win32_rc()
{
    compare_files "qgis_win32.rc" "/src/app/" "
    Change 'qgis.ico' to 'stdm.ico' \n
        IDI_ICON1               ICON    DISCARDABLE     'qgis.ico'  <----- Change this to 'stdm.ico'\n
    "
}

function comp_app_cmakelist()
{
    compare_files "CMakeLists.txt" "/src/app/" "
    IF(MSVC)\n
      INSTALL(FILES qgis.ico qgis-mime.ico qgis-qgs.ico qgis-qlr.ico qgis-qml.ico qgis-qpt.ico DESTINATION ${CMAKE_INSTALL_PREFIX}/icons)\n
                                                                                              ^\n
                                                                                              Add 'stdm.ico' to this list\n
    ENDIF(MSVC)\n
    "
}

function build_qgis()
{
    echo "Building QGIS started ..."
    cmd //C "CALL start_qgis64_vs2010.bat"
    sleep 5
    CURR_DIR=`pwd`
    cd $QGIS_BRANCH/ms-windows/osgeo4w
    cmd //C "CALL package.cmd $DOTTED_BRANCH 40 $PACKAGE_NAME $ARCH"
    cd $CURR_DIR
}

###############################################################################
#
# Main Body
#
###############################################################################

echo "Build QGIS started ..."

while getopts ":b:p:x:" opt; do
    case $opt in
       b) ARG_BRANCH="$OPTARG"
       ;;
       p) ARG_PACKAGE_NAME="$OPTARG"
       ;;
       x) ARG_EXPRESS="$OPTARG"
       ;;
       \?) echo "Invalid option  - $OPTARG" >&2
       ;;
    esac
done

# check the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Fatal Error!"
    echo "QGIS config file is missing!. Script execution stopped."
    echo "Run script 'cloneqgis.sh' to create configuration file"
    exit 1
fi

# read the QGIS build version from config file
if [ -z "$ARG_BRANCH" ]; then
    . qgis.config
    echo $BRANCH
    echo "From FILE: $BRANCH"
else
    echo "Argument: $ARG_BRANCH"
    BRANCH=$ARG_BRANCH
fi


if [ -z "$ARG_PACKAGE_NAME" ]; then
    . qgis.config
     PACKAGE_NAME=$PACKAGE
else
    PACKAGE_NAME="$ARG_PACKAGE_NAME"
fi


IFS='.'
READ_CMD='read -ra BA <<< "$BRANCH"'

eval $READ_CMD

if [ ${#BA[@]} -ne 3 ]; then
    echo "Branch format not correct! "
    usage
fi

SEP="_"
MAJOR="${BA[0]}"
MINOR="${BA[1]}"
RELEASE="${BA[2]}"

QGIS_VER="$MAJOR$SEP$MINOR$SEP$RELEASE"

#DOTTED_BRANCH="$(echo $BRANCH |  sed -e 's/_/\./g')" # replace '_' with '.' e.g. 2_18_4 to 2.18.4
DOTTED_BRANCH=$BRANCH

QGIS_BRANCH="release-$QGIS_VER"

echo "Building QGIS $QGIS_BRANCH started ..."

if [ "$ARG_EXPRESS" = "1" ]; then
    echo "Express build ..."
    build_qgis
    exit 1
fi

echo "Copying resource files ..."

copy_file "stdm.ico" "/src/app/"
copy_file "splash.png" "/images/splash/"

echo " "
echo "Validate if QGIS customization happened ..."
echo " "

#: << 'END'
comp_qgsapplication
comp_qgis_h
comp_qgis_cpp
comp_qgisapp_cpp
comp_installer_data
comp_qextserialenumerator_cpp
comp_qgis_win32_rc
comp_app_cmakelist
#END

# Ready to build
build_qgis

# Setup environment 
echo "Script finished execution."
exit 0

