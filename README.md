# NanoPhase
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/platforms.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/version.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/downloads.svg)](https://anaconda.org/nanophase/nanophase)
[![Anaconda-Server Badge](https://anaconda.org/nanophase/nanophase/badges/installer/conda.svg)](https://conda.anaconda.org/nanophase)

NanoPhase is an easy-to-use pipeline to generate reference-quality MAGs using only Nanopore long reads or both Nanopore long and Illumina short reads (hybrid strategy) from complex metagenomes. If NanoPhase is interrupted, it will resume from the last completed stage.

### Installation instructions
1). One of the most convenient and fast ways to install NanoPhase is create a NanoPhase env and using [mamba](https://github.com/mamba-org/mamba) to install/manage [all NanoPhase dependancies](https://github.com/Hydro3639/NanoPhase/blob/main/dependancy.md). It should be finished in ~5 mins (depends on your local internet).
If mamba is not in the base environment, please use `conda install mamba -n base -c conda-forge` to install and follow the instruction to activate mamba.
```
git clone https://github.com/Hydro3639/NanoPhase.git
source NanoPhase/bin/Install.sh
## this command will create NanoPhase env and install all necessary packages
```
You may check if all necessary packages have been installed sucessfully in the NanoPhase env using the following command
```
mamba activate NanoPhase
## or conda activate NanoPhase
NanoPhase --check
## if still some packages were not in the NanoPhase enviroment, please install, like using "mamba install -c bioconda package_name", then check it again
```
2). Install NanoPhase via conda
```
mamba create -n NanoPhase python=3.8 -y
mamba activate NanoPhase
mamba install -c nanophase nanophase -y
```
Then you may check if all necessary packages existed using `NanoPhase --check`.
If all pakcages have been installed sucessfully in the NanoPhase env, type `NanoPhase -h` for more usage information
```
NanoPhase -h

NanoPhase v=0.1.0

arguments:
        --check                 check the package availability
        --long_read_only        only Nanopore long reads were involved [default: on]
        --hybrid                both short and long reads were required [Optional]
        -l, --long              Nanopore reads: fasta/q file that basecalled by Guppy 5+ or using 20+ chemistry was recommended if only Nanopore reads were included [Mandatory]
        -1                      Illumina short reads: fasta/q paired-end #1 file [Optional]
        -2                      Illumina short reads: fasta/q paired-end #2 file [Optional]
        -m, --medaka_model      medaka model used for medaka polishing [default: r941_min_hac_g507]
        -t, --threads           Number of threads that used for assembly and polishing [default: 16]
        -o, --out               Output directory [default: ./NanoPhase-out]
        -h, --help              Print help information and exit
        -v, --version           Show version number and exit

output sub-folders:
        01-LongAssemblies       Sub-folder containing information of Nanopore long-read assemblies (assembler: metaFlye)
        02-LongBins             Sub-folder containing the initial bins with relatively low-accuracy quality
        03-Polishing            Sub-folder containing polished bins

example usage:
        NanoPhase --check ## package availability checking
        Nanophase -l ont.fastq -t 16 -o NanoPhase-out ## long reads only
        Nanophase -l ont.fastq --hybrid -1 sr_1.fastq -2 sr_2.fastq -t 16 -o NanoPhase-out ## hybrid strategy
```
