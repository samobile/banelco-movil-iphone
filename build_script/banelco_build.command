#!/bin/sh

# banelco_build.sh

#---- PARAMETROS CONFIGURABLES ---------------------------------------
#PROJDIR=$PWD
PROJDIR="/Users/sebastianalonso/mobile/Banelco/BanelcoMovil_personalizado"
TARGET_NAME=(BanelcoMovilIphone HSBCMovil StandardBank)
#VERSION="2.1.9"
VERSION=("2.1.9" "0.1.0" "0.1.0")
ENVIRONMENT=("TEST" "PROD" "PROD")
#ENVIRONMENT="TEST"
#Debug, Release, Distribution o el que se quiera usar
CONFIGURATION="Debug"
TARGET_SDK="iphoneos4.2"
#PROVISIONING PROFILE
DEVELOPER_NAME="iPhone Developer: Sebastian Alonso (YL37MJTCVY)"
PROVISIONING_PROFILE="${PROJDIR}/build_script/Banelcomovil_cer_personalizado.mobileprovision"
#---------------------------------------------------------------------

PROJECT_BUILDDIR="${PROJDIR}/build/${CONFIGURATION}-iphoneos"

BUILD_HISTORY_DIR="${PROJDIR}/releases"

TFILE="/out.tmp"

#---------------------------------------------------------------------

#---------------------------------------------------------------------
#Si no existe, crea directorio releases
if [ -d "${BUILD_HISTORY_DIR}" ]; then
	echo "Releases"
else
	mkdir "${BUILD_HISTORY_DIR}"
fi
#---------------------------------------------------------------------

#loop principal
loop=0
for i in ${TARGET_NAME[@]}
do
	#---------------------------------------------------------------------
	#modify plist with version and environment
	cp -f "${PROJDIR}/${i}-Info.plist" "${PROJDIR}/temp_${i}-Info.plist"
	LINEVERSION=0
	LINEENV=0
	while read line
	do
		if	[ $LINEVERSION == 0 ] && [ $LINEENV == 0 ]; then
			echo "$line" >> "version_${i}-Info.plist"
		else
			if	[ $LINEVERSION == 1 ]; then
				echo "<string>${VERSION[$loop]}</string>" >> "version_${i}-Info.plist"
				LINEVERSION=0
			else
				echo "<string>${ENVIRONMENT[$loop]}</string>" >> "version_${i}-Info.plist"
				LINEENV=0
			fi
		fi

		if [ "$line" == "<key>CFBundleVersion</key>" ]; then
			LINEVERSION=1
		else
			LINEVERSION=0
		fi
	
		if [ "$line" == "<key>Environment</key>" ]; then
			LINEENV=1
		else
			LINEENV=0
		fi
	done < "${PROJDIR}/${i}-Info.plist"
	cp -f "version_${i}-Info.plist" "${PROJDIR}/${i}-Info.plist"
	#---------------------------------------------------------------------
	
	#---------------------------------------------------------------------
	#compile project
	echo Building Project
	cd "${PROJDIR}"
	xcodebuild -target "${i}" -sdk "${TARGET_SDK}" -configuration ${CONFIGURATION}
	#---------------------------------------------------------------------
   
	#---------------------------------------------------------------------
	#remove temp files
	cp -f "${PROJDIR}/temp_${i}-Info.plist" "${PROJDIR}/${i}-Info.plist"
	rm -f "${PROJDIR}/temp_${i}-Info.plist"
	rm -f "${PROJDIR}/build_script/version_${i}-Info.plist"
	#---------------------------------------------------------------------
   
	#---------------------------------------------------------------------
	#Check if build succeeded
	if [ $? != 0 ]
		then
		exit 1
	fi
	#---------------------------------------------------------------------
	
	#---------------------------------------------------------------------
	#create .ipa
	IPANAME="${i}_v${VERSION[$loop]}_${ENVIRONMENT[$loop]}_"`eval date +%Y%m%d%H%M%S`".ipa"
	/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${PROJECT_BUILDDIR}/${i}.app" -o "${BUILD_HISTORY_DIR}/${IPANAME}" --sign "${DEVELOPER_NAME}" --embed "${PROVISIONING_PROFILE}"
	#---------------------------------------------------------------------
	
	loop=${loop}+1
done
 
