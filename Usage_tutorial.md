## A guide to verify NanoPhase installation: reconstructing reference-quality MAGs from the ZymoBIOMICS dataset (nanophase v0.2.3)
### ZymoBIOMICS dataset Download
Note: this dataset is generated from the [ZymoBIOMICS gut microbiome standard](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-022-01415-8#:~:text=The%20ZymoBIOMICS%20gut,microbiome%2Dstandard.) and used for feasibility evaluation in our [manuscript](https://doi.org/10.1186/s40168-022-01415-8)); in addition, `fastq-dump` in [SRA toolkit](https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit) is required.
```
fastq-dump SRR17913199
```

### Using only Nanopore long reads to reconstruct reference-quality MAGs
```
conda activate nanophase                                         ## if not in the nanophase env
nanophase meta -l SRR17913199.fastq -t 64 -o nanophase-out       ## using only Nanopore long reads 
```
It may take a while to finish. The output folder/file structure should be like:
```
nanophase-out/
├── 01-LongAssemblies
│   ├── assembly_graph.gfa
│   ├── assembly.fasta
│   ├── assembly_info.txt
│   └── flye.log
├── 02-LongBins
│   ├── INITIAL_BINNING
│   │   ├── metabat2
│   │   ├── tmp.abun.txt
│   │   ├── maxbin2
│   │   └── semibin
│   └── BIN_REFINEMENT
│       ├── maxbin2-bins
│       ├── maxbin2-bins.stats
│       ├── metabat2-bins
│       ├── metabat2-bins.stats
│       ├── metawrap_50_10_bins
│       ├── metawrap_50_10_bins.stats
│       ├── semibin-bins
│       ├── semibin-bins.stats
│       ├── figures
│       ├── bin_refinement.log
│       └── metawrap_50_10_bins.contigs
└── 03-Polishing
    ├── Racon
    │   ├── racon.polish.log
    │   ├── bin.1
    │   ├── bin.10
    │   ├── bin.11
    │   ├── bin.12
    │   ├── bin.2
    │   ├── bin.3
    │   ├── bin.4
    │   ├── bin.5
    │   ├── bin.6
    │   ├── bin.7
    │   ├── bin.8
    │   └── bin.9
    ├── medaka
    │   ├── bin.4-medaka
    │   ├── bin.10-medaka
    │   ├── bin.3-medaka
    │   ├── bin.7-medaka
    │   ├── bin.1-medaka
    │   ├── bin.12-medaka
    │   ├── bin.6-medaka
    │   ├── bin.2-medaka
    │   ├── bin.8-medaka
    │   ├── bin.5-medaka
    │   ├── bin.11-medaka
    │   ├── bin.9-medaka
    │   └── medaka.polish.log
    ├── checkm-result
    │   ├── bins
    │   ├── lineage.ms
    │   ├── checkm.log
    │   ├── checkm_results.tsv
    │   └── storage
    ├── gtdbtk-result
    │   ├── gtdbtk.warnings.log
    │   ├── gtdbtk.ar53.summary.tsv -> classify/gtdbtk.ar53.summary.tsv
    │   ├── align
    │   ├── classify
    │   ├── gtdbtk.bac120.summary.tsv -> classify/gtdbtk.bac120.summary.tsv
    │   ├── gtdbtk.json
    │   ├── gtdbtk.log
    │   └── identify
    ├── nanophase.ont.genome.summary
    └── Final-bins
        ├── bin.10.fasta
        ├── bin.11.fasta
        ├── bin.12.fasta
        ├── bin.1.fasta
        ├── bin.2.fasta
        ├── bin.3.fasta
        ├── bin.4.fasta
        ├── bin.5.fasta
        ├── bin.6.fasta
        ├── bin.7.fasta
        ├── bin.8.fasta
        └── bin.9.fasta

48 directories, 34 files
```
Final reconstructed MAGs could be found in `nanophase-out/03-Polishing/Final-bins/` and the summary file of the reconstructed MAGs could be found in `nanophase-out/03-Polishing/nanophase.ont.genome.summary`
```
ls nanophase-out/03-Polishing/Final-bins/
bin.10.fasta  bin.11.fasta  bin.12.fasta  bin.1.fasta  bin.2.fasta  bin.3.fasta  bin.4.fasta  bin.5.fasta  bin.6.fasta  bin.7.fasta  bin.8.fasta  bin.9.fasta

cat nanophase-out/03-Polishing/nanophase.ont.genome.summary 
#BinID  Completeness    Contamination   Strain heterogeneity    GenomeSize(bp)  N_Contig        N50(bp) GC      GTDB-Taxa
bin.1   100.00  0.00    0.00    2461381 2       2150631 0.26980 d__Bacteria;p__Fusobacteriota;c__Fusobacteriia;o__Fusobacteriales;f__Fusobacteriaceae;g__Fusobacterium;s__Fusobacterium animalis
bin.2   99.44   0.29    0.00    3460839 1       3460839 0.48731 d__Bacteria;p__Bacillota_A;c__Clostridia;o__Lachnospirales;f__Lachnospiraceae;g__Roseburia;s__Roseburia hominis
bin.3   99.18   0.55    100.00  1906542 3       1890918 0.52286 d__Bacteria;p__Bacillota;c__Bacilli;o__Lactobacillales;f__Lactobacillaceae;g__Limosilactobacillus;s__Limosilactobacillus fermentum
bin.4   95.88   0.00    0.00    2849782 2       2341158 0.55459 d__Bacteria;p__Verrucomicrobiota;c__Verrucomicrobiae;o__Verrucomicrobiales;f__Akkermansiaceae;g__Akkermansia;s__Akkermansia muciniphila
bin.5   100.00  0.00    0.00    2157911 1       2157911 0.38952 d__Bacteria;p__Bacillota_C;c__Negativicutes;o__Veillonellales;f__Veillonellaceae;g__Veillonella;s__Veillonella rogosae
bin.6   87.91   0.39    0.00    2522000 3       2083939 0.43694 d__Bacteria;p__Bacteroidota;c__Bacteroidia;o__Bacteroidales;f__Bacteroidaceae;g__Prevotella;s__Prevotella corporis
bin.7   99.16   0.00    0.00    2028285 1       2028285 0.59292 d__Bacteria;p__Actinomycetota;c__Actinomycetia;o__Actinomycetales;f__Bifidobacteriaceae;g__Bifidobacterium;s__Bifidobacterium adolescentis
bin.8   100.00  0.00    0.00    2911148 1       2911148 0.57806 d__Bacteria;p__Bacillota_A;c__Clostridia;o__Oscillospirales;f__Ruminococcaceae;g__Faecalibacterium;s__Faecalibacterium prausnitzii_E
bin.9   95.94   0.50    0.00    5191902 5       4733348 0.43263 d__Bacteria;p__Bacteroidota;c__Bacteroidia;o__Bacteroidales;f__Bacteroidaceae;g__Bacteroides;s__Bacteroides fragilis
bin.10  81.03   0.00    0.00    4065942 1       4065942 0.28625 d__Bacteria;p__Bacillota_A;c__Clostridia;o__Peptostreptococcales;f__Peptostreptococcaceae;g__Clostridioides;s__Clostridioides difficile
bin.11  98.03   0.97    80.00   4491398 26      302533  0.50954 d__Bacteria;p__Pseudomonadota;c__Gammaproteobacteria;o__Enterobacterales;f__Enterobacteriaceae;g__Escherichia;s__Escherichia coli
bin.12  58.04   0.00    0.00    1191563 44      34294   0.30992 d__Archaea;p__Methanobacteriota;c__Methanobacteria;o__Methanobacteriales;f__Methanobacteriaceae;g__Methanobrevibacter_A;s__Methanobrevibacter_A smithii
```
### If you had Illumina short reads as well, you may use hybrid strategy (Nanopore long reads + Illumina short reads) to reconstruct reference-quality MAGs
Note: since nanopore sequencing has been improved quite a lot, at this time being, short reads is not necessary; especially for long data generated from the Kit 14.
```
conda activate nanophase ## if not in the nanophase env
nanophase meta -l lr.fa.gz --hybrid -1 sr_1.fa.gz -2 sr_2.fa.gz -t 40 -o hybrid-nanophase-out  ## using Nanopore + Illumina reads
```


# The following tutorial is suitable for nanophase v0.2.2 due to the limited dataset provided
## A guide to verify NanoPhase installation: reconstructing reference-quality MAGs from an example dataset (nanophase v0.2.2)
#### Warning: since nanophase v0.2.3 ([semibin](https://github.com/BigDataBiology/SemiBin) as a new binner, which really improved genome reconstruction results a lot for complex environmental samples), it may encounter error issues when performing the binning process with only a few contigs. It should also be an issue when handling very simple long-read datasets, so in this way, I would suggest using nanophase v0.2.2: `mamba create -n nanophase-v0.2.2 -c nanophase nanophase=0.2.2 -y`. Sorry for that, we will try to fix this issue in the next release.
### [Example dataset](https://github.com/example-data/np-example) download
```
wget https://github.com/example-data/np-example/raw/main/np.test.tar && tar -xvf np.test.tar && rm -rf np.test.tar ## download the example data
```
Or it waits too long, you may use the following link as well
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
