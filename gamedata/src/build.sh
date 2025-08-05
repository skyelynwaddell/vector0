#!/bin/bash

# Navigate to the directory of the script
pushd "$(dirname "$0")" > /dev/null

# Run the compiler
../../compiler/fteqcc64

echo
read -p "Run the game? [y/N] " answer
case "$answer" in
    [yY][eE][sS]|[yY])
        ../../vector0-sdl3 -basedir ../../
        ;;
    *)
        echo "Skipping game launch."
        ;;
esac

# Return to the original directory
popd > /dev/null
