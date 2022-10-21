#!/usr/bin/env bash
## nanophase (plasmid) is designed for identifying the potential plasmids from the reconstructed MAGs
set -eo pipefail

###### Usage ######
show_help(){
cat << EOF
`np_version`

arguments:
        -i, --input             input directory containing genome files
        -x, --extension         genomes extension [default: fasta]
        -o, --output            output file name [default: nanophase.pls.summary.txt]
	-d, --database		plasmid database location [default: PLSDB location]
        -s, --identity	        the identity cutoff with the plasmid database (%) [default: 90]
        -c, --coverage          the coverage cutoff of alignment fraction (%) [default: 50]
	-t, --threads           number of threads [default: 16]
        -h, --help              print help information and exit
        -v, --version           show version number and exit

example usage:
        nanophase plasmid -i Final-bins -x fasta -o nanophase.pls.summary.txt		## Plasmids identification
EOF
}

## default parameters
OPTIND=1 # Reset in case getopts has been used previously in the shell
CRTDIR=$(cd `dirname $0`; pwd)

anno_fast="no"
bin_suffix=fasta
uniq_folder=`date +%s`
plsdb_path="$PLSDB_PATH"
N_threads="16"
#input_folder="Final-bins"
output_file="nanophase.pls.summary.txt"
identity="90"
coverage="50"
base_dir=$(cd `dirname $0`; pwd)
np_version(){ echo -e `$base_dir/nanophase -v`; }

## log file
datetime.CHECK(){ Date=`date "+%Y-%m-%d %H:%M:%S"`; echo [$Date] CHECK:; }
#datetime.TASK(){ Date=`date "+%Y-%m-%d %H:%M:%S"`; echo [$Date] TASK:; }
datetime.INFO(){ Date=`date "+%Y-%m-%d %H:%M:%S"`; echo [$Date] INFO:; }
datetime.WARNING(){ Date=`date "+%Y-%m-%d %H:%M:%S"`; echo [$Date] WARNING:; }
datetime.ERROR(){ Date=`date "+%Y-%m-%d %H:%M:%S"`; echo [$Date] ERROR:; }
datetime.DONE(){ Date=`date "+%Y-%m-%d %H:%M:%S"`; echo [$Date] DONE:; }

## call command to tmp_cmd
tmp_cmd=`echo -e "\nCommand line: $CRTDIR/nanophase plasmid $*"`
##
params="$(getopt -o hi:t:s:c:o:x:d:v --long help,input:,threads:,identity:,coverage:,out:,extension:,database:,version -- "$@")"
if [[ $? -gt 0 ]]; then show_help; exit 1; fi
if [[ $# == 0 ]]; then show_help; exit 1; fi

#eval set -- "$params"
#unset params

while true; do
        case "$1" in
                -t | --threads) N_threads=$2; shift 2;;
                -i | --input) input_folder=$2; shift 2;;
                -o | --out) output_file=$2; shift 2;;
                -d | --database) plsdb_path=$2; shift 2;;
		-x | --extension) bin_suffix=$2; shift 2;;
                -s | --identity) identity=$2; shift 2;;
                -c | --coverage) coverage=$2; shift 2;;
		-v | --version) np_version; exit 0; shift 1;;
		-h | --help) show_help; exit 0; shift 1;;
                --) show_help; exit 0; shift; break ;;
                *) break;;
        esac
done
###

## package check (minimap2)
package_check(){
### Software availability
echo  "`datetime.CHECK` Check software availability and locations"
rm -rf .package.installed 2>/dev/null && rm -rf .package.not.installed 2>/dev/null

## all required packages
echo -e "nanophase\nminimap2" | while read package; do
if [[ "$(command -v $package)" ]]; then
        echo -e "$package\t`which $package`" | awk '{printf "%-20s %s\n", $1,$2}' >> .package.installed
else
        echo "$package" | awk '{printf "%-20s %s\n", $1,$2}' >> .package.not.installed
fi ; done

if [[ -s .package.installed ]]; then
        echo "`datetime.INFO` The following packages have been found. If the above certain packages integrated into nanophase were used in your investigation, please give them credit as well :)"
        cat .package.installed | sed -e '1i#package\tlocation' | awk '{printf "%-20s %s\n", $1,$2}'
else
        echo "`datetime.ERROR` No required package has been found in the environment, please install, terminating..."
        exit 1
fi

if [[ ! -s .package.not.installed ]]; then
        echo "All required packages have been found in the environment"
        path_check=`cat .package.installed | awk '{printf "%-20s %s\n", $1,$2}' | awk '{print $2}' | while read path; do dirname $path; done | awk '!a[$1]++' | wc -l`
        if [[ $path_check -gt 1 ]]; then
                echo "Warning: [`cat .package.installed | awk '{printf "%-20s %s\n", $1,$2}' | awk '{print $2}' | while read path; do dirname $path; done | grep -v 'nanophase\/bin' | while read line; do grep -w $line .package.installed; done | awk '!a[$1]++ {print $1}' | tr '\n' ' ' | sed -e 's/ $//g'`] has not been installed in the [nanophase] env. Strongly recommend installing all packages in the nanophase env, or it may result in a failure"
                rm -rf .package.installed
        else
                rm -rf .package.installed 2>/dev/null
        fi
else
        echo "`datetime.ERROR` [`cat .package.not.installed | sed -e 's/ //g' | tr '\n' ' ' | sed -e 's/ $//g'`] cannot be found in the environment
, plase install. Now terminating..."
        rm -rf .package.not.installed
        exit 1
fi
}
## End of package check

## PLSDB database check
db_check(){
echo "`datetime.CHECK` Check plasmid databse availability and locations"
if [[ -s $PLSDB_PATH ]]; then
	echo "`datetime.INFO` Plasmid database was found in $PLSDB_PATH"
	plsdb_name=`ls $PLSDB_PATH | awk -F"/" '{print $NF}'`
	if [[ $plsdb_name == "plsdb.fna" ]]; then
		echo "`datetime.INFO` Seems PLSDB (v.2021_06_23_v2; Galata, Valentina, et al. 2019) is used as the database"
	else
		echo "`datetime.INFO` Seems the default database was not used, please make sure it has the same format with PLSDB"
	fi
else
	echo "`datetime.ERROR` Cannot find the plasmid database, make sure you have one, terminating..."
	exit 1
fi
}
## End of database check

####################
## start to run
echo "`datetime.INFO` nanophase (plasmid) starts"
echo `datetime.INFO` $tmp_cmd
package_check && db_check
####################

## check input MAGs
if [[ -d $input_folder ]]; then
        if [[ `ls $input_folder/*${bin_suffix} 2>/dev/null | wc -l` -gt 0 ]]; then
                if [[ $bin_suffix == fasta ]]; then
                        num_bins=`ls $input_folder/*fasta | wc -l`
                elif [[ $bin_suffix == fa ]]; then
                        num_bins=`ls $input_folder/*fa | wc -l`
                elif [[ $bin_suffix == fna ]]; then
                        num_bins=`ls $input_folder/*fna | wc -l`
                fi
                echo "`datetime.CHECK` $num_bins MAGs were found in the folder of $input_folder"
        else
                echo "`datetime.ERROR` No MAGs could be found in the folder of $input_folder, terminating..."
        fi
else
        echo "`datetime.ERROR` Cannot found the folder $input_folder, terminating..."
        exit 1; >&2
fi
## End of check input MAGs

## define output 
rp_input_folder=`realpath $input_folder`

mkdir -p $rp_input_folder/tmp-pls-$uniq_folder
## run two commands with different cutoff will cause error
#if [[ -d $rp_input_folder/tmp-pls-* ]]; then
#        rm -rf $rp_input_folder/tmp-pls-* && mkdir $rp_input_folder/tmp-pls-$uniq_folder
#else
#        mkdir -p $rp_input_folder/tmp-pls-$uniq_folder
#fi

##
echo "`datetime.INFO` Sequence alignment to plasmid database (be patient)"
## combine (all) MAGs
mkdir $rp_input_folder/tmp-pls-$uniq_folder/.tmp-MAG && ls $rp_input_folder/*${bin_suffix} | xargs -P $N_threads -I {} cp {} $rp_input_folder/tmp-pls-$uniq_folder/.tmp-MAG
ls $rp_input_folder/tmp-pls-$uniq_folder/.tmp-MAG/*${bin_suffix} | awk -F"/" '{print $NF}' | sed -e 's/.'${bin_suffix}'//g' | xargs -P $N_threads -I {} sed -i 's/^>/>'{}#######'/g' $rp_input_folder/tmp-pls-$uniq_folder/.tmp-MAG/{}.${bin_suffix}
cat $rp_input_folder/tmp-pls-$uniq_folder/.tmp-MAG/*.${bin_suffix} >$rp_input_folder/tmp-pls-$uniq_folder/combined.fasta && rm -rf $rp_input_folder/tmp-pls-$uniq_folder/.tmp-MAG

## define paras in awk
dsim=`awk -v sim="$identity" 'BEGIN{printf"%.2f\n", 1-sim/100}'`
cov=`awk -v c="$coverage" 'BEGIN{printf"%.2f\n", c/100}'`

## base alignment, more accurate but is much slower
#minimap2 -c -x asm20 -t $N_threads --secondary=no $PLSDB_PATH $rp_input_folder/tmp-pls-$uniq_folder/combined.fasta > $rp_input_folder/tmp-pls-$uniq_folder/tmp.paf 2>/dev/null; awk '!a[$1]++' $rp_input_folder/tmp-pls-$uniq_folder/tmp.paf | awk -F'[:\t]' -v awk_dism="$dsim" -v awk_cov="$cov" '($4-$3+1)/$2 >=awk_cov && $39<=awk_dism {printf("%s\t%d\t%s\t%0.2f\t%0.2f\n",$1,$2,$6,(1-$39)*100,$10/$11*100)}' | while read line1 line2 line3 line4 line5; do paste <(echo $line1 $line2 $line4 $line5) <(grep -w $line3 $PLSDB_PATH | sed -e 's/^>//g'); done > $rp_input_folder/tmp-pls-$uniq_folder/tmp.pls.result

minimap2 -c -x asm20 -t $N_threads --secondary=no $PLSDB_PATH $rp_input_folder/tmp-pls-$uniq_folder/combined.fasta > $rp_input_folder/tmp-pls-$uniq_folder/tmp.paf 2>/dev/null; awk '!a[$1]++' $rp_input_folder/tmp-pls-$uniq_folder/tmp.paf | awk -F'[:\t]' -v awk_dism="$dsim" -v awk_cov="$cov" '($4-$3+1)/$2 >=awk_cov && $39<=awk_dism {printf("%s\t%d\t%s\t%0.2f\n",$1,$2,$6,(1-$39)*100)}' | while read line1 line2 line3 line4 line5; do paste <(echo $line1 $line2 $line4 $line5) <(grep -w $line3 $PLSDB_PATH | cut -d" " -f2-100); done > $rp_input_folder/tmp-pls-$uniq_folder/tmp.pls.result

echo "`datetime.INFO` Summarize the result"
cat $rp_input_folder/tmp-pls-$uniq_folder/tmp.pls.result | sed -e 's/#######/\t/g' | sort -k2n | cat <(echo -e "#BinID\tContigID\tContig_Length(bp)\tIdentity(%)\tPlasmid_annotation") - >$output_file

if [[ ! -s $output_file ]]; then
	echo "`datetime.ERROR` Summarize the result failed, terminating..."
	rm -rf $rp_input_folder/tmp-pls-$uniq_folder
	exit 1
fi

if [[ `tail -n+2 $output_file | wc -l` -gt 1 ]]; then
        echo "`datetime.DONE` Plasmids identifiation from MAGs finished"
        rm -rf $rp_input_folder/tmp-pls-$uniq_folder
elif [[ `cat $output_file | wc -l` == 1 ]]; then
        echo "`datetime.DONE` Plasmids identifiation from MAGs finished, but no plasmid was identified. Maybe try to lower the screening criteria (but be cautious with the new results)"
        rm -rf $rp_input_folder/tmp-pls-$uniq_folder && rm -rf $output_file
fi
echo -e "`datetime.DONE` nanophase (plasmid) finished and have a nice day!\n"

