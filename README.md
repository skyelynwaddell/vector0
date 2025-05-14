# qengine - fteqw
https://www.fteqw.org/ <br>
https://github.com/fte-team/fteqw

## Install ericwtools
https://github.com/ericwa/ericw-tools<br>
These include tools for lighting, turning .map files into .bsp and other useful utilities/tools for map compiling. <br>
Extract these files into a folder somewhere, trenchbroom will need access to these files. <br>

## Mapping
Download trenchbroom:
https://trenchbroom.github.io/ <br>

Drag the folder `qengine` from `/tbdata` into `TRENCHBROOM_INSTALL_PATH/games/`

After installing trenchbroom and adding the qengine to the games folder, open the app and click `New Map...`

Select `qengine` from the games list, and click `Open preferences...` <br>
Another list of games will show up in preferences, go down to `qengine`.

There will be 4 paths you will have to fill in

- Game Path : Your `gamedata` folder.
- qbsp : Points to `ericwtools/qbsp.exe`
- vis : Points to `ericwtools/vis.exe`
- light : Points to `ericwtools/light.exe`

Click Apply/Ok, and now select (if not already selected):
`Map Format = Valve`

The map is setup for use.

## Compiling Maps
In Trenchbroom with your map open, click:
`Run, Compile Map...`

Create a new profile called `BSP Compile`, and add the following settings:
![alt text](help/map_compile_settings.png)

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