# cloneqgis.sh
#
# Usage:
# ./cloneqgis -b <branch> -a <architecture> -v <version_name> -p <package_name> -c <clone or not> 
#
# -b Branch format 'X.X.X
# -a Architecture 'x86' or 'x86_64', default 'x86_64'
# -v Version name string 'Las palmas', default 'Nairobi'
# -p QGIS package name e.g. 'qgis' 
# -c Clone repo. If c= 1, the script will attempt to clone QGIS repo 'release-branch' from github.
#
# Example: ./cloneqgis -b 2.18.4 -a x86_64 -v 'Las Palmas' -p qgis -c 1 
# 
######################################################################################################

# globals

ARCH='x86_64'
VER_NAME='Nairobi'
PACKAGE_NAME='qgis'
CLONE='0'
DEST_DIR=""

# end globals

function usage()
{
   echo "Usage: "
   echo "cloneqgis.sh -b<X.X.X> a <arch> -v <version_name> -p <package_name> -c 1"
   echo ""
   echo "Example: To clone from repo"
   echo "cloneqgis.sh -b 2.18.5 -v 'Las Palmas' -p qgis2.18.5 -c 1"
   exit 1
}

function test_complete_qgis()
{
    if [ ! -f "$DEST_DIR/ms-windows/osgeo4w/package.cmd" ]; then
        echo "ERROR: ($DEST_DIR) - Not complete directory. Remove and clone again."
        exit 1
    fi
}

###############################################################################
#
# Main Body
#
###############################################################################

while getopts ":b:a:v:p:c:" opt; do
    case $opt in
       b) BRANCH="$OPTARG"
       echo "$OPTARG"
       ;;
       a) ARCH="$OPTARG"
       echo "ARCH ***$OPTARG"
       ;;
       v) VER_NAME="$OPTARG"
       ;;
       p) PACKAGE_NAME="$OPTARG"
       ;;
       c) CLONE="$OPTARG"
       ;;
       \?) echo "Invalid option  - $OPTARG" >&2
       ;;
    esac
done


IFS='.' 
RD='read -ra BA <<< "$BRANCH"'

eval $RD

if [ ${#BA[@]} -ne 3 ]; then
    echo "Branch value not correct! "
    usage
fi


MAJOR="${BA[0]}"
MINOR="${BA[1]}"
RELEASE="${BA[2]}"


SEP="_"
FULL_BRANCH_NAME="release-$MAJOR$SEP$MINOR"
DEST_DIR="release-$MAJOR$SEP$MINOR$SEP$RELEASE"

printf "Full Branch name: %s\n" "$FULL_BRANCH_NAME"
printf "Full Release name: %s\n" "$DEST_DIR"
echo " "

if [ -d "$DEST_DIR" -a "$CLONE" = "1" ]; then
    echo "Destination directory exist! Remove then clone again."
    exit 1
fi

# clone QGIS
if [ "$CLONE" = "1" ]; then
    echo "Cloning QGIS branch '$FULL_BRANCH_NAME' into folder '$DEST_DIR' ..."
    git clone --depth 1 -b "$FULL_BRANCH_NAME" https://github.com/qgis/QGIS.git "$DEST_DIR"
    # Get error code
    ERR_CODE=$?

    if [ $ERR_CODE -ne 0 ]; then
       echo "Clone failed: Error code $ERR_CODE"
       exit 1
    fi

fi

# If you didn't clone, check if you have a folder with QGIS
if [ "$CLONE" = "0" ]; then
    if [ ! -d "$DEST_DIR" ]; then
        echo " "
        echo "Folder with QGIS '$DEST_DIR' does not exist!"
        echo "Processing Failed!"
        exit 1
    else
        test_complete_qgis
    fi
fi

# we have our clone, make copies of files to modify
printf "\n"
echo "Copying files to modify ..."

if [ ! -d "store/$BRANCH" ]; then
    mkdir "store/$BRANCH"
fi

STORE="store/$BRANCH"

if [ ! -f "$STORE/qgsapplication.cpp" ]; then
    cp -v "$DEST_DIR/src/core/qgsapplication.cpp" "$STORE"
fi

if [ ! -f "$STORE/qgis.h" ]; then
    cp -v "$DEST_DIR/src/core/qgis.h" "$STORE"
fi

if [ ! -f "$STORE/qgis.cpp" ]; then
    cp -v "$DEST_DIR/src/core/qgis.cpp" "$STORE"
fi

if [ ! -f "$STORE/qextserialenumerator.cpp" ]; then
    cp -v "$DEST_DIR/src/core/gps/qextserialport/qextserialenumerator.cpp" "$STORE"
fi

if [ ! -f "$STORE/qgisapp.cpp" ]; then
    cp -v "$DEST_DIR/src/app/qgisapp.cpp" "$STORE"
fi

if [ ! -f "$STORE/CMakeLists.txt" ]; then
    cp -v "$DEST_DIR/src/app/CMakeLists.txt" "$STORE"
fi

if [ ! -f "$STORE/installer_data.py" ]; then
    cp -v "$DEST_DIR/python/pyplugin_installer/installer_data.py" "$STORE"
fi

if [ ! -f "$STORE/splash.png" ]; then
    cp -v "$DEST_DIR/images/splash/splash.png" "$STORE"
fi

if [ ! -f "$STORE/qgis_win32.rc" ]; then
    cp -v "$DEST_DIR/src/app/qgis_win32.rc" "$STORE"
fi


rm qgis.config
echo "BRANCH=$BRANCH" > qgis.config
echo "ARCH=$ARCH" >> qgis.config
echo "VER_NAME=$VER_NAME" >> qgis.config
echo "PACKAGE=$PACKAGE_NAME" >> qgis.config

echo " "
echo "Customize QGIS and then run script 'buildqgis.sh' "
echo " "
echo "Finished."

exit 0
