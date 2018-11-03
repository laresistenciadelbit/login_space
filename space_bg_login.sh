#!/bin/bash

resolution=1366x768

bg=/usr/share/lubuntu/wallpapers/lubuntu-default-wallpaper.png

wget http://apod.nasa.gov/apod/astropix.html -O /tmp/1.a
link=`cat /tmp/1.a | grep "jpg" | head -n1 | cut -f2 -d'"'`
wget http://apod.nasa.gov/$link -O /tmp/lubuntu-default-wallpaper.png
rm /tmp/1.a

mogrify=`locate mogrify | head -n 1`
if [ -f $mogrify ];
then
	mogrify -resize $resolution /tmp/lubuntu-default-wallpaper.png
	imgsize=`du -b /tmp/lubuntu-default-wallpaper.png | cut -f1`

	if [ $imgsize -gt 1256000 ]; then
	mogrify -quality 75 /tmp/lubuntu-default-wallpaper.png
	fi

	if [ $imgsize -gt 1456000 ]; then
	mogrify -quality 55 /tmp/lubuntu-default-wallpaper.png
	fi
fi

sudo mv -f /tmp/lubuntu-default-wallpaper.png $bg