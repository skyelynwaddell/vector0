# qengine - fteqw
https://www.fteqw.org/ <br>
https://github.com/fte-team/fteqw

## Getting Started
Drag Quake Game Files into `gamedata` folder. <br>
The quake game files folder should contain `glquake.exe`. <br>
Extract fteqw_win64.zip into gamedata, or get the newest/proper version for your system from `fteqw.org`.

## Install ericwtools
https://github.com/ericwa/ericw-tools<br>
These include tools for lighting, turning .map files into .bsp and other useful utilities/tools for map compiling. <br>
Extract these files into a folder somewhere, trenchbroom will need access to these files. <br>


## Mapping
Download trenchbroom:
https://trenchbroom.github.io/ <br>
After installing trenchbroom and opening it, click `New Map...`

Select `Quake` from the games list, and click `Open preferences...` <br>
Another list of games will show up in preferences, go down to `Quake`.

There will be 4 paths you will have to fill in

- Game Path : Your `gamedata` folder.
- qbsp : Points to `ericwtools/qbsp.exe`
- vis : Points to `ericwtools/vis.exe`
- light : Points to `ericwtools/light.exe`

Click Apply/Ok, and now select:
`Map Format = Valve`

The map is setup for use.

## Compiling Maps
In Trenchbroom with your map open, click:
`Run, Compile Map...`

Create a new profile called `BSP Compile`, and add the following settings:
![alt text](repo_assets/image.png)

### Compile Settings from the above image to copy from
```js
# Export Map:
File Path: ${WORK_DIR_PATH}/${MAP_BASE_NAME}-compile.map

# Run Tool
Tool Path: C:/dev/ericwtools/qbsp.exe
Parameters: ${MAP_BASE_NAME}-compile.map ${MAP_BASE_NAME}.bsp

# Run Tool
Tool Path: C:/dev/ericwtools/vis.exe
Parameters: ${MAP_BASE_NAME}.bsp

# Run Tool
Tool Path: C:/dev/ericwtools/light.exe
Parameters: -lit ${MAP_BASE_NAME}.bsp

# Copy Files
Source File Path: ${WORK_DIR_PATH}/${MAP_BASE_NAME}.bsp
Target Directory Path: ${GAME_DIR_PATH}/maps/

# Copy Files
Source File Path: ${WORK_DIR_PATH}/${MAP_BASE_NAME}.lit
Target Directory Path: ${GAME_DIR_PATH}/maps/
```