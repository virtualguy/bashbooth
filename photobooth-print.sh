#!/bin/bash
#variables
set  -e

tmp=/var/www/photobooth/photos/tmp
backup_dir=/var/www/photobooth/photos/backup
final=/var/www/photobooth/photos/final
upload_dir=/home/jnwark/Dropbox/Public/photobooth
display_file=/var/www/photobooth/photos/final/current.png
overlay=/home/jnwark/Dropbox/Public/photobooth/overlay.png
#nashville, toaster, gotham, lomo, kelvin
#filter=gotham
countdown=false
print=false
upload=true
#layouts
# 2x2 = +2+2
# 4x1 = +4+1
layout="1x"

if [ "$1" = "single" ]
then
	frame=false
else 
	frame=true
fi

red='\e[0;31m'
NC='\e[0m' # No Color

function echo_info
{
	echo -e  ${red}$1${NC}
}

function backup_images
{
for f in $tmp/*
do
   cp_increment $f $backup_dir
done
}

function print_images
{
lp $tmp/
for f in $tmp/*
do
   lp $f
done 
}

function cp_increment
{
#source=dirA/file.ext
#dest_dir=dirB
source_file=$1
dest_dir=$2

file=$(basename capt0000.jpg)
basename=${file%.*}
ext=${file##*.}

if [[ ! -e "$dest_dir/$basename.$ext" ]]; then
    # file does not exist in the destination directory
    cp "$source_file" "$dest_dir"
else
    num=2
    while [[ -e "$dest_dir/$basename$num.$ext" ]]; do
        (( num++ ))
    done
    cp "$source_file" "$dest_dir/$basename$num.$ext" 
fi 
}


function cp_upload
{
#source=dirA/file.ext
#dest_dir=dirB
source_file=$1
dest_dir=$2
echo "1 = $1"
echo "2 = $2"

file=$(basename upload.png)
basename=${file%.*}
ext=${file##*.}
#echo "$dest_dir/$basename.$ext"

num=2
while [[ -e "$dest_dir/$basename$num.$ext" ]]; do
#   echo "num = $num"
   (( num++ ))
done
cp "$source_file" "$dest_dir/$basename$num.$ext"
}

echo_info "Start"
echo_info $1

#delete tmp files
echo_info "delete tmp files"
mkdir -p $tmp
cd $tmp
rm -f *.jpg *.png

#check camera


#capture 4 photos
if [ $frame = true ]
then 
	echo_info "capture 4 photos"
	cd $tmp
#	sleep 5
	gphoto2 --capture-image-and-download --frames 4 --interval 2
fi
 
#capture single photo
if [ $frame = false ]
then
echo_info "capture single photo"
cd $tmp
#sleep 5
gphoto2 --capture-image-and-download
fi

# print to label printer
print_images

#back up raw images
echo_info "back up raw images"
backup_images


#combine
if [ $frame = true ]
then
	echo_info "combine"
	cd $tmp
	last=$(ls -t *.jpg | head -1)
	mogrify -resize 600x400 -bordercolor black -border 2 *.jpg
	montage -tile ${layout} -geometry 600x400\>+2+2 *.jpg $last
	#montage -geometry 300x200\>${layout} *.jpg $last
	if [ $overlay ]
	then
		composite -gravity center -geometry +0+100 $last $overlay ${last}.png
	fi
fi
 
if [ $frame = false ]
then
echo_info "resize"
cd $tmp
last=$(ls -t *.jpg | head -1)
convert $last -resize 600x400 $last
fi
 
#copy final file to final folder
echo_info "copy final file to final folder"
cd $tmp
last=$(ls -t *.png | head -1)
cp $last $final
 
#filter photo
echo_info "filter photo"

if [ "$filter" = "nashville" ]
then cd $final
convert $last -contrast -modulate 100,150,100 -auto-gamma $last
fi
 
if [ "$filter" = "toaster" ]
then cd $final
convert $last -modulate 150,80,100 -gamma 1.2 -contrast -contrast $last
fi
 
if [ "$filter" = "gotham" ]
then cd $final
convert $last -modulate 120,10,100 -fill '#222b6d' -colorize 10 -contrast -contrast $last
fi
 
if [ "$filter" = "lomo" ]
then cd $final
convert $last -channel R -level 33% -channel G -level 33% $last
fi
 
if [ "$filter" = "kelvin" ]
then cd $final
convert $last -auto-gamma -modulate 120,50,100 -fill 'rgba(255,153,0,0.5)' -draw 'rectangle 0,0 2304,1536' -compose multiply $last
fi
 
#print
echo_info "print"
 
#upload
if [ $upload = true ]
then
echo_info "uploading to dropbox"
#cp $last $upload_dir
cp_upload $last $upload_dir
fi

#store for local display
echo_info "copy for display"
cp $last $display_file
 
#delete tmp files
echo_info "delete tmp files"
cd $tmp
rm -f *.jpg *.png
