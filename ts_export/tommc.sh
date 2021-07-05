#!/usr/bin/env bash

# check for -h or --help as first argument
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo "Usage: tommc.sh [<target_dir_in_mmc_image>]"
    echo "The card image file is taken from variable MMC, default target directory is 'odin/wc'"
    exit
fi

# check if MMC variable is defined and points to valid image file
hdfmonkey ls "$MMC" > /dev/null 2> /dev/null
[[ $? -ne 0 ]] && { echo "define variable MMC with image file, like: MMC=~/zx/zxnext.img ./tommc.sh"; exit 1; }

# check if non-default directory for WC was provided, or set default to 'odin/wc'
[[ -n $1 ]] && WCDIR="$1" || WCDIR="odin/wc"

# check if the directory does exist in the image
hdfmonkey ls "$MMC" "$WCDIR" > /dev/null || { echo "Target directory '$WCDIR' doesn't exist in the image"; exit 2; }

# put all WC files into MMC image
echo "Putting files into '$MMC', directory '$WCDIR':"
echo -n " + "
for f in ../src/*.{bin,odn}; do
    echo -n "${f##../src/} "
    hdfmonkey put "$MMC" "$f" "$WCDIR" || { echo " (ERROR)"; exit 3; }
done
echo "(all OK)"
