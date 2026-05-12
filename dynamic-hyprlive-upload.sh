#!/bin/bash
#=== Dynamic-Hyprlive === 
# FYKsKyle	05.12.2026
# Dynamically sets mpvpaper and openrgb to match listed programs using default when nothing is running
# Add all programs to one file using this format each item seperated by a TAB
# ie. Game.exe	wallpaper.mp4	openrgb-profile
# Iteration limit controls the mpv memory leak
#========================
#--- set up --- 
program_file="$HOME/.config/dynamic-hyprlive/program_list.conf"
	#---	
WALLPAPERdir=""
DEFAULT_WALLPAPER=""
DEFAULT_RGB=""
DURATION="10s"
ITERATION_LIMIT=30 
#-------------
declare -A program_list=()
while read line; do
	#echo "${p%$'\t'*}"
	temp="${line#*$'\t'}"
	temp="${temp#*$'\t'}"
	arrayRGB=$temp
	#---
	temp="${line%$'\t'*}"
	temp="${temp%$'\t'*}"
	arrayGAME=$temp
	#---
	temp="${line#*$'\t'}"
	temp="${temp%$'\t'*}"
	arrayWALLPAPER=$temp
	#--- 
	program_list[$arrayGAME]="$arrayWALLPAPER	$arrayRGB"
done <$program_file
#---- 
current_wallpaper="" 
while true; do 
	wallpaper="$DEFAULT_WALLPAPER"
	rgb="$DEFAULT_RGB"
	#---
	for program in "${!program_list[@]}"; do
		process_quantity=$(ps aux | grep "$program" | wc -l)
		if [[ $process_quantity != 1 ]]; then 
			wallpaper=""${program_list[$program]%$'\t'*}""
			rgb=""${program_list[$program]#*$'\t'}""
			echo $wallpaper
			echo $rgb
			break
		fi
	done
	#---
	if [[ $current_wallpaper != $wallpaper ]]; then
		pkill mpvpaper 
		mpvpaper -o 'loop no-audio panscan=1' '*' "$WALLPAPERdir/$wallpaper" &
		openrgb -p $rgb &
		current_wallpaper=$wallpaper
		iteration_count=0 
	elif [[ $current_wallpaper == $wallpaper ]]; then
		((iteration_count+=1)) 
		if (( $iteration_count == $ITERATION_LIMIT )); then
			pkill mpvpaper
			mpvpaper -o 'loop no-audio panscan=1' '*' "$WALLPAPERdir/$wallpaper" &
			iteration_count=0
		fi
	fi 
	sleep $DURATION
done 


















