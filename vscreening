#!/bin/bash

#
# vscreening.sh
# ~~~~~~~~~~~~~
#

if [[ $# != 2 ]]
then
    echo "  usage: $0 <IN_FILES_PATTERN> <OUT_DIR>"
    echo "example: $0 \"fragments/*.pdbqt\" result"
    exit 1
fi

GLOB="$1" # pattern matching all input files
DEST="$2" # destination directory

# iterate over all input files
for INF in `find "$PWD" -type f -path "$GLOB"`
do
    LIGAND=`basename "$INF" .pdbqt`  # ligand name
    OUTF="$DEST/$LIGAND.out.pdbqt"   # output file
    LOGF="$DEST/$LIGAND.log"         # log file
    
    mkdir -p "$DEST/$LIGAND"

    # run vina
    vina "$INF" "$OUTF" "$LOGF"

    # keep processed and unprocessed files separated
    mv "$INF" "$DEST/$LIGAND"
done
