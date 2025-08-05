#!/bin/bash

# Create 'bin' directory if it doesn't exist
mkdir -p bin

# Copy and rename FTEQW binaries
cp fteqw64           bin/game
cp fteqw64.exe     bin/game.exe
cp fteqw-gl        bin/game-gl
cp fteqw-sv        bin/game-sv

# Copy supporting files to bin
cp identity.pfx    bin/
cp default.fmf     bin/
cp -r gamedata     bin/
cp LICENSE         bin/

echo "Deployment complete."

