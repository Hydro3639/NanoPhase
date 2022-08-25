#!/bin/bash
## usage: source Install.sh

if [[ "$(command -v mamba)" ]]; then
        echo "mamba has been installed and now starts..."
else
        echo "mamba could be installed by 'conda install mamba -n base -c conda-forge -y'"
        exit
fi

mamba create -n NanoPhase python=3.8 -y
mamba activate NanoPhase

#mamba install -c bioconda medaka=1.6.0 -y
mamba install -c bioconda flye=2.9 metabat2=2.15 maxbin2=2.2.7 bwa=0.7.17 seqtk=1.3 masurca=4.0.9 -y
mamba install -c conda-forge parallel -y

mamba remove samtools -y
mamba install -c bioconda medaka=1.6.0 -y

WorkDIR="`pwd`"
chmod +x NanoPhase/bin/*

NPDIR="`which polca.sh | sed -e 's/polca.sh//g'`"
sed -i.bak '0,/\$BASM.alignSorted/s//-o \$BASM.alignSorted.bam/' $NPDIR/polca.sh
cp NanoPhase/bin/* $NPDIR

cd $NPDIR
wget https://github.com/bxlab/metaWRAP/archive/refs/tags/v1.3.tar.gz
tar -zxvf v1.3.tar.gz && rm -rf v1.3.tar.gz
mv metaWRAP-1.3/bin/* ./

wget https://github.com/rrwick/Polypolish/releases/download/v0.5.0/polypolish-linux-x86_64-musl-v0.5.0.tar.gz
tar -zxvf polypolish-linux-x86_64-musl-v0.5.0.tar.gz && rm -rf polypolish-linux-x86_64-musl-v0.5.0.tar.gz

mamba install numpy matplotlib pysam hmmer prodigal pplacer -y
mamba install -c bioconda blast
pip3 install checkm-genome
wget https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
mkdir checkm_DB && tar -zxvf checkm_data_2015_01_16.tar.gz -C checkm_DB && rm -rf checkm_data_2015_01_16.tar.gz
checkm data setRoot $NPDIR/checkm_DB
## for test ARGs module
wget -q https://raw.githubusercontent.com/xinehc/args_oap/main/args_oap/DB/SARG.fasta
wget -q https://raw.githubusercontent.com/xinehc/args_oap/main/args_oap/DB/multi-component_structure.txt
wget -q https://raw.githubusercontent.com/xinehc/args_oap/main/args_oap/DB/single-component_structure.txt
wget -q https://raw.githubusercontent.com/xinehc/args_oap/main/args_oap/DB/two-component_structure.txt
makeblastdb -dbtype prot -in SARG.fasta
cd -

mamba install -c bioconda bbmap=38.96 -y
pip install numpy==1.19.5
python -m pip install gtdbtk

mamba deactivate

