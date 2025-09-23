# ![Map Compile Settings](tbdata/qengine/icon.png) qengine
3D FPS Game using FTEQW QuakeWorld engine. <br>
https://www.fteqw.org/ <br>
https://github.com/fte-team/fteqw <br>
https://github.com/shpuld/sui-qc <br>

For setup and getting started using qengine, follow the tasks below in order.

### Table of Contents
- [QuakeC Manual](help/qcmanual.txt)
- [Install ericwtools](#install-ericwtools)
- [Mapping](#mapping)
- [Compiling Maps](#compiling-maps)
- [Compiling the Game](#compiling-the-game)

## Install ericwtools
https://github.com/ericwa/ericw-tools<br>
These include tools for lighting, turning .map files into .bsp and other useful utilities/tools for map compiling. <br>
Extract these files into a folder somewhere, trenchbroom will need access to these files. <br>

## Exporting GLTF models from blender WITHOUT Gloss
I use .glb for morph targets.
Make sure the textures used are beside the .glb model file! (and blender is referencing the ones beside the .glb!!!), 
Apply a Principled BSDF shader with all IOR levels at 0, Metallics at 0, and Roughness at 1.0.
Get this shader!!!:
https://github.com/fte-team/fteqw/blob/master/engine/shaders/glsl/defaultskin.glsl grab that, shove it in your $gamedir/glsl/ subdir, put #undef ORM right after the !!foo headery bit

## Mapping
Download trenchbroom:
https://trenchbroom.github.io/ <br>

Drag the folder `qengine` from `/tbdata` into `TRENCHBROOM_INSTALL_PATH/games/`

After installing trenchbroom and adding `qengine` to the games folder, open the app and click `New Map...`

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
![Map Compile Settings](help/map_compile_settings.png)

### Compile Settings from the above image to copy from
```js
# Export Map:
File Path: ${WORK_DIR_PATH}/${MAP_BASE_NAME}-compile.map

# Run Tool
Tool Path: C:/dev/ericwtools/qbsp.exe
Parameters: -notex ${MAP_BASE_NAME}-compile.map ${MAP_BASE_NAME}.bsp

# Run Tool
Tool Path: C:/dev/ericwtools/vis.exe
Parameters: ${MAP_BASE_NAME}.bsp

# Run Tool
Tool Path: C:/dev/ericwtools/light.exe
Parameters: -lit -bounce 2 ${MAP_BASE_NAME}.bsp
```

## Compiling the Game
To compile the game you will need FTEQCC, it is included in the `compiler` folder, or can be downloaded from: <br> 
https://www.fteqcc.org/

If manually downloaded, add the files to the `compiler` folder.

You can simply run the fteqcc64.exe from the terminal in the /gamedata/src folder to compile the game. <br>
For example run from /gamedata/src folder: `../../compiler/fteqcc64.exe` <br>

Alternatively, I've included a `build.bat` file in the /src folder. <br>
Simply navigate to the /src folder and run: `./build.bat` <br>
(Your fteqcc compiler must be in the `compiler` folder for the .bat program to work)