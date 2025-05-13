+++
date = 2025-04-23T08:00:00.00-06:00
title = "FTEQW Setup Guide"
[taxonomies]
categories = ["docs"]
tags = ["quake", "fteqw"]
[extra]
author = "erysdren"
+++

## folder structure

follow the links on each file to get an explanation of how to setup them up,
and what they're used for!

- mygame/
	- gamedata/
		- src/
			- [cl_defs.qc](#csqc-setup)
			- [client.src](#csqc-setup)
			- [cl_main.qc](#csqc-setup)
			- [defs.qc](#quakec-setup)
			- [fteextensions.qc](#fteextensions-qc)
			- [progs.src](#quakec-setup)
			- [server.src](#ssqc-setup)
			- [sv_defs.qc](#ssqc-setup)
			- [sv_main.qc](#ssqc-setup)
		- [csprogs.dat](#compiling-quakec)
		- [default.cfg](#engine-setup)
		- [progs.dat](#compiling-quakec)
		- [quake.rc](#engine-setup)
	- [default.fmf](#fte-manifests)
	- [fteqw64.exe](#engine-setup)

---

## engine setup

the FTEQW engine can be acquired [here](https://www.fteqw.org/).

---

## FTE Manifests

FTE Manifest (FMF) files are read by the engine to give an overview of a game's
name and directory information. for our purposes, `default.fmf` should look
like this:

```
FTEMANIFEST 1
GAME mygame
BASEGAME gamedata
NAME "My Game"
DISABLEHOMEDIR 1
MAINCONFIG "config.cfg"
```

- `GAME`: defines the base "game type". there are some presets, but for a
standalone game you can make one up.
- `BASEGAME`: base game directory to load from. it can be anything, but in our
case it's named `gamedata`.
- `NAME`: the printable name of your game.
- `DISABLEHOMEDIR`: set to 1 if you want to prevent FTE from writing config
files to your system user directory. on Linux this will probably be under
`~/.local/config/`, and on Windows it might be under `Documents\My Games\` or
something.
- `MAINCONFIG`: set the name of the file to write when saving user config info.
this is `fte.cfg` by default, but i personally prefer `config.cfg`.

further documentation on FTE Manifests can be found
[here](https://github.com/fte-team/fteqw/blob/master/specs/fte_manifests.txt).

---

## QuakeC setup

---

## fteextensions.qc

this file contains information for the FTEQCC compiler on what extensions and
builtin functions are available for your QuakeC code to use. it is generated
by the engine with the `pr_dumpplatform` console command.

---

## CSQC setup

---

## SSQC setup

---

## compiling QuakeC

building your QuakeC code requires the [FTEQCC](https://www.fteqcc.org/)
compiler. to build the code as i've set it up here, just run the command
`fteqcc` in your terminal while in the `mygame/gamedata/src/` folder. it should
automatically generate the `progs.dat` and `csprogs.dat` files in the parent
folder.
