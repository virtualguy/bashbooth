#!/bin/bash
#variables
set  -e
base_dir=/store/shares/media/Photos/Photobooth/tmp
tmp=${base_dir}/tmp
backup_dir=${base_dir}/backup
final=${base_dir}/final
#upload_dir=/home/jnwark/Dropbox/Public/photobooth
upload_dir=${base_dir}/uploads
display_file=${final}/current.png
overlay=/store/dropbox/jnwark/Dropbox/Public/photobooth/overlay.png
#nashville, toaster, gotham, lomo, kelvin
#filter=gotham
run_countdown=false
run_capture=false
run_print=false
run_upload=true
run_backup=false
run_restore_from_backup=true
#layouts
# 2x2 = +2+2
# 4x1 = +4+1
layout="1x"


mkdir $final -p
mkdir $tmp -p
mkdir $backup_dir -p
mkdir $upload_dir -p

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

function process_image
{
echo_info "Start"
echo_info $1

if [ $run_restore_from_backup = false ]
then
   #delete tmp files
   echo_info "delete tmp files"
   mkdir -p $tmp
   cd $tmp
   rm -f *.jpg *.png
fi

#check camera


#capture 4 photos
if [ $run_capture = true ]
then
   if [ $frame = true ]
   then 
	echo_info "capture 4 photos"
	cd $tmp
	sleep 5
	gphoto2 --capture-image-and-download --frames 4 --interval 2
   fi
 
   #capture single photo
   if [ $frame = false ]
   then
      echo_info "capture single photo"
      cd $tmp
      sleep 5
      gphoto2 --capture-image-and-download
   fi
fi

#back up raw images
if [ $run_backup = true ]
then
   echo_info "back up raw images"
   backup_images
fi


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
if [ $run_upload = true ]
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

}

echo_info "Start Main loop"

if [ $run_restore_from_backup = true ]
then
   i=0
   j=0
   echo_info "Restore from backup"
   backup_images=false
   for f in ${backup_dir}/*
#   for f in (ls ${backup_dir}/* | sort -n)
   do
      echo_info "File:$i = $f "
      cp $f $tmp
      if [ "$i" = "3" ]
      then
         i=0
         j=$((j+1))
         echo_info "Process strip #$j"
         process_image
      else
          i=$((i+1))
      fi
   done
else
   #execute photobooth
   process_image
fi

