#!/bin/bash

resolution=1366x768

wget http://apod.nasa.gov/apod/astropix.html -O /tmp/1.a
link=`cat /tmp/1.a | grep "jpg" | head -n1 | cut -f2 -d'"'`
wget http://apod.nasa.gov/$link -O /tmp/grub_bg.png
rm /tmp/1.a

mogrify=`locate mogrify | head -n 1`
if [ -f $mogrify ];
then
	mogrify -resize $resolution /tmp/grub_bg.png
	imgsize=`du -b /tmp/grub_bg.png | cut -f1`

	if [ $imgsize -gt 1256000 ]; then
	mogrify -quality 75 /tmp/grub_bg.png
	fi

	if [ $imgsize -gt 1456000 ]; then
	mogrify -quality 55 /tmp/grub_bg.png
	fi
fi

sudo mv -f /tmp/grub_bg.png /boot/grub
sudo update-grub