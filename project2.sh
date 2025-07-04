#!/bin/bash

backup_file="backup.log"
backup_dir="/home/user/backup"
time=$(date +"%d-%m-%Y-%H%M")
target="$1"



if [ ! -d "$backup_dir" ];
then
	mkdir -p "$backup_dir"
fi



archiving()
{
	tar -czvf  "$target".tar.gz."$time" "$target"
	mv "$target".tar.gz."$time" "$backup_dir"
	echo " archiving of $target has done in $time" >> "$backup_file"
}
restoring()
{
	for restored_file in "$backup_dir"/* ;
	do
		if [[ "$2" -eq "$restored_file" ]];
		then
			tar -xzf "$2"
		fi
	done
}

listing()
{
	for files in "$backup_dir"/* ;
	do
		echo "$files"
	done
}


case $1 in 
	--backup ) shift ; archiving
		;;

	--restore ) restoring
		;;
	--list ) listing
		;;
	* ) echo " Usage : [ --restoring | --listing ] "
esac

if [[ $# != 1 ]] ;
then
	read -p "type a folder you want to archive it : " file
	if [[ -f "$file" ]] ;
	then
		target="$file"
		archiving
	else
		echo "file not exist"
		exit 1
	fi
fi

