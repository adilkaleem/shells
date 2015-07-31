#!/bin/bash
#Small script to monitor disk usage in server. Written specific to monitor in my node.

LIMIT='80'
DIR='/home'
ROOTX='/'
MAILTO='mail@mailprovider.com'
SUBJECT="$DIR disk usage in slave 2"
MAILX='mailx'

which $MAILX > /dev/null 2>&1

if ! [ $? -eq 0 ]
then
          echo "Please install $MAILX"
          exit 1
fi

cd $DIR

USED=`sudo df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5}' | cut -d"%" -f1`
USED_DIR=`sudo df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $1,$5}'`
ROOT=`sudo df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $1,$5}'|sed -ne 1p|cut -d' ' -f2|cut -d'%' -f1`
ROOT_DIR=`sudo df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $1,$5}'|sed -ne 1p`
echo $USED_DIR

#If used space is bigger than LIMIT
for i in $USED
do
if [[ $i -gt $LIMIT ]]
then
        du -sh ${DIR}/* | $MAILX -s "$SUBJECT" "$MAILTO"
fi
done

if [[ $ROOT -gt $LIMIT ]]
then
        echo $ROOT_DIR | $MAILX -s "ROOT Dir Stats in Slave 2" "$MAILTO"
fi
