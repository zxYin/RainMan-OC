#!/bin/sh
# Author: Yunpeng Li

case $1 in
	"install")
    	cp -R git/* ../.git/hooks
    	;;
	"remove")
    	rm -f ../.git/hooks/commit-msg
    	;;
	*)
    	echo "usage: ./hooks  <install|remove>"
    	;;
esac