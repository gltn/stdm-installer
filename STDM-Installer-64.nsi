;    --------------------------------------------------------------------
;    STDM-Installer-64.nsi - Windows Installer for
;    - PostgreSQL
;    - PostGIS
;    - QGIS 
;    ---------------------------------------------------------------------
;    Date                 : February 2017
;    Copyright            : (C) 2017 by UN-Habitat and implementing partners
;    Email                : stdm at unhabitat dot org
;--------------------------------------------------------------------------
;                                                                         #
;   This program is free software; you can redistribute it and/or modify  #
;   it under the terms of the GNU General Public License as published by  #
;   the Free Software Foundation; either version 2 of the License, or     #
;   (at your option) any later version.                                   #
;                                                                         #
;--------------------------------------------------------------------------

SetCompressor lzma

RequestExecutionLevel admin

!define COMPANY "Global Land Tool Network"
!define URL www.stdm.gltn.net

# MUI Symbol Definitions
!define MUI_ICON "..\images\stdm.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_UNICON "..\images\stdm.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\images\SetupSideBanner.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\images\SetupSideBanner.bmp"
!define MUI_LICENSEPAGE
!define MUI_COMPONENTSPAGE
# Included files
!include "x64.nsh"
!include "FileFunc.nsh"
!include MUI2.nsh
!include nsDialogs.nsh
!include LogicLib.nsh
!include WinMessages.nsh
!include WinVer.nsh

!define MUI_WELCOMEPAGE_TITLE_3LINES
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_LICENSE $(license)

!define MUI_PAGE_CUSTOMFUNCTION_SHOW check_disk_space
!insertmacro MUI_PAGE_COMPONENTS
Page custom dbConnPropPage dbConnPropPageLeave

!define MUI_INSTFILESPAGE 
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE_3LINES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English" 
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Portuguese"

# Installer languages
LangString L_NAME ${LANG_ENGLISH} "Social Tenure Domain Model Version ${STDM_VERSION}"
LangString L_NAME ${LANG_FRENCH} "du Modèle de Domaine de Tenure Social Version ${STDM_VERSION}"
LangString L_NAME ${LANG_PORTUGUESE} "Versão ${STDM_VERSION} de Modelo de Domínio de Posse Social"

Name $(L_NAME)

LangString BRAND_TEXT ${LANG_ENGLISH} "Global Land Tool Network" 
LangString BRAND_TEXT ${LANG_FRENCH} "Réseau Mondial d'Outils Fonciers"
LangString BRAND_TEXT ${LANG_PORTUGUESE} "Rede Global de Ferramenta Terrestre"

LangString PRODUCT_NAME ${LANG_ENGLISH} "Social Tenure Domain Model"
LangString PRODUCT_NAME ${LANG_FRENCH} "du Modèle de Domaine de Tenure Social"
LangString PRODUCT_NAME ${LANG_PORTUGUESE} "de Modelo de Domínio de Posse Social"

LangString H_TITLE ${LANG_ENGLISH} "Database Connection Properties."
LangString H_SUBTITLE ${LANG_ENGLISH} "Please specify the database connection properties for installing PostgreSQL and PostGIS."

LangString H_TITLE ${LANG_FRENCH} "Propriétés de la connexion à la base de données"
LangString H_SUBTITLE ${LANG_FRENCH} "Veuillez spécifier les propriétés de la connexion à la base de données pour installer PostgreSQL et PostGIS."

LangString H_TITLE ${LANG_PORTUGUESE} "Propriedades de Conexão de Base de dados."
LangString H_SUBTITLE ${LANG_PORTUGUESE} "Por favor, especifique as propriedades de conexão de base de dados para a instalação do PostgreSQL e PostGIS."

LangString G_TITLE ${LANG_ENGLISH} "Database Connection Properties."
LangString G_TITLE ${LANG_FRENCH} "Propriétés de la connexion à la base de données"
LangString G_TITLE ${LANG_PORTUGUESE} "Propriedades de Conexão de Base de dados."

LangString SAMPLE_DATA ${LANG_ENGLISH} "Sample Data" 
LangString SAMPLE_DATA ${LANG_FRENCH} "Données d'échantillonnage"
LangString SAMPLE_DATA ${LANG_PORTUGUESE} "Dados de amostra"

LangString SERVICE_PACK ${LANG_ENGLISH} "Windows7 Service pack 1 is required"
LangString SERVICE_PACK ${LANG_FRENCH} "Le service pack 1 de service Windows 7 est requis"
LangString SERVICE_PACK ${LANG_PORTUGUESE} "Windows7 Service pack 1 é necessário"

LangString WARN_DISK_SPACE ${LANG_ENGLISH} "Not enough space in Drive C: to install application. Available space: $R4MB.$\r$\n Installation terminated."
LangString WARN_DISK_SPACE ${LANG_FRENCH} "Vous ne disposez pas de l'espace suffisant dans le disque C: pour installer cette application. Espace disponible: $R4MB.$\r$\n Installation terminée"

LangString WARN_DISK_SPACE ${LANG_PORTUGUESE} "Não há espaço suficiente no Drive c: para instalar o aplicativo. Espaço disponível: $R4MB.$\r$\n Instalação terminada."

LangString LBL_USER_NAME ${LANG_ENGLISH} "User Name:" 
LangString LBL_USER_NAME ${LANG_FRENCH} "Nom d'utilisateur:"
LangString LBL_USER_NAME ${LANG_PORTUGUESE} "Nome de usuário:"

LangString LBL_PASSWORD ${LANG_ENGLISH} "Password:" 
LangString LBL_PASSWORD ${LANG_FRENCH} "Mot de passe:"
LangString LBL_PASSWORD ${LANG_PORTUGUESE} "Senha:"

LangString LBL_PASSWORD2 ${LANG_ENGLISH} "Re-enter Password:" 
LangString LBL_PASSWORD2 ${LANG_FRENCH} "Retaper le mot de passe:"
LangString LBL_PASSWORD2 ${LANG_PORTUGUESE} "Reinserir a Senha:"

LangString LBL_PORT ${LANG_ENGLISH} "Port:"
LangString LBL_PORT ${LANG_FRENCH} "Port:"
LangString LBL_PORT ${LANG_PORTUGUESE} "Ponto de Connecção:"

LangString LBL_DB_NAME ${LANG_ENGLISH} "Database Name:"
LangString LBL_DB_NAME ${LANG_FRENCH} "Nom de la base de données:"
LangString LBL_DB_NAME ${LANG_PORTUGUESE} "Nome do base de dados:"

LangString VALUES_NOTE ${LANG_ENGLISH} "Please take note of these values as they will be required for configuring STDM on using it for the first time."
LangString VALUES_NOTE ${LANG_FRENCH} "Veillez prendre note de ces valeurs car elles seront nécessaires pour la configuration de STDM lors sa premiere utilisation"
LangString VALUES_NOTE ${LANG_PORTUGUESE} "Por favor tome nota destes valores como eles serão necessários para configurar a STDM em usá-lo pela primeira vez."

LangString WARN_POSTGRES_USER ${LANG_ENGLISH} "Please specify the postgres user account name.$\nYou can use 'postgres' as the default."
LangString WARN_POSTGRES_USER ${LANG_FRENCH} "Veuillez spécifier le nom du compte d'utilisateur de PostgreSQL.$\nVous pouvez utiliser 'postgres' comme valeur par défaut."
LangString WARN_POSTGRES_USER ${LANG_PORTUGUESE} "Por favor, especifique o nome de conta de usuário postgres.$\nVocê pode usar 'postgres' como padrão."

LangString WARN_PASSWORD ${LANG_ENGLISH} "Please enter password for the postgres account"
LangString WARN_PASSWORD ${LANG_FRENCH} "Veuillez taper le mot de passe du compte postgreSQL"
LangString WARN_PASSWORD ${LANG_PORTUGUESE} "Por favor, insira a senha para a conta do postgres"

LangString WARN_PASSWORD2 ${LANG_ENGLISH} "Please re-enter password for the postgres account"
LangString WARN_PASSWORD2 ${LANG_FRENCH} "Veuillez retaper le mot de passe du compte postgreSQL"
LangString WARN_PASSWORD2 ${LANG_PORTUGUESE} "Por favor, re-inserir a senha para a conta do postgres"

LangString WARN_PASSWORD_MISMATCH ${LANG_ENGLISH} "Password and re-entered password should be the same"
LangString WARN_PASSWORD_MISMATCH ${LANG_FRENCH} "Le mot de passe et le mot de passe de confirmation doivent être identiques"
LangString WARN_PASSWORD_MISMATCH ${LANG_PORTUGUESE} "Senha e senha re-inserida devem ser o mesmo"

LangString WARN_DB_PORT ${LANG_ENGLISH} "Please enter the database port number" 
LangString WARN_DB_PORT ${LANG_FRENCH} "Veuillez saisir le numéro du port de la base de donnée"
LangString WARN_DB_PORT ${LANG_PORTUGUESE} "Por favor, inserir o número da porta de base de dados"

LangString INST_POSTGRES_START ${LANG_ENGLISH} "Installing PostgreSQL${PG_VERSION} ..."
LangString INST_POSTGRES_START ${LANG_FRENCH} "Installation de PostgreSQL${PG_VERSION} ..."
LangString INST_POSTGRES_START ${LANG_PORTUGUESE} "Instalando o PostgreSQL${PG_VERSION} ..."

LangString INST_POSTGRES_FAIL ${LANG_ENGLISH} "PostgreSQL installation failed!" 
LangString INST_POSTGRES_FAIL ${LANG_FRENCH} "L'installation de PostgreSQL a échouée!"
LangString INST_POSTGRES_FAIL ${LANG_PORTUGUESE} "Falha na instalação do PostgreSQL!"

LangString INST_POSTGRES_SUCCESS ${LANG_ENGLISH} "PostgreSQL${PG_VERSION} has been successfully installed."
LangString INST_POSTGRES_SUCCESS ${LANG_FRENCH} "PostgreSQL${PG_VERSION} a été installé avec succès."
LangString INST_POSTGRES_SUCCESS ${LANG_PORTUGUESE} "PostgreSQL${PG_VERSION} Foi instalado com sucesso."

LangString INST_POSTGIS_START ${LANG_ENGLISH} "Installing PostGIS${POSTGIS_VERSION} ..."
LangString INST_POSTGIS_START ${LANG_FRENCH} "Installation de PostGIS${POSTGIS_VERSION} ..."
LangString INST_POSTGIS_START ${LANG_PORTUGUESE} "Instalando o PostGIS${POSTGIS_VERSION} ..."

LangString INST_POSTGIS_FAIL ${LANG_ENGLISH} "PostGIS installation failed!"
LangString INST_POSTGIS_FAIL ${LANG_FRENCH} "L'installation de PostGIS a échouée!"
LangString INST_POSTGIS_FAIL ${LANG_PORTUGUESE} "Falha na instalação do PostGIS!"

LangString INST_POSTGIS_SUCCESS ${LANG_ENGLISH} "PostGIS${POSTGIS_VERSION} has been successfully installed."
LangString INST_POSTGIS_SUCCESS ${LANG_FRENCH} "PostGIS${POSTGIS_VERSION} a été installé avec succès."
LangString INST_POSTGIS_SUCCESS ${LANG_PORTUGUESE} "PostGIS${POSTGIS_VERSION} Foi instalado com sucesso."

LangString INST_QGIS_START ${LANG_ENGLISH} "Installing ${QGIS_VERSION} ... "
LangString INST_QGIS_START ${LANG_FRENCH} "Installation ${QGIS_VERSION} ... "
LangString INST_QGIS_START ${LANG_PORTUGUESE} "Instalando o ${QGIS_VERSION} ... "

LangString INST_QGIS_FAIL ${LANG_ENGLISH} "QGIS installation failed!"
LangString INST_QGIS_FAIL ${LANG_FRENCH} "L'installation de QGIS a échoué!"
LangString INST_QGIS_FAIL ${LANG_PORTUGUESE} "Falha na instalação do QGIS."

LangString INST_QGIS_SUCCESS ${LANG_ENGLISH} "${QGIS_VERSION} has been successfully installed."
LangString INST_QGIS_SUCCESS ${LANG_FRENCH} "${QGIS_VERSION} a été installé avec succès."
LangString INST_QGIS_SUCCESS ${LANG_PORTUGUESE} "${QGIS_VERSION} Foi instalado com sucesso."

LangString CHECK_POSTGRES_INST ${LANG_ENGLISH} "Checking for existing PostgreSQL installation ..."
LangString CHECK_POSTGRES_INST ${LANG_FRENCH} "Vérification d'installation existante de PostgreSQL ..."
LangString CHECK_POSTGRES_INST ${LANG_PORTUGUESE} "Verificação de instalação do PostgreSQL existente..."

LangString POSTGRES_EXIST ${LANG_ENGLISH} "An existing installation of PostgreSQL ${PG_VERSION} has been found.$\r$\n Installer will skip PostgreSQL installation "
LangString POSTGRES_EXIST ${LANG_FRENCH} "Une installation existante de PostgreSQL ${PG_VERSION} a été trouvée.$\r$\n L'installateur ignorera l'installation de PostgreSQL"
LangString POSTGRES_EXIST ${LANG_PORTUGUESE} "Verificou-se uma instalação existente do PostgreSQL ${PG_VERSION}.$\r$\n Instalador irá ignorar a instalação do PostgreSQL"

LangString YES_WORD ${LANG_ENGLISH} "yes"
LangString YES_WORD ${LANG_FRENCH} "qui"
LangString YES_WORD ${LANG_PORTUGUESE} "sim"

LangString CHECK_USER ${LANG_ENGLISH} "Checking for user '${POSTGRES_USER}'..."
LangString CHECK_USER ${LANG_FRENCH} "Vérification de l'utilisateur '${POSTGRES_USER}'..."
LangString CHECK_USER ${LANG_PORTUGUESE} "Verificação de usuário '${POSTGRES_USER}'..."

LangString USER_NOT_FOUND ${LANG_ENGLISH} "User '${POSTGRES_USER}' not found!"
LangString USER_NOT_FOUND ${LANG_FRENCH} "Utilisateur '${POSTGRES_USER}' non trouvé!"
LangString USER_NOT_FOUND ${LANG_PORTUGUESE} "Usuário '${POSTGRES_USER}' não encontrado!"

LangString DELETE_USER ${LANG_ENGLISH} "Deleting user '${POSTGRES_USER}'..."
LangString DELETE_USER ${LANG_FRENCH} "Suppression de l'utilisateur '${POSTGRES_USER}'..."
LangString DELETE_USER ${LANG_PORTUGUESE} "Exclusão de usuário '${POSTGRES_USER}'..."

LangString CHECK_STDM ${LANG_ENGLISH} "Checking for STDM database ..." 
LangString CHECK_STDM ${LANG_FRENCH} "Vérification de la base de données STDM ..."
LangString CHECK_STDM ${LANG_PORTUGUESE} "Verificação de base de dados STDM ..."

LangString CHECK_STDM_SAMPLE_DATA ${LANG_ENGLISH} "Checking for STDM  Sample data ..." 
LangString CHECK_STDM_SAMPLE_DATA ${LANG_FRENCH} "Vérification des données échantillonnage de STDM ..."
LangString CHECK_STDM_SAMPLE_DATA ${LANG_PORTUGUESE} "Verificação de dados de exemplo da STDM..."

LangString ERR_STDM_DB ${LANG_ENGLISH} "ERROR! Another copy of STDM database exist! Please un-install it manually then run the setup." 
LangString ERR_STDM_DB ${LANG_FRENCH} "Une autre copie de la base de données STDM existe! Veuillez la désinstaller manuellement, puis exécutez l'installation."
LangString ERR_STDM_DB ${LANG_PORTUGUESE} "Existe uma outra cópia do base de dados STDM! Por favor desinstalá-lo manualmente, em seguida execute o setup."

LangString CREATE_DB ${LANG_ENGLISH} "Creating STDM template database ..."
LangString CREATE_DB ${LANG_FRENCH} "Création du modèle de la base de données de STDM ..."
LangString CREATE_DB ${LANG_PORTUGUESE} "Criando o base de dados do STDM modelo ..."

LangString CREATE_DB_FAIL ${LANG_ENGLISH} "STDM template database creation failed!" 
LangString CREATE_DB_FAIL ${LANG_FRENCH} "La création du modèle de la base de données de STDM a échoué!"
LangString CREATE_DB_FAIL ${LANG_PORTUGUESE} "Criação de base de dados do modelo de STDM falhou!"

LangString CREATE_DB_SUCCESS ${LANG_ENGLISH} "STDM template database has been successfully created." 
LangString CREATE_DB_SUCCESS ${LANG_FRENCH} "Le modèle de la base de données de STDM a été créée avec succès."
LangString CREATE_DB_SUCCESS ${LANG_PORTUGUESE} "Base de dados modelo STDM foi criado com êxito."

LangString ERR_SAMPLE_DATA ${LANG_ENGLISH} "ERROR! Another copy of STDM sample data exist! $\r$\nPlease un-install it manually then run the setup.$\r$\nInstallation Aborting."
LangString ERR_SAMPLE_DATA ${LANG_FRENCH} "ERREUR! Une autre copie d'exemples de données STDM existe!$\r$\n Désinstallez-le manuellement, puis exécutez l'installation.$\r$\nAnnulation de l'installation."
LangString ERR_SAMPLE_DATA ${LANG_PORTUGUESE} "ERRO! Existe outra cópia de dados de exemplo da STDM!$\r\n Por favor desinstalá-lo manualmente, em seguida execute o setup.$\r$\nAbortando a instalação."

LangString RESTORE_SAMPLE_DATA ${LANG_ENGLISH} "Restoring STDM sample database..." 
LangString RESTORE_SAMPLE_DATA ${LANG_FRENCH} "Restauration de la base de données example de STDM ..."
LangString RESTORE_SAMPLE_DATA ${LANG_PORTUGUESE} "Restaurando o base de dados de amostra STDM..."

LangString RESTORE_SAMPLE_DATA_FAIL ${LANG_ENGLISH} "STDM sample database restore failed!" 
LangString RESTORE_SAMPLE_DATA_FAIL ${LANG_FRENCH} "La restauration de la base de données exemple de STDM a échouée!"
LangString RESTORE_SAMPLE_DATA_FAIL ${LANG_PORTUGUESE} "Restauração de base de dados de amostra STDM falhou!"

LangString RESTORE_SAMPLE_DATA_SUCCESS ${LANG_ENGLISH} "STDM sample database restored successfully." 
LangString RESTORE_SAMPLE_DATA_SUCCESS ${LANG_FRENCH} "La base de données exemple STDM a été restaurée avec succès"
LangString RESTORE_SAMPLE_DATA_SUCCESS ${LANG_PORTUGUESE} "STDM exemplo banco de dados restaurado com êxito."

LangString SAMPLE_DATA_EXIST ${LANG_ENGLISH} "Raw Sample data exists! Skipped installation."
LangString SAMPLE_DATA_EXIST ${LANG_FRENCH} "Des données d'exemples  existent! Installation ignorée."
LangString SAMPLE_DATA_EXIST ${LANG_PORTUGUESE} "Dados brutos de amostra existem! Instalação saltada."

LangString STDM_FOLDER_EXIST ${LANG_ENGLISH} "${STDM_FOLDER} - exist!"
LangString STDM_FOLDER_EXIST ${LANG_FRENCH} "${STDM_FOLDER} - existe!"
LangString STDM_FOLDER_EXIST ${LANG_PORTUGUESE} "${STDM_FOLDER} - existe!"

LangString CREATE_STDM_PLUGIN ${LANG_ENGLISH} "Creating STDM plugin ..."
LangString CREATE_STDM_PLUGIN ${LANG_FRENCH} "Creation de l'extension STDM ..."
LangString CREATE_STDM_PLUGIN ${LANG_PORTUGUESE} "Criando a STDM plugin ..."

LangString ADMIN_UNIT_EXIST ${LANG_ENGLISH} "Admin units data exists! Skipped installation."
LangString ADMIN_UNIT_EXIST ${LANG_FRENCH} "Les données des unités administratives existent! Installation ignorée."
LangString ADMIN_UNIT_EXIST ${LANG_PORTUGUESE} "Existem dados de unidades de admin! Instalação saltada."

LangString BACKUP_DATA_EXIST ${LANG_ENGLISH} "Backup data exists! Skipped installation."
LangString BACKUP_DATA_EXIST ${LANG_FRENCH} "Des données de sauvegarde existent! Installation ignorée."
LangString BACKUP_DATA_EXIST ${LANG_PORTUGUESE} "Existe cópia de dados segura! Instalação ignorada."

LangString INST_QGIS ${LANG_ENGLISH} "Install ${QGIS_VERSION}" 
LangString INST_QGIS ${LANG_FRENCH} "Installer ${QGIS_VERSION}" 
LangString INST_QGIS ${LANG_PORTUGUESE} "Instalar ${QGIS_VERSION}"  

LangString INST_POSTGRES ${LANG_ENGLISH} "Install ${PG_VERSION_DISPLAY} for Windows 64-bit" 
LangString INST_POSTGRES ${LANG_FRENCH} "Installer ${PG_VERSION_DISPLAY} Pour Windows 64 bits"
LangString INST_POSTGRES ${LANG_PORTUGUESE} "Instalar ${PG_VERSION_DISPLAY} Para windows 64-bit"

LangString INST_POSTGIS ${LANG_ENGLISH} "Install ${POSTGIS_VERSION_DISPLAY} for Windows 64-bit"
LangString INST_POSTGIS ${LANG_FRENCH} "Installer ${POSTGIS_VERSION_DISPLAY} Pour Windows 64 bits"
LangString INST_POSTGIS ${LANG_PORTUGUESE} "Instalar ${POSTGIS_VERSION_DISPLAY} Para windows 64-bit"

LangString INST_SAMPLE_DATA ${LANG_ENGLISH} "Install Sample dataset which includes photographs, TIFF image, shapefiles and CSV files"
LangString INST_SAMPLE_DATA ${LANG_FRENCH} "Installer un exemple de base de données incluant des photographies, des images TIFF, des fichiers Shapefiles et des fichiers CSV"
LangString INST_SAMPLE_DATA ${LANG_PORTUGUESE} "Instalar o conjunto de dados de amostra que inclui fotografias, imagem TIFF, shapefiles e arquivos CSV"


LicenseLangString license ${LANG_ENGLISH} "..\common\license_en.rtf"
LicenseLangString license ${LANG_FRENCH} "..\common\license_fr.rtf"
LicenseLangString license ${LANG_PORTUGUESE} "..\common\license_pt.rtf"
# Installer pages


!define GetCompName 
!macro GetCompName COMPNAME
   System::Call "Kernel32.dll::GetComputerNameA(t .r0, *i ${NSIS_MAX_STRLEN} r1)i.r2"
   Pop ${COMPNAME}
   StrCpy ${COMPNAME} "$0"
!macroend

!define DeleteUser
!macro DeleteUser SERVER_NAME USERNAME
  # Delete a user
  System::Call 'netapi32::NetUserDel(w "${SERVER_NAME}",w "${USERNAME}")i.r0'
!macroend

!ifdef LIVE 
; for production setup
    !define INSTALLERS_DIR "installers"  
    !define STDM_PLUGIN "..\common\stdm" 
    !define RAW_SAMPLE_DATA_DIR "..\common\sample-data" 
    !define RAW_TEMPLATE_DIR "..\common\Reports\Templates" 
    !define RAW_ADMIN_UNITS_DATA "..\common\Data\admin_units_data\"
    !define RAW_BACKUP_DATA "..\common\Data\backup\"
    !define DB_SAMPLE_DATA_DIR "..\common"  
    !define COMMON_FOLDER "..\common"  
    !define SETUP_FILEPATH "..\bin\${SETUP_FILENAME}"
!else
; for testing 
    !define INSTALLERS_DIR "..\dummy\dummy_installers"      
    !define STDM_PLUGIN "..\dummy\dummy_stdm" 
    !define RAW_SAMPLE_DATA_DIR "..\dummy\dummy_sample_data"
    !define RAW_TEMPLATE_DIR "..\dummy\dummy_installers\Reports\Templates" 
    !define RAW_ADMIN_UNITS_DATA "..\dummy\dummy_installers\Data\admin_units_data\"
    !define RAW_BACKUP_DATA "..\dummy\dummy_installers\Data\backup\"
    !define DB_SAMPLE_DATA_DIR "..\dummy\dummy_installers" 
    !define COMMON_FOLDER "..\dummy\dummy_installers" 
    !define SETUP_FILEPATH "${SETUP_FILENAME}-TEST.exe"
!endif


# Installer attributes
OutFile "${SETUP_FILEPATH}" 
InstallDir "$PROGRAMFILES\STDM"
CRCCheck on
XPStyle on 
BrandingText $(BRAND_TEXT)
ShowInstDetails show 
VIProductVersion 1.1.1.0 
VIAddVersionKey ProductName $(PRODUCT_NAME)
VIAddVersionKey ProductVersion "${STDM_VERSION}"
VIAddVersionKey CompanyName "${COMPANY}" 
VIAddVersionKey CompanyWebsite "${URL}" 
VIAddVersionKey FileVersion "${STDM_VERSION}" 
VIAddVersionKey FileDescription "STDM ${STDM_VERSION}"
VIAddVersionKey LegalCopyright "" 
ShowUninstDetails show

; Place all temporary files used by the installer in their own subdirectory
; under $TEMP (makes the files easier to find)
!define TEMPDIR "$PLUGINSDIR\stdm_installer"

; Custom UI for database connection
Var Dialog
Var userNameLbl
Var userNameTxt
Var groupConn
Var passLbl
Var passLbl2
Var passTxt 
Var passTxt2
Var portLbl 
Var portTxt 
Var dbNameLbl 
Var dbNameTxt 
Var notificationLbl

;Database connection information
Var userName 
Var password 
Var password2
Var host 
Var port 
Var dbName
Var pg_found

#Postgres registry settings 
Var pg_reg_user 

;PostgreSQL install option
Var PG_INSTALL_OPTIONS

Section -SETTINGS 
    SetOutPath ${TEMPDIR} 
    SetOverwrite ifnewer 
SectionEnd

# Installer sections
Section "${QGIS_VERSION}" SecQGIS 
   AddSize 2097152 ; 2GB
   !ifdef LIVE 
       Call InstallQGIS 
       Call WriteDBConnToReg
       Call Install_STDM_Plugin
       ; reset output path
       SetOutPath ${TEMPDIR} 
   !else
       DetailPrint "Testing QGIS installation..."
   !endif

SectionEnd

Section "${PG_VERSION_DISPLAY}" SecPostgreSQL
   !ifdef LIVE
      Call InstallPostgreSQL
   !else
       DetailPrint "Testing Postgres installation..."
   !endif
SectionEnd

Section "${POSTGIS_VERSION_DISPLAY}" SecPostGIS
    !ifdef LIVE
        Call InstallPostGIS
    !else
       DetailPrint "Testing PostGIS installation..."
    !endif
SectionEnd

# sample data
Section $(SAMPLE_DATA) SecSampleData
    !ifdef LIVE
        Call InstallSampleData
    !else
       DetailPrint "Testing Sample data installation..."
    !endif
SectionEnd

Function .onInit
    !insertmacro MUI_LANGDLL_DISPLAY

    InitPluginsDir
    StrCpy $userName "postgres"  
    StrCpy $password "" 
    StrCpy $host "localhost" 
    StrCpy $port "5433" 
    StrCpy $dbName "stdm" 
    StrCpy $PG_INSTALL_OPTIONS ""
	
   #Default pg registry options 
   StrCpy $pg_reg_user ""
   StrCpy $pg_found "no"

   ${If} ${IsWin7}
   ${AndIfNot} ${AtLeastServicePack} 1
    MessageBox MB_OK $(SERVICE_PACK)
    Quit
   ${EndIf}

   Call EnableWinScriptHost

FunctionEnd

Function EnableWinScriptHost
  ; Enable wscript key in the registry known to block PostgreSQL from installing
  SetRegView 64
  WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows Script Host\Settings" "Enabled" 1 
FunctionEnd

Function check_disk_space
    ${DriveSpace} "C:\" "/D=F /S=G" $R0
    SectionGetSize ${SecQGIS} $R1
    IntOp $R3 $R1 / 1048576 ; size in GB
    ${if} $R3 > $R0
        ${DriveSpace} "C:\" "/D=F /S=M" $R4
        MessageBox MB_OK $(WARN_DISK_SPACE) 
        ;Disable Next Button
        GetDlgItem $0 $HWNDPARENT 1
        EnableWindow $0 0
    ${EndIf}
FunctionEnd

Function .onSelChange
    ;${IfNot} ${SectionIsSelected} ${SecQGIS}
    ;   Goto disable
    ;${Else}
    ;   Goto enable
    ;${EndIf}

    ; postgis is selected but postgres is not!
    ;${IfNot} ${SectionIsSelected} ${SecPostgreSQL}
    ;${AndIf} ${SectionIsSelected} ${SecPostGIS}
    ;   Goto disable
    ;${EndIf}

    ${IfNot} ${SectionIsSelected} ${SecQGIS}
    ${AndIfNot} ${SectionIsSelected} ${SecPostgreSQL}
    ${AndIfNot} ${SectionIsSelected} ${SecPostGIS}
       Goto disable
    ${Else}
       Goto enable
    ${EndIf}

      enable:
        ;Enable Next Button
        GetDlgItem $0 $HWNDPARENT 1
        EnableWindow $0 1
        Abort

      disable:
        ;Disable Next Button
        GetDlgItem $0 $HWNDPARENT 1
        EnableWindow $0 0

FunctionEnd

;Database connection property page
Function dbConnPropPage
    !insertmacro MUI_HEADER_TEXT $(H_TITLE) $(H_SUBTITLE) 

    ; If user has not selected Postgres,
    ; PostGIS or Sample data componets then no need to show this dialog
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
    
    ${NSD_CreateGroupBox} 0 0 -1 -5 $(G_TITLE)
    Pop $groupConn
    
    # (X,Y,W,H)
    
    ${NSD_CreateLabel} 30 38 100 20 $(LBL_USER_NAME)
    Pop $userNameLbl

    ${NSD_CreateText} 152 38 60% 20 $userName 
    Pop $userNameTxt
    #Disable control so that the user does not change the postgres service account 
    EnableWindow $userNameTxt 0
    
    ${NSD_CreateLabel} 30 68 100 20 $(LBL_PASSWORD)
    Pop $passLbl

    ${NSD_CreatePassword} 152 68 60% 20 $password 
    Pop $passTxt

    ${NSD_CreateLabel} 30 98 100 60 $(LBL_PASSWORD2)
    pop $passLbl2

    ${NSD_CreatePassword} 152 98 60% 20 $password2
    pop $passTxt2
    
    ${NSD_CreateLabel} 30 128 120 60 $(LBL_PORT)
    Pop $portLbl

    ${NSD_CreateText} 152 128 60% 20 $port 
    Pop $portTxt
    #Disable control so that the user does not change the postgres port number #EnableWindow $portTxt 0
    
    ${NSD_CreateLabel} 30 158 100 60 $(LBL_DB_NAME)
    Pop $dbNameLbl

    ${NSD_CreateText} 152 158 60% 20 $dbName 
    Pop $dbNameTxt 
    #Disable control so that the user does not change the name of the STDM database 
    EnableWindow $dbNameTxt 0
    
    ${NSD_CreateLabel} 35 190 85% 40 $(VALUES_NOTE)
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
      MessageBox MB_OK|MB_ICONSTOP $(WARN_POSTGRES_USER)
      Abort
  ${EndIf}
	
  ${NSD_GetText} $passTxt $password
  ${If} $password == ""
    MessageBox MB_OK|MB_ICONSTOP $(WARN_PASSWORD)
    Abort
  ${EndIf}

  ${NSD_GetText} $passTxt2 $password2
  ${If} $password2 == ""
    MessageBox MB_OK|MB_ICONSTOP $(WARN_PASSWORD2)
    Abort
  ${EndIf}

  ${If} $password == $password2
  ${Else}
    MessageBox MB_OK|MB_ICONSTOP $(WARN_PASSWORD_MISMATCH)
    Abort
  ${EndIf}
	
  ${NSD_GetText} $portTxt $port 
  ${If} $port == "" 
    MessageBox MB_OK|MB_ICONSTOP $(WARN_DB_PORT)
    Abort
  ${EndIf}
	
  #Call PostgresRegUserName 
  #${If} $pg_reg_user == $userName 
  #MessageBox MB_YESNO|MB_ICONEXCLAMATION "The installer has detected an existing copy of PostgreSQL.\ 
   #$\nYou can either de-select installing PostgreSQL in the components page or ensure that the specified database connection properties match \
	#those of the existing PostgreSQL installation.$\nProceed with the installation?" IDYES next IDNO no_abort
   #${Else}
      #Goto next
   #${EndIf}
	
	#no_abort:
	  #Abort
		
	#next:
    
FunctionEnd

; Copy postgresql installer into temp directory and execute with the specified
; options
Function InstallPostgreSQL

    Call CheckPostgresql

    ${IF} $pg_found == "no"
        ;Specify PostgreSQL options for unattended mode installation 
        StrCpy $PG_INSTALL_OPTIONS "--mode unattended --superaccount $userName --superpassword $password --serviceaccount $userName  --servicepassword $password --serverport $port"

        File "${INSTALLERS_DIR}\${POSTGRESQL}"
            
        #Create batch file for executing postgresl in unattended mode
        FileOpen $1 "${TEMPDIR}\install_postgresql.bat" "w"
        FileWrite $1 '"${TEMPDIR}\${POSTGRESQL}" $PG_INSTALL_OPTIONS 2> "${TEMPDIR}\install_postgres_error.txt"$\r$\n'
        FileWrite $1 "exit %ERRORLEVEL%$\r$\n" 
        FileClose $1

        DetailPrint $(INST_POSTGRES_START)
        ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_postgresql.bat"' 
        Pop $2

        ; If pg installer returned non-zero then an error occurred
        IntCmp $2 0 postgresql_install_success

        #PostgreSQL installation failed. Provide feedback to user
        StrCpy $7 $(INST_POSTGRES_FAIL)
        StrCpy $8 "${TEMPDIR}\install_postgres_error.txt" 
        Call AbortDisplayLogOption

        postgresql_install_success:
           DetailPrint $(INST_POSTGRES_SUCCESS)
           return
    ${ENDIF}

FunctionEnd

; Silent install PostGIS and create STDM template database.   

Function InstallPostGIS 
    File "${INSTALLERS_DIR}\${POSTGIS}"
    
    FileOpen $3 "${TEMPDIR}\install_postgis.bat" "w"

    FileWrite $3 '"${TEMPDIR}\${POSTGIS}" /S /USERNAME=$userName /PASSWORD=$password /PORT=$port 2> "${TEMPDIR}\install_postgis_error.txt"$\r$\n'
    
    FileWrite $3 "exit %ERRORLEVEL%$\r$\n" 
    FileClose $3
    
    DetailPrint $(INST_POSTGIS_START)
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_postgis.bat"' 
    Pop $4
    
    ; If PostGIS installer returned non-zero then an error occurred
    IntCmp $4 0 postgis_install_success
    
    #PostGIS installation failed. Provide feedback to user
    StrCpy $7 $(INST_POSTGIS_FAIL)
    StrCpy $8 "${TEMPDIR}\install_postgis_error.txt" 
    Call AbortDisplayLogOption
    
    postgis_install_success:
      DetailPrint $(INST_POSTGIS_SUCCESS) 
      Call CreateSTDMDatabase
        
FunctionEnd

; Silent install QGIS 2.14 for STDM
Function InstallQGIS 
     ; if postgres is selected for installation, check pre-existing postgres
     ; installation abort before installing anything
     ; ${If} ${SectionIsSelected} ${SecPostgreSQL}
     ;
        Call CheckPostgresql
        ${IF} $pg_found == "yes"
        ${ELSE}
        ${ENDIF}
        
     ; ${EndIf}

     File "${INSTALLERS_DIR}\${QGIS}"
    
     FileOpen $9 "${TEMPDIR}\install_qgis.bat" "w" 
     FileWrite $9 '"${TEMPDIR}\${QGIS}" /S 2> "${TEMPDIR}\install_qgis_error.txt"$\r$\n'
     FileWrite $9 "exit %ERRORLEVEL%$\r$\n" 
     FileClose $9
    
     DetailPrint $(INST_QGIS_START)
     ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\install_qgis.bat"' 
     Pop $R0
    
    ;If PostGIS installer returned non-zero then an error occurred
     IntCmp $R0 0 qgis_install_success
    
     #QGIS installation failed. Provide feedback to user 

     StrCpy $7 $(INST_QGIS_FAIL)
     StrCpy $8 "${TEMPDIR}\install_qgis_error.txt" 
     Call AbortDisplayLogOption
    
    qgis_install_success: 
      DetailPrint $(INST_QGIS_SUCCESS) 
      return
    
FunctionEnd

; Set the path to the PostgreSQL base directory if PostgreSQL exists. If not,
; then will set an empty string
Function SetPostgreSQLBaseDirectory 
  SetRegView 64
  ReadRegStr $0 HKLM "Software\PostgreSQL\Installations\${PG_GUID}" "Base Directory"
FunctionEnd

Function CheckUserPostgres
    FileOpen $5 "${TEMPDIR}\winuser.bat" "w" 
    FileWrite $5 'net user | findstr /i /R "${POSTGRES_USER}" > "${TEMPDIR}\users" $\r$\n' 
    FileClose $5

    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\winuser.bat"' 

    FileOpen $5 "users" "r" 
    FileRead $5 $9
    FileClose $5
FunctionEnd
   
; Check if there is an existing PostgreSQL installation
Function CheckPostgresql
  #Get the installation directory 
  DetailPrint $(CHECK_POSTGRES_INST)

  ; 1. check for postgreSQL data folder
  ${If} ${FileExists} `$PROGRAMFILES64\PostgreSQL\${PG_VERSION}\*.*`
     MessageBox MB_ICONEXCLAMATION|MB_OK $(POSTGRES_EXIST) IDOK
     StrCpy $pg_found $(YES_WORD)
     return
  ${Else}
  ${Endif}

  ; 2. check for 'postgres' account, if found, delete it.
  ; Ideally, postgres account should not exists without a PostgreSQL installation.
  !insertmacro GetCompName '$0'
  ${If} $0 == "" 
  ${Else}
      DetailPrint $(CHECK_USER)
      Call CheckUserPostgres
      ${If} $9 == ""
        DetailPrint $(USER_NOT_FOUND)
      ${Else}
        DetailPrint $(DELETE_USER)
        !insertmacro DeleteUser "\\$0" "${POSTGRES_USER}"
      ${EndIf}
  
  ${Endif}
  
FunctionEnd

; Check if STDM database exists
Function CheckSTDMdb
    FileOpen $5 "check_stdm.bat" "w" 
    FileWrite $5 "SET PGPASSWORD=$password$\r$\n" 
    FileWrite $5 "SET PGPORT=$port$\r$\n" 
    FileWrite $5 '"$0\bin\psql.exe" -U $userName --list | findstr /R stdm > "${TEMPDIR}\stdm.db" $\r$\n' 
    FileClose $5

    DetailPrint $(CHECK_STDM)
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\check_stdm.bat"' 

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

    DetailPrint $(CHECK_STDM_SAMPLE_DATA)
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
      MessageBox MB_ICONEXCLAMATION|MB_OK $(ERR_STDM_DB) IDOK 
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
    
    DetailPrint $(CREATE_DB)
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\create_stdm_db.bat"' 
    Pop $6
    
    IntCmp $6 0 create_stdm_template_db_success
    ; Creation ya database imefail. Provide feedback to user

    StrCpy $7 $(CREATE_DB_FAIL)
    StrCpy $8 "${TEMPDIR}\create_stdm_db_error.txt" 
    Call AbortDisplayLogOption
    
    create_stdm_template_db_success: 
         DetailPrint $(CREATE_DB_SUCCESS)
	 return
    
FunctionEnd

Function WriteDBConnToReg
  ; HKLM - HKEY_LOCAL_MACHINE
  ; HKCU - HKEY_CURRENT_USER
  ; HKCC - HKEY_CURRENT_CONFIG
  ; HKCR - HKEY_CLASSES_ROOT
  SetRegView 64
  WriteRegStr HKCU "SOFTWARE\QGIS\QGIS2\STDM" "Host" "$host"
  WriteRegStr HKCU "SOFTWARE\QGIS\QGIS2\STDM" "Port" "$port"   ; <- this should be a DWORD
  WriteRegStr HKCU "SOFTWARE\QGIS\QGIS2\STDM" "Database" "$dbName"
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
    DetailPrint $(CHECK_POSTGRES_INST)
    Call SetPostgreSQLBaseDirectory

    ${if} $0 == "" 
    ${Else}
       ; if STDM DB already installed, warn and abort creation
       Call FindSTDMTables
       ${If} $9 == ""
       ${Else}
        MessageBox MB_ICONEXCLAMATION|MB_OK $(ERR_SAMPLE_DATA) IDOK 
        Abort
       ${EndIf}

       File "${DB_SAMPLE_DATA_DIR}\${STDM_SAMPLE_DATA}"

       ; cleans any existing data and restores from sample backup
       FileOpen $5 "${TEMPDIR}\stdm_db_backup.bat" "w" 
       FileWrite $5 "SET PGPASSWORD=$password$\r$\n" 
       FileWrite $5 "SET PGPORT=$port$\r$\n" 
       FileWrite $5 '"$0\bin\pg_restore.exe" -U $userName -h localhost -d $dbName -v --clean ${DB_SAMPLE_DATA_DIR}\${STDM_SAMPLE_DATA} 2> "${TEMPDIR}\stdm_db_backup_error.txt"$\r$\n' 
       FileWrite $5 "exit %ERRORLEVEL%$\r$\n" 
       FileClose $5

       DetailPrint $(RESTORE_SAMPLE_DATA)
       ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\stdm_db_backup.bat"' 
       Pop $6
    
       IntCmp $6 0 stdm_sample_db_success

       ; restoring failed, provide feedback.
       StrCpy $7 $(RESTORE_SAMPLE_DATA_FAIL)
       StrCpy $8 "${TEMPDIR}\stdm_db_backup_error.txt" 
    
       stdm_sample_db_success: 
          DetailPrint $(RESTORE_SAMPLE_DATA_SUCCESS)
    ${EndIf}
       ;DetailPrint "Installing raw sample data..."
       Var /GLOBAL SAMPLE_FOLDER
       StrCpy $SAMPLE_FOLDER "$PROFILE\.stdm\sample_data"
       ; check if sample data folder exists
       ${If} ${FileExists} `$SAMPLE_FOLDER\*.*`
          DetailPrint $(SAMPLE_DATA_EXIST)
       ${Else}
          CreateDirectory "$SAMPLE_FOLDER"
          SetOutPath "$SAMPLE_FOLDER"
          File /r "${RAW_SAMPLE_DATA_DIR}\*.*"
       ${EndIf}

       ; Turkana default template folder
       ; Call Install_Turkana_Extras
       
FunctionEnd

Function Install_STDM_Plugin
       Var /GLOBAL STDM_FOLDER
       StrCpy $STDM_FOLDER "$PROFILE\.qgis2\python\plugins\stdm" 
       
       ; check if sample data folder exists
       ${If} ${FileExists} `$STDM_FOLDER\*.*`
          DetailPrint $(STDM_FOLDER_EXIST)
       ${Else}
          CreateDirectory "$STDM_FOLDER"
       ${EndIf}

       DetailPrint $(CREATE_STDM_PLUGIN)

       SetOutPath "$STDM_FOLDER"
       File /r "${STDM_PLUGIN}\*.*"
FunctionEnd

#Function CopyDefaultConfigFile
#       Var /GLOBAL CONFIG_FOLDER
#       StrCpy $CONFIG_FOLDER "$PROFILE\.stdm"
#       SetOutPath "$CONFIG_FOLDER"
#       File  "${COMMON_FOLDER}\configuration.stc"
#FunctionEnd

Function Install_Turkana_Extras

       ;Var /GLOBAL TEMPLATE_FOLDER
       ;StrCpy $TEMPLATE_FOLDER "$PROFILE\.stdm\Reports\Templates"

       ; check if sample data folder exists
       ;${If} ${FileExists} `$TEMPLATE_FOLDER\*.*`
       ;   DetailPrint "Template data exists, skipped installation ..."
       ;${Else}
       ;   CreateDirectory "$TEMPLATE_FOLDER"
       ;   SetOutPath "$TEMPLATE_FOLDER"
       ;   File /r "${RAW_TEMPLATE_DIR}\*.*"
       ;${EndIf}

       ;Call InstallAdminUnitData

       ;Call InstallBackupData

       ;Call GiveRightsCSVFile

FunctionEnd


Function InstallAdminUnitData
; Turkana data
   Var /GLOBAL ADMIN_UNITS_FOLDER
   StrCpy $ADMIN_UNITS_FOLDER "$PROFILE\.stdm\Data\admin_units_data"
   ;
   ; check if sample data folder exists
   ${If} ${FileExists} `$ADMIN_UNITS_FOLDER\*.*`
      DetailPrint $(ADMIN_UNIT_EXIST)
   ${Else}
      CreateDirectory "$ADMIN_UNITS_FOLDER"
      SetOutPath "$ADMIN_UNITS_FOLDER"
      File /r "${RAW_ADMIN_UNITS_DATA}\*.*"
   ${EndIf}
FunctionEnd

Function InstallBackupData
; Turkana data
   Var /GLOBAL BACKUP_FOLDER
   StrCpy $BACKUP_FOLDER "$PROFILE\.stdm\Data\backup"
   
   ; check if sample data folder exists
   ${If} ${FileExists} `$BACKUP_FOLDER\*.*`
      DetailPrint $(BACKUP_DATA_EXIST) 
   ${Else}
      CreateDirectory "$BACKUP_FOLDER"
      SetOutPath "$BACKUP_FOLDER"
      File /r "${RAW_BACKUP_DATA}\*.*"
   ${EndIf}
FunctionEnd

Function GiveRightsCSVFile
    FileOpen $7 "${TEMPDIR}\csv_rights.bat" "w" 
    FileWrite $7 'CACLS $PROFILE\.stdm\Data\admin_units_data\admin_units.csv /e /p Everyone:f'
    FileClose $7
    ExecDos::exec '"$SYSDIR\cmd.exe" /c "${TEMPDIR}\csv_rights.bat"' 
FunctionEnd

; Installer Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN 
!insertmacro MUI_DESCRIPTION_TEXT ${SecQGIS} $(INST_QGIS)
!insertmacro MUI_DESCRIPTION_TEXT ${SecPostgreSQL} $(INST_POSTGRES) 
!insertmacro MUI_DESCRIPTION_TEXT ${SecPostGIS} $(INST_POSTGIS) 
!insertmacro MUI_DESCRIPTION_TEXT ${SecSampleData} $(INST_SAMPLE_DATA)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

