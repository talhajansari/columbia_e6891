#!/bin/bash
# -------------------------------------------------------------------------
# SoundRuler
#
# Bioacoustic Analysis.
#
# 2007-03-12 Marcos Gridi-Papp <mgpapp@users.sourceforge.net>
# -------------------------------------------------------------------------

if [[ $1 ]];then
   man soundruler
   exit
fi

echo " "
echo "Loading libraries, just a moment..."
echo " "
                                                               
LD_LIBRARY_PATH=/usr/share/soundruler/bin/glnx86
export LD_LIBRARY_PATH
/usr/share/soundruler/soundruler
