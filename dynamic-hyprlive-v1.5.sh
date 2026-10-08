#!/bin/bash
#=== Dynamic-Hyprlive ===
# Version 1.5 - allow compatibility for not using openrgb by using the string "n/a"
# FYKsKyle	10.8.2026
# Dynamically sets mpvpaper and openrgb to match listed programs using default when nothing is running
# Add all programs to one file using this format each item seperated by a TAB and a space seperating multiple wallpapers
# ie. Game.exe		openrgb-profile		wallpaper1 wallpaper2 wallpaper3 ...	
# Iteration limit controls the mpv memory leak
#========================
#--- set up --- 
program_file="$HOME/.config/dynamic-hyprlive/program_list.conf"
	#---	
WALLPAPERdir="$HOME/wallpapers/LIVEWALLPAPERS/"
DURATION="10s"
ITERATION_LIMIT=30
#-------------
declare -A program_list=()
while read line; do
	if [[ ${line:0:1} == "#" ]]; then
		continue
	elif [ -z "$line" ]; then
		continue
	fi
	temp="${line#*$'\t'}"
	temp="${temp#*$'\t'}"
	arrayWALLPAPER=$temp
	if [[ $arrayWALLPAPER == *".dir"* ]]; then
		directory="${arrayWALLPAPER/".dir"/}"
		files=( $WALLPAPERdir$directory/* )
		arrayWALLPAPER=${files[@]/$WALLPAPERdir/}
	fi
	#---
	temp="${line%$'\t'*}"
	temp="${temp%$'\t'*}"
	arrayGAME=$temp
	#---
	temp="${line#*$'\t'}"
	temp="${temp%$'\t'*}"
	arrayRGB=$temp
	#---
	if [[ $arrayGAME == "DEFAULT" ]]; then
		DEFAULT_WALLPAPER="$arrayWALLPAPER"
		DEFAULT_RGB="$arrayRGB"
		continue
	fi
	#---
	program_list[$arrayGAME]="$arrayRGB	$arrayWALLPAPER"
done <$program_file
#---- 
current_wallpaper=""
randomized=false
active_programs=false
while true; do 
	if [[ $active_programs == false ]]; then
		rgb="$DEFAULT_RGB"
		#--- RANDOM DEFAULT --- 
		read -a DEFAULT_WALLPAPER_LIST <<< $DEFAULT_WALLPAPER
		if  [[ ${#DEFAULT_WALLPAPER_LIST[@]} > 1 && $randomized == false ]]; then
			random_wallpaper=${DEFAULT_WALLPAPER_LIST[ $(( RANDOM % ${#DEFAULT_WALLPAPER_LIST[@]} )) ]}
			wallpaper=$random_wallpaper
			randomized=true
		#--- 
		else
			wallpaper="${DEFAULT_WALLPAPER_LIST[0]}"
		fi
		#---
		if [[ $randomized == true ]]; then
			wallpaper=$random_wallpaper
		fi
	fi
	#---
	for program in "${!program_list[@]}"; do
		process_quantity=$(ps aux | grep "$program" | wc -l)
		if [[ $process_quantity != 1 ]]; then
			active_programs=true
			rgb=""${program_list[$program]%$'\t'*}"" 
			wallpaper=""${program_list[$program]#*$'\t'}""
			read -a wallpaper_list <<< "$wallpaper"
			if [[ $randomized == true && $program != $game ]]; then
				randomized=false
			fi

			if [[ ${#wallpaper_list[@]} > 1 && $randomized == false ]]; then
				random_wallpaper=${wallpaper_list[ $(( RANDOM % ${#wallpaper_list[@]} )) ]}
				wallpaper=$random_wallpaper
				game=$program
				randomized=true
				break
			fi
			if [[ $randomized == true && $program == $game ]]; then
				wallpaper=$random_wallpaper
				break
			fi
			wallpaper=${wallpaper_list[0]}
			break


		else 
			active_programs=false 


		fi
	done
	#---
	echo GAME=$game
	echo ACTIVE_PROGRAM=$active_programs
	echo CURRENT=$current_wallpaper
	echo NEW=$wallpaper
	#---
	if [[ $current_wallpaper != $wallpaper ]]; then	
		killall -9 mpvpaper 
		mpvpaper -o 'loop no-audio panscan=1' '*' "$WALLPAPERdir$wallpaper" &
		if [[ $rgb != "n/a" ]]; then
			openrgb -p $rgb &
		fi
		current_wallpaper=$wallpaper
		iteration_count=0 
	elif [[ $current_wallpaper == $wallpaper ]]; then 
		if [[ -n $game && $active_programs == false ]]; then
			randomized=false
			game=""
		fi
		
		((iteration_count+=1)) 

		if (( $iteration_count == $ITERATION_LIMIT )); then
			killall -9 mpvpaper
			mpvpaper -o 'loop no-audio panscan=1' '*' "$WALLPAPERdir$wallpaper" &
			iteration_count=0
			randomized=false
		fi
	fi 
	sleep $DURATION
done 
