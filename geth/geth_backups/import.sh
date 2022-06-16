#!/bin/bash
# Author: liujinye
BASE_DIR=$(cd `dirname $0` && pwd)
cd $BASE_DIR

set -e

if [ -f "import.log" ];then
	latest=`ls -tr *.gz|tail -1`
	grep "$latest" import.log && echo "The import is complete." && exit 0
fi

for item in `ls -tr *.gz`
do
	grep "$item" import.log && echo "The $item is imported." && continue
	name=`tar xzvf $item`
	geth import $name
	rm -f $name
	echo "$item is done." >> import.log
done
