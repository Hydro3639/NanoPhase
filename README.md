# NanoPhase
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/platforms.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/version.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/downloads.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/installer/conda.svg)](https://conda.anaconda.org/nanophase)


NanoPhase is an easy-to-use pipeline to generate reference-quality MAGs using only Nanopore long reads (long-read-only strategy) or both Nanopore long and Illumina short reads (hybrid strategy) from complex metagenomes. Since NanoPhase v2.0, it also supports to generate reference-quality genomes from bacterial/archaeal isolates (long-read-only or hybrid strategy). If NanoPhase is interrupted, it will resume from the last completed stage.

## Installation instructions
It is advised to first install [conda](https://docs.conda.io/en/latest/miniconda.html) (`miniconda3` is suggested), then add required channels and install [mamba](https://github.com/mamba-org/mamba) following the instruction below:
```
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda install mamba -n base -c conda-forge -y
mamba init && source ~/.bashrc ## only once, if mamba was still not in your local env, try opening a new terminal
```
1). Recommend: Install NanoPhase including [all NanoPhase dependancies](https://github.com/Hydro3639/NanoPhase/blob/main/dependancy.md) via conda/mamba (`mamba install` is much faster than `conda install`). It should be finished in ~5 mins (depends on your local internet).
```
mamba create -n NanoPhase python=3.8 -y
mamba activate NanoPhase
mamba install -c nanophase nanophase -y
```
2). Alternative: Install NanoPhase via the source code.
```
git clone https://github.com/Hydro3639/NanoPhase.git
source NanoPhase/bin/Install.sh
## this command will create NanoPhase env and install all necessary packages
```
## [GTDB database](https://gtdb.ecogenomic.org/downloads) download
Please note that GTDB database will not download automatically via the above installation, so the user can specify a friendly storage location because it takes a lot of storage space ([~66G](https://ecogenomics.github.io/GTDBTk/installing/index.html#installing-third-party-software:~:text=GTDB%2DTk%20requires%20~66G%20of%20external%20data%20that%20needs%20to%20be%20downloaded%20and%20unarchived%3A)). Or if you have downloaded this database before, you may skip this first download step.
```
wget https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_v2_data.tar.gz && tar xvzf gtdbtk_v2_data.tar.gz ## May skip if you have done before
conda activate NanoPhase
echo "export GTDBTK_DATA_PATH=/path/to/release/package/" > $(dirname $(dirname `which NanoPhase`))/etc/conda/activate.d/gtdbtk.sh ## Change /path/to/release/package/ to the real location where you storaged the GTDB database
```
## Usage
Please look at [NanoPhase usage tutorial](https://github.com/Hydro3639/NanoPhase/blob/main/Usage_tutorial.md) to verify the NanoPhase installation via an [example dataset](https://github.com/example-data/np-example).

Briefly, you may check if all necessary packages have been installed sucessfully in the NanoPhase env using the following command.
```
conda activate NanoPhase ## if not in the NanoPhase env
NanoPhase check

Check software availability and locations
The following packages have been found
#package             location
flye                 /path/to/miniconda3/envs/NanoPhase/bin/flye
metabat2             /path/to/miniconda3/envs/NanoPhase/bin/metabat2
maxbin2              /path/to/miniconda3/envs/NanoPhase/bin/run_MaxBin.pl
metawrap             /path/to/miniconda3/envs/NanoPhase/bin/metawrap
checkm               /path/to/miniconda3/envs/NanoPhase/bin/checkm
racon                /path/to/miniconda3/envs/NanoPhase/bin/racon
medaka               /path/to/miniconda3/envs/NanoPhase/bin/medaka
polypolish           /path/to/miniconda3/envs/NanoPhase/bin/polypolish
POLCA                /path/to/miniconda3/envs/NanoPhase/bin/polca.sh
bwa                  /path/to/miniconda3/envs/NanoPhase/bin/bwa
seqtk                /path/to/miniconda3/envs/NanoPhase/bin/seqtk
minimap2             /path/to/miniconda3/envs/NanoPhase/bin/minimap2
BBMap                /path/to/miniconda3/envs/NanoPhase/bin/BBMap
parallel             /path/to/miniconda3/envs/NanoPhase/bin/parallel
perl                 /path/to/miniconda3/envs/NanoPhase/bin/perl
samtools             /path/to/miniconda3/envs/NanoPhase/bin/samtools
gtdbtk               /path/to/miniconda3/envs/NanoPhase/bin/gtdbtk
fastANI              /path/to/miniconda3/envs/NanoPhase/bin/fastANI
blastp               /path/to/miniconda3/envs/NanoPhase/bin/blastp
All required packages have been found in the environment. If the above certain packages integrated into NanoPhase were used in your investigation, please give them credit as well :)
```
If all pakcages have been installed sucessfully in the NanoPhase env, type `NanoPhase -h` for more usage information.
```
NanoPhase -h

NanoPhase v=0.2.0

Main modules
        check                   check if all packages have been installed
        meta                    genome assembly, binning, quality assessment and classification for metagenomic datasets
        isolate                 genome assembly, binning, quality assessment and classification for bacterial isolates

Test modules
        args                    Antibiotic Resistance Genes (ARGs) identification from reconstructed MAGs

Other options
        -h | --help             show the help message
        -v | --version          show NanoPhase version

example usage:
        NanoPhase check                                                                                         ## package availability checking
        NanoPhase meta -l ont.fastq.gz -t 16 -o NanoPhase-out                                                   ## meta::long reads only
        NanoPhase meta -l ont.fastq.gz --hybrid -1 sr_1.fastq.gz -2 sr_2.fastq.gz -t 16 -o NanoPhase-out        ## meta::hybrid strategy
        NanoPhase isolate -l ont.fastq.gz -t 16 -o NanoPhase-out                                                ## isolate::long reads only
        NanoPhase isolate -l ont.fastq.gz --hybrid -1 sr_1.fastq.gz -2 sr_2.fastq.gz -t 16 -o NanoPhase-out     ## isolate::hybrid strategy
        NanoPhase args -i Final-bins -x fasta -o NanoPhase.ARGs.summary.txt                                     ## ARGs identification
        
```
Each module is run separately. For example, to check the NanoPhase `meta` module, type `NanoPhase meta -h` for more usage information.
```
NanoPhase meta -h

NanoPhase v=0.2.0

arguments:
        --long_read_only        only Nanopore long reads were involved [default: on]
        --hybrid                both short and long reads were required [Optional]
        -l, --long              Nanopore reads: fasta/q file that basecalled by Guppy 5+ or using 20+ chemistry was recommended if only Nanopore reads were included [Mandatory]
        -1                      Illumina short reads: fasta/q paired-end #1 file [Optional]
        -2                      Illumina short reads: fasta/q paired-end #2 file [Optional]
        -m, --medaka_model      medaka model used for medaka polishing [default: r941_min_hac_g507]
        -t, --threads           number of threads that used for assembly and polishing [default: 16]
        -o, --out               output directory [default: ./NanoPhase-out]
        -h, --help              print help information and exit
        -v, --version           show version number and exit

output sub-folders:
        01-LongAssemblies       sub-folder containing information of Nanopore long-read assemblies (assembler: metaFlye)
        02-LongBins             sub-folder containing the initial bins with relatively low-accuracy quality
        03-Polishing            sub-folder containing polished bins

example usage:
        NanoPhase meta -l ont.fastq.gz -t 16 -o NanoPhase-out                                                 ## long reads only
        NanoPhase meta -l ont.fastq.gz --hybrid -1 sr_1.fastq.gz -2 sr_2.fastq.gz -t 16 -o NanoPhase-out      ## hybrid strategy

```

