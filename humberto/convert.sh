#!/bin/bash

set -eux

DIR="$1"

for MOL2 in $DIR/*.mol2;
do
    LIGAND=`basename $MOL2 .mol2`
    MOP=$LIGAND.mop
    OUT=$LIGAND.out
    MOL2C=$LIGAND-c.mol2

    echo "Calculando cargas de $LIGAND"
    babel -imol2 $MOL2 -omop 2> /dev/null | sed "s/PUT KEYWORDS HERE/PM7 1SCF XYZ NOINTER SCALE=1.4 NSURF=2 SCINCR=0.4 NOMM CHARGE=0 AUX/g" > $MOP
    mopac $MOP
    babel -imoo $OUT -omol2 $MOL2C

done
