#!/bin/bash

#
# SCRIPT PARA ADIÇÃO DE CARGAS MOPAC (VERSÃO 2012) EM ARQUIVOS TRIPOS MOL2
#
# Aturoes: Humberto Freitas <humbarato@gmail.com>
#          Pedro Lacerda <kanvuanza@gmail.com>
#

# Descomente essa linha quando estiver desenvolvendo ou utilizando este script.
#set -eux

if [[ $# != 1 ]];
then
    echo "    Uso: $0 /diretorio/contendo/mol2/"
    exit 1
fi

DIR="$1" # diretório contendo arquivos mol2


for MOL2 in $DIR/*.mol2;
do
    LIGAND=`basename $MOL2 .mol2`
    echo "Calculando cargas de $LIGAND..."
    MOPAC_KEYWORDS="PM7 1SCF XYZ NOINTER SCALE=1.4 NSURF=2 SCINCR=0.4 NOMM CHARGE=0 AUX"
    
    # Converte mol2 em mop, adiciona as keywords do MOPAC e sobrescreve o arquivo mop.
    babel -imol2 $LIGAND.mol2 -omop 2> /dev/null      \
        | sed "s/PUT KEYWORDS HERE/$MOPAC_KEYWORDS/g" \
        > $LIGAND.mop

    /opt/mopac/MOPAC2012.exe $LIGAND.mop 2> /dev/null
    babel -imoo $LIGAND.out -omol2 $LIGAND-charged.mol2 2> /dev/null
done
