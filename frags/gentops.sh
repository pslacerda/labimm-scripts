#!/bin/bash -eu

FRAGS=(
    'C3H8    +0'    # propane
    'C6H6    +0'    # benzene
    'CH4O    +0'    # methanol
    'CH3NO   +0'    # formamide
    'C2H4O   +0'    # acetaldehyde
    'CH6N+   +1'    # methylammonium
    'C2H3O2- -1'    # acetate
)


IDX=1
for FRAG in "${FRAGS[@]}"
do
    # Declare variables
    read MOL NET <<< $FRAG
    PROBE="P$((IDX++))"

    echo $MOL

    # SDF > MOL2
    obabel $MOL.sdf --gen3d -O$MOL.mol2 > $MOL.obabel.log 2>&1

    # Fix molecule and residue name
    sed -i "2s/.*/$PROBE/" $MOL.mol2
    sed -i "s/UNL/$PROBE/g" $MOL.mol2

    # Run ACPYPE
    python acpype.py -d -n $NET -i $MOL.mol2 > $MOL.acpype.log 2>&1
done
