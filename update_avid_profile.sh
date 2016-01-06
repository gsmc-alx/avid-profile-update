#!/bin/bash

scriptLoc="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
templateArchiveName="Gold-21iMac.zip"
templateDirName=${templateArchiveName/.zip}
remotefileURL="http://158.223.89.4/system_setup/$templateArchiveName"
zipDownload="${scriptLoc}/download/"
zipLocal="${scriptLoc}/template"
profilePath="/Users/adrin009"

# Attempt download of archive from server to temporary location
echo "Attempting to download AVID template from $remotefileURL"
curl -f -# "$remotefileURL" > "$zipDownload/$templateArchiveName"

# Check archive downloaded
if [ -f "$zipDownload/$templateArchiveName" ] && [ -s "$zipDownload/$templateArchiveName" ]
then
	# Remove old local archive
	rm -f "$zipLocal/$templateArchiveName"
	# Move to permanent storage location
	mv -vf "$zipDownload/$templateArchiveName" "$zipLocal/$templateArchiveName"
else
	echo "Unable to download remote archive. Will continue copying locally-saved archive"
fi

# Check archive exists at permanent storage location
if [ -e "$zipLocal/$templateArchiveName" ] && [ -s "$zipLocal/$templateArchiveName" ]
then
	# Remove existing AVID template dir
	rm -fr "$profilePath/$templateDirName"
	# Unzip archive to AVID profile location (over-writes)
	unzip -o -d "$profilePath" "$zipLocal/$templateArchiveName"
	# Remove annoying extraneous directory
	rm -rf "$profilePath/__MACOSX";
	# Make AVID profile dir world-writable
	chmod -R 777 "$profilePath/$templateDirName"
else
	echo "Local template archive not found. Exiting"
	exit 1
fi

exit 0
