;    STDM-Installer-64.nsi - Windows Installer for PostgreSQL , PostGIS and
;						  QGIS 2.8.2-x86_64 for STDM.
;    ---------------------
;    Date                 : April 2015
;    Copyright            : (C) 2015 by UN-Habitat and implementing partners
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
!define VERSION "1.1 Final"
!define COMPANY "Global Land Tool Network"
!define URL www.stdm.gltn.net

# MUI Symbol Definitions
!define MUI_ICON stdm.ico
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_UNICON stdm.ico
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "SetupSideBanner.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "SetupSideBanner.bmp"

# Included files
!include "x64.nsh"
!include "FileFunc.nsh"
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
OutFile STDM-1.1-Final-x86_64.exe
InstallDir "$PROGRAMFILES\STDM"
CRCCheck on
XPStyle on 
BrandingText "Global Land Tool Network" 
ShowInstDetails show 
VIProductVersion 1.1.1.0 
VIAddVersionKey ProductName "Social Tenure Domain Model" 
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}" 
VIAddVersionKey CompanyWebsite "${URL}" 
VIAddVersionKey FileVersion "${VERSION}" 
VIAddVersionKey FileDescription "STDM 1.1 Final"
VIAddVersionKey LegalCopyright "" 
ShowUninstDetails show

; Place all temporary files used by the installer in their own subdirectory
; under $TEMP (makes the files easier to find)
!define TEMPDIR "$PLUGINSDIR\stdm_installer"

; Define the version of PostgreSQL that we are going to use
!define POSTGRESQL_9.4

; Change GUID for different platforms i.e x86 and x86_64
!ifdef POSTGRESQL_9.4 
     !define PG_VERSION "9.4" 
     !define PG_VERSION_DISPLAY "PostgreSQL 9.4" 
     !define PG_GUID "postgresql-x64-9.4" ; 
     !define POSTGIS_PG_VERSION "pg94"
!endif

!define POSTGIS_VERSION "2.1.7"

!define QGIS_VERSION "QGIS Wein (2.8.2) for STDM"
!define QGIS "QGIS-STDM-2-8-2-Setup-x86-64.exe"
!define POSTGRESQL "postgresql-9.4.1-3-windows-x64.exe"
!define POSTGIS "postgis-bundle-pg94x64-setup-2.1.7-1.exe"
!define STDM_SAMPLE_DATA "stdm_sample.backup"

; Custom UI for database connection
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

#Postgres registry settings 
Var pg_reg_user 
Var pg_reg_port

;PostgreSQL install option
Var PG_INSTALL_OPTIONS

Var InstallersFolder

Function .onInit
    StrCpy $InstallersFolder "installers"
    InitPluginsDir
    StrCpy $userName "postgres"  
    StrCpy $password "" 
    StrCpy $port "5433" 
    StrCpy $dbName "stdm" 
    StrCpy $PG_INSTALL_OPTIONS ""
	
   #Default pg registry options 
   StrCpy $pg_reg_user ""
    
FunctionEnd

Section -SETTINGS 
    SetOutPath ${TEMPDIR} 
    SetOverwrite ifnewer 
SectionEnd

Section "QGIS Wein 2.8.2 for STDM" SecQGIS 
   Call InstallQGIS 
SectionEnd

# Installer sections
Section "PostgreSQL 9.4" SecPostgreSQL
    Call CheckPostgresql
SectionEnd

Section "PostGIS 2.1.7" SecPostGIS
    Call InstallPostGIS
SectionEnd

# sample data
Section "Sample Data" SecSampleData
    Call InstallSampleData
SectionEnd

;Database connection property page
Function dbConnPropPage
    # If user has not selected Postgres, PostGIS or Sample data componets then no need to
    # show this dialog
    ${IfNot} ${SectionIsSelected} ${SecPostgreSQL}
    ${AndIfNot} ${SectionIsSelected} ${SecPostGIS}
    ${AndIfNot} ${SectionIsSelected} ${SecSampleData}
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
    #EnableWindow $userNameTxt 0
    
    ${NSD_CreateLabel} 40 68 80 20 "Password:" 
    Pop $passLbl

    ${NSD_CreatePassword} 132 68 60% 20 $password 
    Pop $passTxt
    
    ${NSD_CreateLabel} 40 98 80 20 "Port:" 
    Pop $portLbl

    ${NSD_CreateText} 132 98 60% 20 $port 
    Pop $portTxt
    #Disable control so that the user does not change the postgres port number #EnableWindow $portTxt 0
    
    ${NSD_CreateLabel} 40 128 80 20 "Database Name:" 
    Pop $dbNameLbl

    ${NSD_CreateText} 132 128 60% 20 $dbName 
    Pop $dbNameTxt 
    #Disable control so that the user does not change the name of the STDM database 
    EnableWindow $dbNameTxt 0
    
    ${NSD_CreateLabel} 40 163 85% 40 "Please take note of these values as they will be required for configuring STDM on using it for the first time."
    Pop $notificationLbl 
    SetCtlColors $notificationLbl "0x0000FF" transparent
    
    nsDialogs::Show
    
    connection_settings_already_defined: 
    Abort
    
FunctionEnd

; Set the PostgreSQL username if there is an existing installation 
Function PostgresRegUserName 
   ReadRegStr $pg_reg_user HKLM "Software\PostgreSQL\Installations\${PG_GUID}" "Super User"
FunctionEnd

; Validate entries
Function dbConnPropPageLeave
  ${NSD_GetText} $userNameTxt $userName 
  ${If} $userName == "" 
      MessageBox MB_OK|MB_ICONSTOP "Please specify the postgres user account name.$\nYou can use 'postgres' as the default."
      Abort
  ${EndIf}
	
  ${NSD_GetText} $passTxt $password
  ${If} $password == ""
    MessageBox MB_OK|MB_ICONSTOP "Please enter password for the postgres account"
    Abort
  ${EndIf}
	
  ${NSD_GetText} $portTxt $port 
  ${If} $port == "" 
    MessageBox MB_OK|MB_ICONSTOP "Please enter the database port number" 
    Abort
  ${EndIf}
	
  Call PostgresRegUserName 
  ${If} $pg_reg_user == $userName 
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "The installer has detected an existing copy of PostgreSQL.\ 
	$\nYou can either de-select installing PostgreSQL in the components page or ensure that the specified database connection properties match \
	those of the existing PostgreSQL installation.$\nProceed with the installation?" IDYES next IDNO no_abort
   ${Else}
      Goto next
   ${EndIf}
	
	no_abort:
	  Abort
		
	next:
    
FunctionEnd

; Copy postgresql installer into temp directory and execute with the specified
; options
Function InstallPostgreSQL
    ;Specify PostgreSQL options for unattended mode installation 
    StrCpy $PG_INSTALL_OPTIONS "--mode unattended --superaccount $userName --superpassword $password --serviceaccount $userName  --servicepassword $password --serverport $port"

    DetailPrint ${InstallersFolder}
    File "installers\${POSTGRESQL}"
	
    #Create batch file for executing postgresl in unattended mode
    FileOpen $1 "${TEMPDIR}\install_postgresql.bat" "w"
    FileWrite $1 '"${TEMPDIR}\${POSTGRESQL}" $PG_INSTALL_OPTIONS 2> "${TEMPDIR}\install_postgres_error.txt"$\r$\n'
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
    File "installers\${POSTGIS}"
    
    FileOpen $3 "${TEMPDIR}\install_postgis.bat" "w"

    FileWrite $3 '"${TEMPDIR}\${POSTGIS}" /S /USERNAME=$userName /PASSWORD=$password /PORT=$port 2> "${TEMPDIR}\install_postgis_error.txt"$\r$\n'
    
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

; Silent install QGIS 2.8.1 for STDM
Function InstallQGIS 
     File "installers\${QGIS}"
    
     FileOpen $9 "${TEMPDIR}\install_qgis.bat" "w" 
     FileWrite $9 '"${TEMPDIR}\${QGIS}" /S 2> "${TEMPDIR}\install_qgis_error.txt"$\r$\n'
     FileWrite $9 "exit %ERRORLEVEL%$\r$\n" 
     FileClose $9
    
     DetailPrint "Installing ${QGIS_VERSION}..." 
     ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_qgis.bat"' 
     Pop $R0
    
    ;If PostGIS installer returned non-zero then an error occurred
     IntCmp $R0 0 qgis_install_success
    
     #QGIS installation failed. Provide feedback to user 

     StrCpy $7 "QGIS installation failed." 
     StrCpy $8 "${TEMPDIR}\install_qgis_error.txt" 
     Call AbortDisplayLogOption
    
    qgis_install_success: 
      DetailPrint "${QGIS_VERSION} has been successfully installed!" 
      return
    
FunctionEnd

; Set the path to the PostgreSQL base directory if PostgreSQL exists. If not,
; then will set an empty string
Function SetPostgreSQLBaseDirectory 
  SetRegView 64
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
      MessageBox MB_OK|MB_ICONEXCLAMATION "${PG_VERSION_DISPLAY} is already installed in your system, its installation will be skipped." 
    ${EndIf}
FunctionEnd

; Check if STDM database exists
Function CheckSTDMdb

    FileOpen $5 "check_stdm.bat" "w" 
    FileWrite $5 "SET PGPASSWORD=$password$\r$\n" 
    FileWrite $5 "SET PGPORT=$port$\r$\n" 
    FileWrite $5 '"$0\bin\psql.exe" -U $userName --list | findstr /R stdm > "${TEMPDIR}\stdm.db" $\r$\n' 
    ;FileWrite $5 '"C:\Program Files (x86)\PostgreSQL\9.3\bin\psql.exe" -U $userName --list | findstr /R stdm > "stdm.db" $\r$\n' 
    FileClose $5

    DetailPrint "Checking for STDM  database..." 
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\check_stdm.bat"' 
    ;ExecDos::exec '"$SYSDIR\cmd.exe" /c "check_stdm.bat"' 

    FileOpen $5 "stdm.db" "r" 
    FileRead $5 $9
    FileClose $5

FunctionEnd

; Check if tables have been created in STDM database
Function FindSTDMTables
    ; we look for one table in the stdm DB "witness", if found the scheme for STDM db is already created.
    FileOpen $5 "find_stdm_tables.bat" "w" 
    FileWrite $5 "SET PGPASSWORD=$password$\r$\n" 
    FileWrite $5 "SET PGPORT=$port$\r$\n" 
    FileWrite $5 '"$0\bin\psql.exe" -U $userName -d stdm -c "Select table_name from information_schema.tables" | findstr /R witness > "${TEMPDIR}\sample.txt" $\r$\n' 
    FileClose $5

    DetailPrint "Checking for STDM  Sample data..." 
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\find_stdm_tables.bat"' 

    FileOpen $5 "sample.txt" "r" 
    FileRead $5 $9
    FileClose $5

FunctionEnd

; Create STDM database 
Function CreateSTDMDatabase
#Set path to PostgreSQL base directory 
    Call SetPostgreSQLBaseDirectory

    ; if STDM DB already installed, warn and abort creation
    Call CheckSTDMdb
    ${If} $9 == ""
      ;MessageBox MB_ICONEXCLAMATION|MB_OK "STDM Not Found!" IDOK 
    ${Else}
      ;MessageBox MB_ICONEXCLAMATION|MB_OK "STDM Found." IDOK 
      DetailPrint "ERROR! Another copy of STDM database exist! Please un-install it manually then run the setup." 
      Abort
    ${EndIf}

    ; Create batch file for execution - create_stdm_template_db.bat
    FileOpen $5 "${TEMPDIR}\create_stdm_db.bat" "w" 
    FileWrite $5 "SET PGPASSWORD=$password$\r$\n" 
    FileWrite $5 "SET PGPORT=$port$\r$\n" 
    FileWrite $5 '"$0\bin\createdb.exe" -U $userName -h localhost $dbName 2> "${TEMPDIR}\create_stdm_db_error.txt"$\r$\n' 
    FileWrite $5 '"$0\bin\psql.exe" -U $userName -h localhost -c "CREATE EXTENSION postgis;" -d $dbName --set ON_ERROR_STOP=1 2> "${TEMPDIR}\create_stdm_db_error.txt"$\r$\n' 
    FileWrite $5 "exit %ERRORLEVEL%$\r$\n" 
    FileClose $5
    
    DetailPrint "Creating STDM template database..." 
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\create_stdm_db.bat"' 
    Pop $6
    
    IntCmp $6 0 create_stdm_template_db_success
    ; Creation ya database imefail. Provide feedback to user

    StrCpy $7 "STDM template database creation failed." 
    StrCpy $8 "${TEMPDIR}\create_stdm_db_error.txt" 
    Call AbortDisplayLogOption
    
    create_stdm_template_db_success: 
         DetailPrint "STDM template database has been successfully created!" 
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

Function InstallSampleData
  ; check if Postgress is installed
  ; if YES, then restore sample data from the backup file
  ; if NO, just copy the raw sample files
    DetailPrint "(Sample) Checking for existing PostgreSQL installation..."
    Call SetPostgreSQLBaseDirectory

    ${if} $0 == "" 
    ${Else}
         ; if STDM DB already installed, warn and abort creation
         Call FindSTDMTables
         ${If} $9 == ""
           ;MessageBox MB_ICONEXCLAMATION|MB_OK "STDM Not Found!" IDOK 
         ${Else}
           ;MessageBox MB_ICONEXCLAMATION|MB_OK "STDM Found." IDOK 
           DetailPrint "ERROR! Another copy of STDM sample data exist!"
	   DetailPrint "Please un-install it manually then run the setup." 
	   DetailPrint "Installation Aborting."
           Abort
         ${EndIf}

        File "installers\${STDM_SAMPLE_DATA}"

        ; cleans any existing data and restores from sample backup
        FileOpen $5 "${TEMPDIR}\stdm_db_backup.bat" "w" 
        FileWrite $5 "SET PGPASSWORD=$password$\r$\n" 
        FileWrite $5 "SET PGPORT=$port$\r$\n" 
        FileWrite $5 '"$0\bin\pg_restore.exe" -U $userName -h localhost -d $dbName -v --clean ${STDM_SAMPLE_DATA} 2> "${TEMPDIR}\stdm_db_backup_error.txt"$\r$\n' 
        FileWrite $5 "exit %ERRORLEVEL%$\r$\n" 
        FileClose $5

        DetailPrint "Restoring STDM sample database..." 
        ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\stdm_db_backup.bat"' 
        Pop $6
    
        IntCmp $6 0 stdm_sample_db_success

        ; restoring failed, provide feedback.
        StrCpy $7 "STDM sample database restore failed." 
        StrCpy $8 "${TEMPDIR}\stdm_db_backup_error.txt" 
    
        stdm_sample_db_success: 
            DetailPrint "STDM sample database restored successfully!" 
    ${EndIf}
       ;DetailPrint "Installing raw sample data..."
       Var /GLOBAL SAMPLE_FOLDER
       StrCpy $SAMPLE_FOLDER "$PROFILE\.stdm\SampleData"

       CreateDirectory "$SAMPLE_FOLDER"

       SetOutPath "$SAMPLE_FOLDER"
       File /r Sampledata\*.*

FunctionEnd

; Installer Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN 
    !insertmacro MUI_DESCRIPTION_TEXT ${SecQGIS} "Install ${QGIS_VERSION}" 
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPostgreSQL} "Install PostgreSQL 9.4 for Windows 64-bit" 
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPostGIS} "Install PostGIS 2.1.7 for Windows 64-bit"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecSampleData} "Install Sample dataset which includes \
                                                        photographs, TIFF image, shapefiles and CSV files"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

