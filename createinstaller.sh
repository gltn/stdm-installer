# createinstaller.sh
#
# Usage: 
# ./createinstaller.sh -f <config_file>
#
###################################################################################

function verify_setting()
{
    if [ -z "$1" ]; then
        echo "ERROR: In config file!"
        echo "Missing ['$2'] setting! Check the config file"
        exit 1
    else
        echo "[$2] ..........:$1 OK."
    fi
}

function inc_build_count()
{
    # increment installer counter
    sed -i -e "s/\(INSTALLER_VER=\).*/\1$1/" "$2"
}

function deploy_to_repo()
{
    # copies installer scripts to stdm-installer repo
    # - STDM-Installer-64.nsi
    # - createinstaller.sh
    echo "Copying installer files to repo ..."
    cp -v STDM-Installer-64.nsi ../stdm-installer/
    cp -v createinstaller.sh ../stdm-installer/
}

#############################################################################
#
# Main Body
#
#############################################################################

# Globals
ARCH=""
QGIS_VER=""
DEPLOY_ONLY="false"
LIVE_BUILD="false"

# check command line arguments
while getopts "f:d:l:" opt; do
    echo "***** $opt ****"
    echo "***** $OPTARG ****"
    case $opt in
       f) CONFIG_FILE="$OPTARG"
       ;;
       d) DEPLOY_ONLY="$OPTARG"
       ;;
       d) LIVE_BUILD="$OPTARG"
       ;;
       \?) echo "Invalid option  - $OPTARG" >&2
       ;;
    esac
done

if [ "$DEPLOY_ONLY" = "true" ]; then
    deploy_to_repo
    exit 1
fi

if [ -z "$CONFIG_FILE" ]; then
    echo "Config file not found!"
    exit 1
fi

# Read the config file
. $CONFIG_FILE

verify_setting "$BRANCH" "QGIS Version"
verify_setting "$PG_VER" "PostgreSQL Version"
verify_setting "$PG_EXE" "PostgreSQL Setup"
verify_setting "$POSTGIS_VER" "PostGIS Version"
verify_setting "$POSTGIS_EXE" "PostGIS Setup"
verify_setting "$STDM_VER" "STDM Version"
verify_setting "$INSTALLER_VER" "Installer Version"
verify_setting "$ARCH" "Architecture Version"
verify_setting "$POSTGRES_USER" "Postgres Username"

QGIS_VER="$BRANCH"
PG_VER="$PG_VER"
POSTGRESQL_EXE="$PG_EXE"
POSTGIS_VER="$POSTGIS_VER"
POSTGIS_EXE="$POSTGIS_EXE"
STDM_VER="$STDM_VER"
INSTALLER_VER="$INSTALLER_VER"
POSTGRES_USER="$POSTGRES_USER"

echo "QGIS Version ........:$QGIS_VER"
echo "PG Version...........:$PG_VER"
echo "PG EXE...............:$POSTGRESQL_EXE"
echo "POSTGIS Version .....:$POSTGIS_VER"
echo "POSTGIS Version .....:$POSTGIS_EXE"
echo "STDM Version.........:$STDM_VER"
echo "Installer Version ...:$INSTALLER_VER"
echo "Postgres User .......:$POSTGRES_USER"

# increment build number
COUNT=$(($INSTALLER_VER+1))
inc_build_count "$COUNT" "$CONFIG_FILE"

#exit 1

if [ -z "$QGIS_VER" ]; then
    echo "Createinstaller: Didn't receive version info"
    exit 1
fi

IFS='.'
READ_CMD='read -ra BA <<< "$QGIS_VER"'

eval $READ_CMD

if [ ${#BA[@]} -ne 3 ]; then
    echo "Branch value not correct! "
    exit 1;
fi

MAJOR="${BA[0]}"
MINOR="${BA[1]}"
RELEASE="${BA[2]}"

QGIS_VER_LABEL="$MAJOR-$MINOR"

QGIS_EXE="STDM-QGIS-${QGIS_VER_LABEL}-Setup-${ARCH}.exe"

if [ "$LIVE_BUILD" = "true" ]; then
    ARG16=-DLIVE="${LIVE_BUILD}" 
else
    ARG16=""
fi

/c/PROGRA~2/NSIS/Unicode/makensis \
    -DSTDM_VERSION="${STDM_VER}" \
    -DPG_VERSION="${PG_VER}" \
    -DPG_VERSION_DISPLAY="PostgreSQL ${PG_VER}" \
    -DPG_GUID="postgresql-x64-${PG_VER}" \
    -DPOSTGIS_PG_VERSION="pg95" \
    -DPOSTGIS_VERSION="${POSTGIS_VER}" \
    -DPOSTGIS_VERSION_DISPLAY="PostGIS ${POSTGIS_VER}" \
    -DQGIS_VERSION="QGIS ${CODE_NAME} (${QGIS_VER}) for STDM" \
    -DQGIS="${QGIS_EXE}" \
    -DPOSTGRESQL="${POSTGRESQL_EXE}" \
    -DPOSTGRES_USER="${POSTGRES_USER}" \
    -DPOSTGIS="${POSTGIS_EXE}" \
    -DSTDM_SAMPLE_DATA="stdm_sample.backup" \
    -DSETUP_FILENAME="STDM-${STDM_VER} Final-${ARCH}_${COUNT}.exe" \
    -V4 \
    $ARG16 \
    STDM-Installer-64.nsi

# copy installer script to repo folder
deploy_to_repo

#-DLIVE_BUILD="${LIVE_BUILD}" \
