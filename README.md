# NanoPhase
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/platforms.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/version.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/downloads.svg)](https://anaconda.org/nanophase/nanophase)


nanophase is an easy-to-use pipeline to generate reference-quality MAGs using only Nanopore long reads (long-read-only strategy) or both Nanopore long and Illumina short reads (hybrid strategy) from complex metagenomes. Since nanophase v0.2.0, it also supports to generate reference-quality genomes from bacterial/archaeal isolates (long-read-only or hybrid strategy). If nanophase is interrupted, it will resume from the last completed stage.

## Installation instructions
It is advised to first install [conda](https://docs.conda.io/en/latest/miniconda.html) (`miniconda3` is suggested), then add required channels and install [mamba](https://github.com/mamba-org/mamba) following the instruction below:
```
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda install mamba -n base -c conda-forge -y
mamba init && source ~/.bashrc ## only once, if mamba was still not in your local env, try opening a new terminal
```
1). Recommend: install nanophase including [all nanophase dependancies](https://github.com/Hydro3639/NanoPhase/blob/main/dependancy.md) via conda/mamba (`mamba install` is much faster than `conda install`). It should be finished in ~5 mins (depends on your local internet).
```
mamba create -n nanophase -c nanophase nanophase -y
```
or
```
mamba create -n nanophase python=3.8 -y && mamba activate nanophase && mamba install -c nanophase nanophase -y
```
2). Alternative: download the nanophase scripts from github; then install and setup [all nanophase dependancies](https://github.com/Hydro3639/NanoPhase/blob/main/dependancy.md) in the nanophase env by yourself if you know the system and feel comfortable.
```
git clone https://github.com/Hydro3639/NanoPhase.git
## you can refer to NanoPhase/bin/Install.sh to install all dependancies; e.g., source NanoPhase/bin/Install.sh
```
## [GTDB](https://gtdb.ecogenomic.org/downloads) and [PLSDB](https://ccb-microbe.cs.uni-saarland.de/plsdb/plasmids/download/) download
Please note that GTDB/PLSDB database will not download automatically via the above installation, so the user can specify a friendly storage location because they take a lot of storage space: GTDB ([~66G](https://ecogenomics.github.io/GTDBTk/installing/index.html#installing-third-party-software:~:text=GTDB%2DTk%20requires%20~66G%20of%20external%20data%20that%20needs%20to%20be%20downloaded%20and%20unarchived%3A)) and PLSDB (~3.4G). Or if you have downloaded the above databases before, you may skip the first download step, just following the location setting step.
```
## download database: May skip if you have done before or GTDB and PLSDB have been downloaded in the server
wget https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_v2_data.tar.gz && tar xvzf gtdbtk_v2_data.tar.gz 
wget https://ccb-microbe.cs.uni-saarland.de/plsdb/plasmids/download/plsdb.fna.bz2 && bunzip2 plsdb.fna.bz2
conda activate nanophase

## setting location
echo "export GTDBTK_DATA_PATH=/path/to/release/package/" > $(dirname $(dirname `which nanophase`))/etc/conda/activate.d/np_db.sh
## Change /path/to/release/package/ to the real location where you stored the GTDB
echo "export PLSDB_PATH=/path/to/plsdb.fna" >> $(dirname $(dirname `which nanophase`))/etc/conda/activate.d/np_db.sh
## Change /path/to/plsdb.fna to the real location where you stored the PLSDB
conda deactivate && conda activate nanophase ## require re-activate nanophase
```
## Usage
Please look at [nanophase usage tutorial](https://github.com/Hydro3639/nanophase/blob/main/Usage_tutorial.md) to verify the nanophase installation via an [example dataset](https://github.com/example-data/np-example).

Briefly, you may check if all necessary packages have been installed sucessfully in the nanophase env using the following command.
```
conda activate nanophase ## if not in the nanophase env

nanophase check

Check software availability and locations
The following packages have been found
#package             location
flye                 /path/to/miniconda3/envs/nanophase/bin/flye
metabat2             /path/to/miniconda3/envs/nanophase/bin/metabat2
maxbin2              /path/to/miniconda3/envs/nanophase/bin/run_MaxBin.pl
SemiBin              /path/to/miniconda3/envs/nanophase/bin/SemiBin
metawrap             /path/to/miniconda3/envs/nanophase/bin/metawrap
checkm               /path/to/miniconda3/envs/nanophase/bin/checkm
racon                /path/to/miniconda3/envs/nanophase/bin/racon
medaka               /path/to/miniconda3/envs/nanophase/bin/medaka
polypolish           /path/to/miniconda3/envs/nanophase/bin/polypolish
POLCA                /path/to/miniconda3/envs/nanophase/bin/polca.sh
bwa                  /path/to/miniconda3/envs/nanophase/bin/bwa
seqtk                /path/to/miniconda3/envs/nanophase/bin/seqtk
minimap2             /path/to/miniconda3/envs/nanophase/bin/minimap2
BBMap                /path/to/miniconda3/envs/nanophase/bin/BBMap
parallel             /path/to/miniconda3/envs/nanophase/bin/parallel
perl                 /path/to/miniconda3/envs/nanophase/bin/perl
samtools             /path/to/miniconda3/envs/nanophase/bin/samtools
gtdbtk               /path/to/miniconda3/envs/nanophase/bin/gtdbtk
fastANI              /path/to/miniconda3/envs/nanophase/bin/fastANI
blastp               /path/to/miniconda3/envs/nanophase/bin/blastp
All required packages have been found in the environment. If the above certain packages integrated into nanophase were used in your investigation, please give them credit as well :)
```
If all pakcages have been installed sucessfully in the nanophase env, type `nanophase -h` for more usage information.
```
nanophase -h

nanophase v=0.2.3

Main modules
        check                   check if all packages have been installed
        meta                    genome assembly, binning, quality assessment and classification for metagenomic datasets
        isolate                 genome assembly, binning, quality assessment and classification for bacterial isolates

Test modules
        args                    Antibiotic Resistance Genes (ARGs) identification from reconstructed MAGs
        plasmid                 Plasmid identification from reconstructed MAGs

Other options
        -h | --help             show the help message
        -v | --version          show nanophase version

example usage:
        nanophase check                                                                                         ## package availability checking
        nanophase meta -l ont.fastq.gz -t 16 -o nanophase-out                                                   ## meta::long reads only
        nanophase meta -l ont.fastq.gz --hybrid -1 sr_1.fastq.gz -2 sr_2.fastq.gz -t 16 -o nanophase-out        ## meta::hybrid strategy
        nanophase isolate -l ont.fastq.gz -t 16 -o nanophase-out                                                ## isolate::long reads only
        nanophase isolate -l ont.fastq.gz --hybrid -1 sr_1.fastq.gz -2 sr_2.fastq.gz -t 16 -o nanophase-out     ## isolate::hybrid strategy
        nanophase args -i Final-bins -x fasta -o nanophase.ARGs.summary.txt                                     ## ARGs identification
        nanophase plasmid -i Final-bins -x fasta -o nanophase.pls.summary.txt                                   ## Plasmids identification
        
```
Each module is run separately. For example, to check the nanophase `meta` module, type `nanophase meta -h` for more usage information.
```
nanophase meta -h

nanophase v=0.2.3

arguments:
        --long_read_only        only Nanopore long reads were involved [default: on]
        --hybrid                both short and long reads were required [Optional]
        -l, --long              Nanopore reads: fasta/q file that basecalled by Guppy 5+ or using 20+ chemistry was recommended if only Nanopore reads were included [Mandatory]
        -1                      Illumina short reads: fasta/q paired-end #1 file [Optional]
        -2                      Illumina short reads: fasta/q paired-end #2 file [Optional]
        -m, --medaka_model      medaka model used for medaka polishing [default: r1041_e82_400bps_sup_g615]
        -e, --environment	Build-in model of SemiBin [default: wastewater]; detail see: SemiBin single_easy_bin -h
        -t, --threads           number of threads that used for assembly and polishing [default: 16]
        -o, --out               output directory [default: ./nanophase-out]
        -h, --help              print help information and exit
        -v, --version           show version number and exit

output sub-folders:
        01-LongAssemblies       sub-folder containing information of Nanopore long-read assemblies (assembler: metaFlye)
        02-LongBins             sub-folder containing the initial bins with relatively low-accuracy quality
        03-Polishing            sub-folder containing polished bins

example usage:
        nanophase meta -l ont.fastq.gz -t 16 -o nanophase-out                                                 ## long reads only
        nanophase meta -l ont.fastq.gz --hybrid -1 sr_1.fastq.gz -2 sr_2.fastq.gz -t 16 -o nanophase-out      ## hybrid strategy

```

