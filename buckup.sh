#!/bin/bash
#Using buckups
#Iryna 17/03/2021


if [ $# != 1 ]
then 
 echo Usage: A single argument which is the directory to backup 
 exit
fi
if [ ! -d ./$1 ]
then 
 echo 'The given directory does not seem to exist (possible typo?)'
 exit
fi
date=`date +%F`

if [ -d ./bashscriptingbuckups/$1_$date ]
then
 echo 'This project has already been backed up today, overwrite?'
 read answer
 if [ $answer != 'y' ]
 then
  exit
 fi
else
 mkdir ./bashscriptingbuckups/$1_$date
fi
cp -R $1 ./bashscriptingbuckups/$1_$date
echo Backups of $1 completed
