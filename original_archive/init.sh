#!/bin/sh

case $# in
2) ;;
*) echo "usage: $0 [bin|nmea] /dev/cua??" 1>&2; exit 1;;
esac
speed=4800
dev=$2

case $1 in
bin)
	perl -e '
	$| = 1;
	printf("\$PRWIIPRO,,RBIN\r\n");
	sleep 4;
	printf("\xff\x81\xe8\x03\x00\x00\x00\x80\x19\xfa"); # 1000
	printf("\xff\x81\xea\x03\x00\x00\x00\x80\x17\xfa"); # 1002
	printf("\xff\x81\xeb\x03\x00\x00\x00\x80\x16\xfa"); # 1003
	printf("\xff\x81\x6f\x04\x00\x00\x00\x80\x92\xf9"); # 1135
	sleep 1;
	' | jerm -b ${speed} ${dev}
	;;
nmea)
	perl -e '
	$| = 1;
	printf("\xff\x81\x33\x05\x03\x00\x00\x00\xcb\x78\x00\x00\x00\x00\x01\x00\xff\xff");
	sleep 4;
	#printf("\$PRWIILOG,GGA,V,,,\r\n");
	#printf("\$PRWIILOG,GSA,V,,,\r\n");
	#printf("\$PRWIILOG,GSV,V,,,\r\n");
	printf("\$PRWIILOG,ZCH,V,,,\r\n");
	sleep 1;
	' | jerm -b ${speed} ${dev}
	;;
esac
