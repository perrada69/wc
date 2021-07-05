#!/usr/bin/env bash

# personal script of Ped to put all ODN files into card image, run CSpect and extract ASM versions
MMC=${MMC:-~/zx/core/mmc-1.3.2-128mb/tbblue.mmc}
WCDIR="odin/wc"
MMC=$MMC ./tommc.sh "$WCDIR"
mmcCSpect "$MMC"
MMC=$MMC ./frommmc.sh "$WCDIR"
