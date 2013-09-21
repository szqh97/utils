#!/bin/bash
## use curl and wget to down pictures from website
## for example www.tu11.com
## if you want use it,modify by yourself
##
prefix='http://www.tu11.com/BEAUTYLEGtuimo/'
tmpprefix=${prefix%/*}${i}
## wget should delete the last sep in the prefix
#htmls=`wget -O- ${prefix} |grep -o '/BEAUTYLEGtuimo/2013/[0-9][0-9][0-9][0-9].html'`
htmls=`curl ${prefix} | grep -o '/BEAUTYLEGtuimo/[0-9][0-9][0-9][0-9]/[0-9][0-9][0-9][0-9].html'`
#echo $htmls |sed -s '/ /\n/g'|while read a ; do echo ${a}------; done
for i in ${htmls}
do 
    url=${tmpprefix%/*}${i}
    echo $url
    #pics=`wget -O- ${url}|grep -o 'http://img9.tu11.com:8080/picture.*jpg'`
    pics=`curl ${url}|grep -o 'http://im.*.tu11.com:8080/picture.*jpg'`
    echo $pics
    for pic in ${pics}
    do
        #
        # http://img9.tu11.com:8080/picture/130811/pic9/4.jpg 
        # l1="4.jpg", l2="pic9", l3="130811"
        #
        l1=${pic##*/}
        t1=${pic%/*}
        l2=${t1##*/}
        t2=${t1%/*}
        l3=${t2##*/}
        picname=${l3}_${l2}_${l1}
        echo $picname
        echo $pic
        wget -O ${picname} ${pic}
    done
done


