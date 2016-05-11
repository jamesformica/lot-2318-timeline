#!/bin/bash

declare -a IGNOREFILES=(".gitignore" "dist.sh" "npm-debug.log" "package.json")
declare -a IGNOREFOLDERS=(".git" ".idea" ".sass-cache" "app/assets/typescript" "dist" "node_modules")

containsElement() {
	local e

	for e in "${@:2}"
	do
		if [ "$e" == "$1" ]
			then
			return 0
		fi
	done

	return 1
}

for f in $PWD/*
do
	if [ -d "$f" ]
		then
		FOLDERNAME="${f##*/}"

		containsElement $FOLDERNAME ${IGNOREFOLDERS[@]}

		if [ $? == 1 ]
			then
			echo "didnt find so gonna copy it"

			cp -r "$PWD/$FOLDERNAME" "$PWD/dist/$FOLDERNAME"
		fi


	fi
done



# for i in "${IGNOREFILES[@]}"
# do
# 	echo "$i"
# done

# for i in "${IGNOREFOLDERS[@]}"
# do
# 	echo "$i"
# done
