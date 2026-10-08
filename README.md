# Dynamic-Hyprlive

Dynamic-Hyprlive is a bash program that reads if user-specified processes names are currently running via (ps aux | grep "process") and then using mpvpaper sets the corresponding wallpaper. It is named hyprlive because I wrote this program for use with Hyprland, but as the only dependency is mpvpaper, this script should work on other wlroots-based Wayland compositors.

## Dependencies
1. mpvpaper
2. openrgb *_optional_

## Installation
Download bash file, ```dynamic-hyprlivev#.sh```


Download config file, ```program_list.conf```

## Configuration 
Configure associated programs, wallpapers, and rgb profiles within a text file named "program_list.conf" in 

```~/.config/dynamic-hyprlive/```


the provided config file contains and example its instructions on syntax

### Configuration syntax
Note that between each item is a TAB(\t), HOWEVER if you want a variety of wallpapers for ONE game/process each wallpaper should be separated by a SPACE after the initial first one
You can also specify a subdirectory instead of multiple wallpapers by using the directory name followed by ".dir" (e.g. Zenless.dir)


_(individual wallpapers)_ Format is as follows: Game.exe(or Process name)(\t)Openrgb-Profile(\t)Wallpaper1 Wallpaper2 Wallpaper3 ... 

```ZenlessZoneZero.exe  beckford-night  wallpaper1 wallpaper2 wallpaper3```

_(by directory)_ wallpapers can be specified by group by placing them into a directory and referencing that directory by adding ".dir" at the end ex. NAME.dir

```ZenlessZoneZero.exe	beckford-night	ROSCAELIFER.dir```

To set the default wallpaper(as in no programs are running), use "DEFAULT" as the process or game name


If openrgb is not being used, type "n/a" as the openrgb profile name 


*** Changes to configuration file are not recognized live so afterwards you must restart the dynamic-hyprlivev#.sh process 

## Usage 
run the bash file ```dynamic-hyprlivev#.sh```


I recommend autostarting this file via desktop environment

ex. Hyprland hyprland.conf ```exec-once path/to/file/dynamic-hyprlivev#.sh```
