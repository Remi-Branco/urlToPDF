#! /bin/bash

#[file path][file extension][pages to remove from start]
#
#downloads urls from file and prints to pdf
#If there are extra pages to remove from start pass it as $3 first page index
#Make sure to enter parameters in correct order.
#

#test if variables have been passed to function
[ -z $2 ] &&  FILE_EXTENSION=".htm" || FILE_EXTENSION=$2 #if no file extension has been passed then assign .htm to it otherwise use $2
[ -z $3 ] && FIRST_PAGE=1 || FIRST_PAGE=$3 #same but with first page index


echo ""

LINE_NUMBER=1 #initiates line number

while read LINE
do
	#download html file to postscript and convert to PDF
	FILE_NAME="${LINE_NUMBER}-$(basename $LINE $FILE_EXTENSION)"

	echo "Processing: $FILE_NAME : url: $LINE"
	FINAL_NAME="${FILE_NAME}.pdf"
	TEMP_NAME="${FILE_NAME}-temp1.pdf"
	#if file already exists, no redownload
	if [ -f "$FINAL_NAME" ] 
	then
	echo "${FINAL_NAME} already exists" 
	else
		html2ps $LINE | ps2pdf - $TEMP_NAME
		#next check that last command executed with no error then remove first n pages
		echo "$? $3 $FINAL_NAME $FIRST_PAGE "
		[ $? -eq 0 ] && echo "Removing pages from 1 to ${FIRST_PAGE}" && pdftk $TEMP_NAME cat ${FIRST_PAGE}-end output $FINAL_NAME && rm $TEMP_NAME 

		[ $? -eq 0 ] && echo "$FINAL_NAME processed" 
	fi
	echo ""; echo ""
	
	((LINE_NUMBER++))
	
done < $1


