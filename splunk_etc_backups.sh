#! /bin/bash

#Company: OpenPath LLC
#Owner: Sahr Lebbie
#Purpose: Create Splunk Backups for 5 Days and keep only 5 latest copies.

PURPOSE="Create Splunk Backups for 5 Days and keep only 5 latest copies."

echo "   #XX XX     XXXXXXX  XXXXXXX   XXXX      XX"
echo " #XX     XX   XX   XX  XX        XX  XX    XX"
echo "#XX       XX  XX   XX  XX        XX   XX   XX"
echo "#XX       XX  XXXXXXX  XXXXXXX   XX    XX  XX"
echo "#XX       XX  XX       XX        XX     XX XX"
echo " #XX     XX   XX       XX        XX      XXXX"
echo "   #XX XX     XX       XXXXXXX   XX      XXXX"

printf "\n"
sleep 2s
printf "\n" 

echo "#XXXXXXX        XXX       XXXXXXXXXXX  XX    XX"
echo "#XX   XX       XX  XX         XX       XX    XX"
echo "#XX   XX      XX    XX        XX       XX    XX"
echo "#XXXXXXX     XX XXXX XX       XX       XXXXXXXX"
echo "#XX         XX        XX      XX       XX    XX"
echo "#XX        XX          XX     XX       XX    XX"
echo "#XX       XX            XX    XX       XX    XX"
sleep 2s
clear
echo "Welcome to Openpath LLC Script to: $PURPOSE"
echo "Let's Get Started"

SCRIPT="" #Name of this Script with Location.
SCRIPT_LOG="" #Name of this Script with Location.
SPLUNK_DATA_COPY_LOCATION="" #Splunk ETC location.
SPLUNK_BACKUP_LOCATION=""    #Backup Copy Location.
SPLUNK_NAMING_CONVENTION="splunk_backup_" #Name to save the backups as.
COPIES_TO_KEEP=5            #Number of copies to keep.
CURRENT_COPIES="$(ls $SPLUNK_BACKUP_LOCATION |wc -l|awk '{print $NF}')" #Number of current backups we have
OLDEST_COPY="$(ls -ltr $SPLUNK_BACKUP_LOCATION |head -n 2 |awk '{print $NF}' |grep $SPLUNK_NAMING_CONVENTION)" #Oldest copy


cd $SPLUNK_BACKUP_LOCATION
if [[ "$CURRENT_COPIES" < "$COPIES_TO_KEEP" ]]
then
	tar -czvf $SPLUNK_NAMING_CONVENTION`date +%s`.tgz $SPLUNK_DATA_COPY_LOCATION  
	echo "There are currently $CURRENT_COPIES backup copies. Creating a new backup." >> $SCRIPT_LOG
else
	tar -czvf $SPLUNK_NAMING_CONVENTION`date +%s`.tgz $SPLUNK_DATA_COPY_LOCATION 
	echo "There are currently $CURRENT_COPIES backup copies. Creating a new backup and deleting $OLDEST_COPY." >> $SCRIPT_LOG
	rm -f $SPLUNK_BACKUP_LOCATION/$OLDEST_COPY
fi
