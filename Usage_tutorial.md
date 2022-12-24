## A guide to verify NanoPhase installation: reconstructing reference-quality MAGs from an example dataset (nanophase v0.2.2)
### [Example dataset](https://github.com/example-data/np-example) download
```
wget https://github.com/example-data/np-example/raw/main/np.test.tar && tar -xvf np.test.tar && rm -rf np.test.tar ## download the example data
```
Or it waits too long, you may using the following link as well
```
wget -O np.test.tar https://www.dropbox.com/s/ey9hfntqn789gz0/np.test.tar?dl=0 && tar -xvf np.test.tar && rm -rf np.test.tar 
```

### Using only Nanopore long reads to reconstruct reference-quality MAGs
```
conda activate nanophase ## if not in the nanophase env
nanophase meta -l lr.fa.gz -t 40 -o ont-nanophase-out   ## using only Nanopore long reads
```
It should be finished in ~2 hours. The output folder/file structure should be like:
```
ont-nanophase-out/
├── 01-LongAssemblies
│   ├── assembly.fasta
│   ├── assembly_info.txt
│   └── flye.log
├── 02-LongBins
│   ├── BIN_REFINEMENT
│   │   ├── bin_refinement.log
│   │   ├── figures
│   │   ├── maxbin2-bins
│   │   │   ├── bin.001.fa
│   │   │   └── bin.002.fa
│   │   ├── maxbin2-bins.stats
│   │   ├── metabat2-bins
│   │   │   └── bin.1.fa
│   │   ├── metabat2-bins.stats
│   │   ├── metawrap_50_10_bins
│   │   │   ├── bin.1.fa
│   │   │   └── bin.2.fa
│   │   ├── metawrap_50_10_bins.contigs
│   │   └── metawrap_50_10_bins.stats
│   └── INITIAL_BINNING
│       ├── maxbin2
│       │   ├── bin.log
│       │   ├── bin.marker
│       │   ├── bin.marker_of_each_bin.tar.gz
│       │   ├── bin.noclass
│       │   ├── bin.summary
│       │   ├── bin.tooshort
│       │   ├── maxbin2_abun.txt
│       │   └── maxbin2-bins
│       ├── metabat2
│       │   ├── bin.log
│       │   ├── metabat2_abun.txt
│       │   └── metabat2-bins
│       └── tmp.abun.txt
└── 03-Polishing
    ├── Final-bins
    │   ├── bin.1.fasta
    │   └── bin.2.fasta
    ├── medaka
    │   ├── bin.1-medaka
    │   │   └── consensus.fasta
    │   ├── bin.2-medaka
    │   │   └── consensus.fasta
    │   └── medaka.polish.log
    ├── nanophase.ont.genome.summary
    └── Racon
        ├── bin.1
        │   └── bin.1-racon01.fasta
        ├── bin.2
        │   └── bin.2-racon01.fasta
        └── racon.polish.log

20 directories, 32 files
```
Final reconstructed MAGs could be found in `ont-nanophase-out/03-Polishing/Final-bins/` and the summary file of the reconstructed MAGs could be found in `ont-nanophase-out/03-Polishing/nanophase.ont.genome.summary`
```
ls ont-nanophase-out/03-Polishing/Final-bins/
bin.1.fasta  bin.2.fasta

cat ont-nanophase-out/03-Polishing/nanophase.ont.genome.summary
#BinID  Completeness    Contamination   Strain heterogeneity    GenomeSize(bp)  N_Contig        N50(bp) GC      IfCir.  GTDB-Taxa
bin.1   100.00  0.00    0.00    2028336 1       2028336 0.59294 Y       d__Bacteria;p__Actinobacteriota;c__Actinomycetia;o__Actinomycetales;f__Bifidobacteriaceae;g__Bifidobacterium;s__Bifidobacterium
bin.2   99.18   0.55    100.00  1889262 2       1827333 0.52312 N       d__Bacteria;p__Firmicutes;c__Bacilli;o__Lactobacillales;f__Lactobacillaceae;g__Limosilactobacillus;s__Limosilactobacillus
```
### Using hybrid strategy (Nanopore long reads + Illumina short reads) to reconstruct reference-quality MAGs
```
conda activate nanophase ## if not in the nanophase env
nanophase meta -l lr.fa.gz --hybrid -1 sr_1.fa.gz -2 sr_2.fa.gz -t 40 -o hybrid-nanophase-out  ## using Nanopore + Illumina reads
```
It should be finished in ~2.5 hours. The output folder/file structure should be like:
```
hybrid-nanophase-out/
├── 01-LongAssemblies
│   ├── assembly.fasta
│   ├── assembly_info.txt
│   └── flye.log
├── 02-LongBins
│   ├── BIN_REFINEMENT
│   │   ├── bin_refinement.log
│   │   ├── figures
│   │   ├── maxbin2-bins
│   │   │   ├── bin.001.fa
│   │   │   └── bin.002.fa
│   │   ├── maxbin2-bins.stats
│   │   ├── metabat2-bins
│   │   │   └── bin.1.fa
│   │   ├── metabat2-bins.stats
│   │   ├── metawrap_50_10_bins
│   │   │   ├── bin.1.fa
│   │   │   └── bin.2.fa
│   │   ├── metawrap_50_10_bins.contigs
│   │   └── metawrap_50_10_bins.stats
│   └── INITIAL_BINNING
│       ├── maxbin2
│       │   ├── bin.log
│       │   ├── bin.marker
│       │   ├── bin.marker_of_each_bin.tar.gz
│       │   ├── bin.noclass
│       │   ├── bin.summary
│       │   ├── bin.tooshort
│       │   ├── maxbin2_abun.txt
│       │   └── maxbin2-bins
│       ├── metabat2
│       │   ├── bin.log
│       │   ├── metabat2_abun.txt
│       │   └── metabat2-bins
│       └── tmp.abun.txt
└── 03-Polishing
    ├── Final-bins
    │   ├── bin.1.fasta
    │   └── bin.2.fasta
    ├── medaka
    │   ├── bin.1-medaka
    │   │   └── consensus.fasta
    │   ├── bin.2-medaka
    │   │   └── consensus.fasta
    │   └── medaka.polish.log
    ├── nanophase.ARGs.summary.txt
    ├── nanophase.hybrid.genome.summary
    ├── POLCA
    │   ├── POLCA-bins
    │   │   ├── bin.1-polca.fasta
    │   │   └── bin.2-polca.fasta
    │   └── polca.polish.log
    ├── Polypolish
    │   ├── bin.1-Polypolish
    │   │   └── bin.1-polypolish.fasta
    │   ├── bin.2-Polypolish
    │   │   └── bin.2-polypolish.fasta
    │   └── polypolish.polish.log
    └── Racon
        ├── bin.1
        │   └── bin.1-racon01.fasta
        ├── bin.2
        │   └── bin.2-racon01.fasta
        └── racon.polish.log

25 directories, 39 files
```
Final reconstructed MAGs could be found in `hybrid-nanophase-out/03-Polishing/Final-bins/` and the summary file of the reconstructed MAGs could be found in `hybrid-nanophase-out/03-Polishing/nanophase.hybrid.genome.summary`
```
ls hybrid-nanophase-out/03-Polishing/Final-bins/
bin.1.fasta  bin.2.fasta

cat hybrid-nanophase-out/03-Polishing/nanophase.hybrid.genome.summary
#BinID  Completeness    Contamination   Strain heterogeneity    GenomeSize(bp)  N_Contig        N50(bp) GC      IfCir.  GTDB-Taxa
bin.1   100.00  0.00    0.00    2028324 1       2028324 0.59294 Y       d__Bacteria;p__Actinobacteriota;c__Actinomycetia;o__Actinomycetales;f__Bifidobacteriaceae;g__Bifidobacterium;s__Bifidobacterium
bin.2   99.00   0.55    100.00  1889441 2       1827513 0.52311 N       d__Bacteria;p__Firmicutes;c__Bacilli;o__Lactobacillales;f__Lactobacillaceae;g__Limosilactobacillus;s__Limosilactobacillus
```
### Antobiotic Resistance Genes (ARGs) identification from the above reconstructed MAGs
`nanophase args` module still is in the active development stage at this time being. We hope to provide more versatile functions in the next release.
We use [SARG database](https://github.com/xinehc/args_oap/tree/main/src/args_oap/db) for the ARGs annotation, the output results were generated using `nanophase v=0.2.0`
```
conda activate nanophase ## if not in the nanophase env
nanophase args -i ont-nanophase-out/03-Polishing/Final-bins/ -x fasta -o nanophase.ARGs.summary.txt
```
It should be finished in ~10 mins and if ARGs were identified in the MAGs, then `nanophase.ARGs.summary.txt` could be found:
```
cat nanophase.ARGs.summary.txt
BinID_ContigID_OrfID    similarity      Type    Subtype HMM.category    Mechanism.group Mechanism.subgroup      Mechanism.subgroup2
bin.1_contig_3_55       86.347  mupirocin       mupirocin__Bifidobacteria intrinsic ileS conferring resistance to mupirocin     Bifidobacteria intrinsic ileS conferring resistance to mupirocin        Antibiotic target alteration
bin.2_contig_1_1235     99.638  bacitracin      bacitracin__bacA        bacA    Antibiotic target alteration    undecaprenyl pyrophosphate
```
