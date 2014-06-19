;--------------------------------------------------------------------------
;    STDM-Installer.nsi - Windows Installer for PostgreSQL , PostGIS and
;						  QGIS 2.2 for STDM.
;    ---------------------
;    Date                 : June 2014
;    Copyright            : (C) 2014 by UN-Habitat and implementing partners
;    Email                : stdm at unhabitat dot org
;--------------------------------------------------------------------------
;                                                                         #
;   This program is free software; you can redistribute it and/or modify  #
;   it under the terms of the GNU General Public License as published by  #
;   the Free Software Foundation; either version 2 of the License, or     #
;   (at your option) any later version.                                   #
;                                                                         #
;--------------------------------------------------------------------------

Name "Social Tenure Domain Model"

SetCompressor lzma

RequestExecutionLevel admin

# General Symbol Definitions
!define VERSION "1.0 RC"
!define COMPANY "Global Land Tool Network"
!define URL www.stdm.gltn.net

# MUI Symbol Definitions
!define MUI_ICON stdm.ico
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_UNICON stdm.ico
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING

# Included files
!include MUI2.nsh
!include LogicLib.nsh
!include nsDialogs.nsh
!include WinMessages.nsh

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE License.txt
!insertmacro MUI_PAGE_COMPONENTS
Page custom dbConnPropPage dbConnPropPageLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile STDM-1.0-RC-x86.exe
InstallDir "$PROGRAMFILES\STDM"
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 1.0.0.0
VIAddVersionKey ProductName "Social Tenure Domain Model"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription "STDM 1.0 Release Copy"
VIAddVersionKey LegalCopyright ""
ShowUninstDetails show

; Place all temporary files used by the installer in their own subdirectory under $TEMP (makes the files easier to find)
!define TEMPDIR "$PLUGINSDIR\stdm_installer"

;Define the version of PostgreSQL that we are going to use
!define POSTGRESQL_9.2 1

;Change GUID for different platforms i.e x86 and x86_64
!ifdef POSTGRESQL_9.2
	!define PG_VERSION "9.2"
	!define PG_VERSION_DISPLAY "PostgreSQL 9.2"
	!define PG_GUID "postgresql-9.2" ;
    !define POSTGIS_PG_VERSION "pg92"
!endif

!define POSTGIS_VERSION "2.1"

!define QGIS_VERSION "QGIS 2.2 for STDM"

;Custom UI for database connection
Var Dialog
Var userNameLbl
Var userNameTxt
Var groupConn
Var passLbl
Var passTxt
Var portLbl
Var portTxt
Var dbNameLbl
Var dbNameTxt
Var notificationLbl

;Database connection information
Var userName
Var password
Var port
Var dbName

;PostgreSQL install option
Var PG_INSTALL_OPTIONS

Function .onInit
    InitPluginsDir 
    StrCpy $userName "postgres"   
    StrCpy $password ""
    StrCpy $port "5434"
    StrCpy $dbName "stdm"
    StrCpy $PG_INSTALL_OPTIONS ""
    
FunctionEnd

Section -SETTINGS
  SetOutPath ${TEMPDIR}
  SetOverwrite ifnewer
SectionEnd

# Installer sections
Section "PostgreSQL 9.2" SecPostgreSQL
    Call CheckPostgresql
SectionEnd

Section "PostGIS 2.1" SecPostGIS
    Call InstallPostGIS
SectionEnd

Section "QGIS 2.2 for STDM" SecQGIS
    Call InstallQGIS
SectionEnd

;Database connection property page
Function dbConnPropPage
    # If user has not selected Postgres or PostGIS componets then no need to show this dialog
    ${IfNot} ${SectionIsSelected} ${SecPostgreSQL} 
    ${AndIfNot} ${SectionIsSelected} ${SecPostGIS}
        Abort
    ${EndIf}
    
    #If user has already selected PostgreSQL and specified the connection settings then no need to show this dialog
    StrCmp $PG_INSTALL_OPTIONS "" 0 connection_settings_already_defined
    
    nsDialogs::Create 1018
    Pop $Dialog
    
    ${if} $Dialog == error
        Abort
    ${EndIf}
    
    !insertmacro MUI_HEADER_TEXT "Database Connection Properties" "Please specify the database connection properties for installing PostgreSQL and PostGIS."
    
    ${NSD_CreateGroupBox} 0 0 -1 -5 "Database Connection Properties:"
    Pop $groupConn
    
    ${NSD_CreateLabel} 40 38 80 20 "User Name:"
    Pop $userNameLbl

    ${NSD_CreateText} 132 38 60% 20 $userName
    Pop $userNameTxt
    #Disable control so that the user does not change the postgres service account
    EnableWindow $userNameTxt 0
    
    ${NSD_CreateLabel} 40 68 80 20 "Password:"
    Pop $passLbl

    ${NSD_CreatePassword} 132 68 60% 20 $password
    Pop $passTxt
    
    ${NSD_CreateLabel} 40 98 80 20 "Port:"
    Pop $portLbl

    ${NSD_CreateText} 132 98 60% 20 $port
    Pop $portTxt
    #Disable control so that the user does not change the postgres port number
    EnableWindow $portTxt 0
    
    ${NSD_CreateLabel} 40 128 80 20 "Database Name:"
    Pop $dbNameLbl

    ${NSD_CreateText} 132 128 60% 20 $dbName
    Pop $dbNameTxt
    #Disable control so that the user does not change the name of the STDM database
    EnableWindow $dbNameTxt 0
    
    ${NSD_CreateLabel} 40 163 85% 40 "Please take note of these values as they will be required for configuring STDM upon first-time use."
    Pop $notificationLbl
    SetCtlColors $notificationLbl "0x0000FF" transparent
    
    nsDialogs::Show
    
    connection_settings_already_defined:
        Abort
    
FunctionEnd

; Save control state
Function dbConnPropPageLeave
    #We are only interested in the password since the rest of the parameters are fixed
    ${NSD_GetText} $passTxt $password
    
FunctionEnd

;Copy postgresql installer into temp directory and execute with the specified options
Function InstallPostgreSQL
    ;Specify PostgreSQL options for unattended mode installation 
    StrCpy $PG_INSTALL_OPTIONS "--mode unattended --superaccount $userName --superpassword $password --serviceaccount $userName  --servicepassword $password --serverport $port"

    #Create batch file for executing postgresl in unattended mode
    File "Installers\postgresql-9.2.8-3.exe"
    
    FileOpen $1 "${TEMPDIR}\install_postgresql.bat" "w"
    FileWrite $1 '"${TEMPDIR}\postgresql-9.2.8-3.exe" $PG_INSTALL_OPTIONS 2> "${TEMPDIR}\install_postgres_error.txt"$\r$\n'
    FileWrite $1 "exit %ERRORLEVEL%$\r$\n"
    FileClose $1
    
    DetailPrint "Installing PostgreSQL${PG_VERSION}..."
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_postgresql.bat"'
    Pop $2
    
    ; If pg installer returned non-zero then an error occurred
    IntCmp $2 0 postgresql_install_success
    
    #PostgreSQL installation failed. Provide feedback to user
    StrCpy $7 "PostgreSQL installation failed."
    StrCpy $8 "${TEMPDIR}\install_postgres_error.txt"
    Call AbortDisplayLogOption
    
    postgresql_install_success:
        DetailPrint "PostgreSQL${PG_VERSION} has been successfully installed!"
        return

FunctionEnd

; Silent install PostGIS and create STDM template database.   
Function InstallPostGIS
    File "Installers\postgis-2.1.3-1.exe"
    
    FileOpen $3 "${TEMPDIR}\install_postgis.bat" "w"
    FileWrite $3 '"${TEMPDIR}\postgis-2.1.3-1.exe" /S /USERNAME=$userName /PASSWORD=$password /PORT=$port 2> "${TEMPDIR}\install_postgis_error.txt"$\r$\n'
    FileWrite $3 "exit %ERRORLEVEL%$\r$\n"
    FileClose $3
    
    DetailPrint "Installing PostGIS${POSTGIS_VERSION}..."
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_postgis.bat"'
    Pop $4
    
    ; If PostGIS installer returned non-zero then an error occurred
    IntCmp $4 0 postgis_install_success
    
    #PostGIS installation failed. Provide feedback to user
    StrCpy $7 "PostGIS installation failed."
    StrCpy $8 "${TEMPDIR}\install_postgis_error.txt"
    Call AbortDisplayLogOption
    
    postgis_install_success:
        DetailPrint "PostGIS${POSTGIS_VERSION} has been successfully installed!"
        Call CreateSTDMDatabase
        
FunctionEnd

; Silent install QGIS 2.2 for STDM
Function InstallQGIS
    File "Installers\QGIS-STDM-2.2.0-1-Setup-x86.exe"
    
    FileOpen $9 "${TEMPDIR}\install_qgis.bat" "w"
    FileWrite $9 '"${TEMPDIR}\QGIS-STDM-2.2.0-1-Setup-x86.exe" /S 2> "${TEMPDIR}\install_qgis_error.txt"$\r$\n'
    FileWrite $9 "exit %ERRORLEVEL%$\r$\n"
    FileClose $9
    
    DetailPrint "Installing ${QGIS_VERSION}..."
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_qgis.bat"'
    Pop $R0
    
    ; If PostGIS installer returned non-zero then an error occurred
    IntCmp $R0 0 qgis_install_success
    
    #PostGIS installation failed. Provide feedback to user
    StrCpy $7 "QGIS installation failed."
    StrCpy $8 "${TEMPDIR}\install_qgis_error.txt"
    Call AbortDisplayLogOption
    
    qgis_install_success:
        DetailPrint "${QGIS_VERSION} has been successfully installed!"
        return
    
FunctionEnd

; Set the path to the PostgreSQL base directory if PostgreSQL exists. If not, then will set an empty string
Function SetPostgreSQLBaseDirectory
    ReadRegStr $0 HKLM "Software\PostgreSQL\Installations\${PG_GUID}" "Base Directory"
    
FunctionEnd
   
; Check if there is an existing PostgreSQL installation
Function CheckPostgresql
    #Get the installation directory
	DetailPrint "Checking for existing PostgreSQL installation..."
    Call SetPostgreSQLBaseDirectory
    
    ${if} $0 == ""
		DetailPrint "No previous installation found,"
		DetailPrint "Preparing to install ${PG_VERSION_DISPLAY}."
		Call InstallPostgreSQL
        
    ${Else}
		DetailPrint "An existing ${PG_VERSION_DISPLAY} installation found,"
		DetailPrint "Setup will skip ${PG_VERSION_DISPLAY} installation."
        MessageBox MB_OK|MB_ICONEXCLAMATION "${PG_VERSION_DISPLAY} is already installed in your system, this part will be skipped." 
    ${EndIf}
    
FunctionEnd

#Create STDM database 
Function CreateSTDMDatabase
    #Set path to PostgreSQL base directory
    Call SetPostgreSQLBaseDirectory
    
    ; Create batch file for execution - create_stdm_template_db.bat
    FileOpen $5 "${TEMPDIR}\create_stdm_db.bat" "w"
    FileWrite $5 "SET PGPASSWORD=$password$\r$\n"
    FileWrite $5 "SET PGPORT=$port$\r$\n"
    FileWrite $5 '"$0\bin\createdb.exe" -U $userName -h localhost $dbName 2> "${TEMPDIR}\create_stdm_db_error.txt"$\r$\n'
    FileWrite $5 '"$0\bin\psql.exe" -U $userName -h localhost -c "CREATE EXTENSION postgis;" -d $dbName --set ON_ERROR_STOP=1 2> "${TEMPDIR}\create_stdm_db_error.txt"$\r$\n'
    FileWrite $5 "exit %ERRORLEVEL%$\r$\n"
    FileClose $5
    
    DetailPrint "Creating STDM spatial database..."
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\create_stdm_db.bat"'
    Pop $6
    
    IntCmp $6 0 create_stdm_template_db_success
    
    ; Creation ya database imefail. Provide feedback to user
    StrCpy $7 "STDM template database creation failed."
    StrCpy $8 "${TEMPDIR}\create_stdm_db_error.txt"
    Call AbortDisplayLogOption
    
    create_stdm_template_db_success:
        DetailPrint "STDM spatial database has been successfully created!"
        return
    
FunctionEnd

#A generic error message reporting function that gives the user the option to display an error log and abort the installation.
; $7 - Error Message
; $8 - Log File Name
Function AbortDisplayLogOption
    ; Display a message box with the error
    MessageBox MB_YESNO|MB_ICONSTOP "$7$\r$\n$\r$\nWould you like to view the error log '$8'?" /SD IDNO IDYES show_error_log
    
    DetailPrint $7
    Abort 
    Return 
    
    show_error_log:
        ExecShell "open" "$8"
        DetailPrint $7
        Abort 
        Return
    
FunctionEnd

;Installer Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecQGIS} "Install QGIS Valmiera 2.2 for STDM"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPostgreSQL} "Install PostgreSQL 9.2 for Windows 32-bit"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPostGIS} "Install PostGIS 2.1 for Windows 32-bit"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

