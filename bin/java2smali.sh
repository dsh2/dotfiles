#!/bin/bash

if [ -z "${1}" ]; then
	echo "usage: java2smali <java file>"
	return
fi

filename=$(basename $1 .java)
outDir=$(shasum $1 | awk '{print $1}')
# Generate debug info in case we keep the dex
javac -g -cp $ANDROID_PLATFORM/android.jar $1
dx --dex --no-strict --no-optimize --output=$filename.dex $filename.class
baksmali --sequential-labels --use-locals $filename.dex -o $outDir
#cp -R $outDir/**/*.smali .
#rm -r $outDir
#rm $filename.class
#rm $filename.dex
