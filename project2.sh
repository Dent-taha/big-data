#!/bin/bash

backup_file="backup.log"
backup_dir="/home/user/backup"
time=$(date +"%d-%m-%Y-%H%M")
target="$2"



if [ ! -d "$backup_dir" ];
then
	mkdir -p "$backup_dir"
fi



archiving()
{
	if [[ -z "$target" ]] ;
	then
		read -p "type a file or folder you want to archize"  target
	fi
	if [[ -d "$target" || -f "$target" ]] ;
	then
		archive_name=$(basename "$target")-$time.tar.gz

	tar -czvf  "$archive_name"  "$target"
	mv "$archive_name " "$backup_dir"
	echo " archiving of $target has done in time  $time" >> "$backup_file"
	echo " backup created: $backup_dir/$archive_name"
else
	echo "folder or file doesn't exist"
	exit 1
	fi

}
restoring()
{
	ls "$backup_di"
	read -p "type the file you want to restor: " file
	full_path="$backup_dir/$file"
	if [[ -f "$full_path" ]];
	then
		tar xzf "$full_path"
		echo "restored: $file"
	else
		echo : file not fount
	fi
}

listing()
{
	echo "files  in  $backup_dir"
	ls "$backup_die"
}


case $1 in 
	--backup )  archiving
		;;

	--restore ) restoring
		;;
	--list ) listing
		;;
	* ) echo " Usage : [ --restoring | --listing |--backup] "
esac


