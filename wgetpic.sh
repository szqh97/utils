#!/bin/bash
## use curl and wget to down pictures from website
## for example www.tu11.com
## if you want use it,modify by yourself
##
prefix='http://www.tu11.com/BEAUTYLEGtuimo/'
tmpprefix=${prefix%/*}${i}
## wget should delete the last sep in the prefix
#htmls=`wget -O- ${prefix} |grep -o '/BEAUTYLEGtuimo/2013/[0-9][0-9][0-9][0-9].html'`
#htmls=`curl ${prefix} | grep -o '/BEAUTYLEGtuimo/[0-9][0-9][0-9][0-9]/[0-9][0-9][0-9][0-9].html'`
htmls=`curl ${prefix} | grep -o '/BEAUTYLEGtuimo/.*html'`
for i in ${htmls}
do 
    # deal the first page 
    url=${tmpprefix%/*}${i}

    # get other pages
    sufix=`curl ${url} | grep dede_pages|sed 's#</a></li><li>#\n#g'|grep .*html|grep -v "</a></li>"|sed -e "s/^<a href='//g" -e "s/'>.//g"`
    echo ${sufix}

    #pics=`wget -O- ${url}|grep -o 'http://img9.tu11.com:8080/picture.*jpg'`
    pics=`curl ${url}|grep -o 'http://im.*.tu11.com:8080/picture.*jpg'`
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
        (
        if [ ! -f $picname ];
        then
            wget -t 3 -T 100 -O ${picname} ${pic}
        else
            echo ${picname} has exist
        fi
        )&
    done

    # download other image from other html
    for htmlsufix in ${sufix}
    do
        otherurl=${url%/*}"/"${htmlsufix}
        otherpics=`curl ${otherurl}|grep -o 'http://im.*.tu11.com:8080/picture.*jpg'`
        for pic in ${otherpics}
        do
            #
            # http://img9.tu11.com:8080/picture/130811/pic9/4.jpg 
            # l1="4.jpg", l2="pic9", l3="130811"
            #
            ol1=${pic##*/}
            ot1=${pic%/*}
            ol2=${ot1##*/}
            ot2=${ot1%/*}
            ol3=${ot2##*/}
            picname=${ol3}_${ol2}_${ol1}
            (
            if [ ! -f $picname ];
            then
                wget -t 3 -T 100 -O ${picname} ${pic}
            else
                echo ${picname} has exist
            fi
            )&
        done

    done

done


