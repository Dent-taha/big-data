#!/bin/bash


#variable

cpu=$(top -bn1 | grep "Cpu(s)" | awk '{ printf $2 + $4 }' )
ram=$(free | grep "Mem" | awk '{printf $2 / $3 *100 }' |sed 's/%//')
hard=$(df -h / | tail -n 1 | awk '{printf $5 }' |sed 's/%//')
threshold=20
log_file="file.log"
services=("mysql" "nginx" )



#functions
CPU()
{
	if (($(echo "$cpu" > "$threshold" | bc -l ) ));
	then
		echo "high CPU USage" 
	else
		echo "CPU is safe"
	fi
}


RAM()
{
	if (($(echo "$ram" > "$threshold" | bc -l )));
	then
		echo " High RAM Usage"
	else
		echo "RAA is good"
	fi
}
HARD()
{
	if (($(echo "$hard" > "$threshold" |bc -l )));
	then
		echo "Your hard is almost full"
	else
		echo " your hard is so empty"
	fi
}

loging()
{
	echo " cpu = $cpu"
	CPU
	echo " ram = $ram" 
	RAM
	echo " hard = $hard"
	HARD
	service_state
	echo " $(date )"
	echo "=============================================================================="
}




service_state()
{
	for service in "${services[@]}";
	do
		sudo systemctl is-active --quiet "$service"
		if [[ "$?" -eq 0 ]] ;
		then
			echo "$service is active"
		else
			echo "$service not active"
		fi
	done
}
loging >> $log_file


if [[ "$1" = "--report" ]];
then
	cat "$log_file"
fi

if [[ "$1" = "--cpu" ]];
then
	echo " cpu =$cpu"
	CPU
fi
if [[ "$1" = "--ram" ]];
then
	echo "ram =$ram"
	RAM
fi

if [[ "$1" = "--hard" ]];
then
	echo " hard = $hard"
	HARD
fi

