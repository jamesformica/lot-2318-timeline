#!/bin/bash

clear
declare -a INCLUDEFOLDERS=("app" "config" "db" "helpers" "models" "public" "vendor" "views")
declare -a INCLUDEFILES=("application.rb" "config.ru" "Gemfile" "Gemfile.lock" "Rakefile")

echo "\n*** Selecting the chosen files for distribution ***"

if [ -d "$PWD/dist" ]
	then
	echo "- Emptying and creating dist directory"
	rm -rf "$PWD/dist"
	mkdir "$PWD/dist"
else
	echo "- Creating dist directory"
	mkdir "$PWD/dist"
fi

echo "\n*** Included Folders ***"
for f in ${INCLUDEFOLDERS[@]}
do
	FOLDER=$f

	if [ -d "$FOLDER" ]
		then
		echo "- $FOLDER"
		cp -r "$PWD/$FOLDER" "$PWD/dist/$FOLDER"
	fi
done

echo "\n*** Included Files ***"
for file in ${INCLUDEFILES[@]}
do
	FILE=$file

	if [ -f $FILE ]
		then
		echo "- $FILE"
		cp "$PWD/$FILE" "$PWD/dist/$FILE"
	fi
done

echo "\n*** Distribution size ***"
du -hcs $PWD/dist

echo "\nDone.\n"