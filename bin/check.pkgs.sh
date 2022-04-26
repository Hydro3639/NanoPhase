#!/bin/bash
## usage: ./check.pkgs.sh


## This script is used for package availability checking
echo "===========================================================================================================
Check software availability and locations" ## should check unavailable: if xxx then echo ""; exit 1
rm -rf .package.installed 2>/dev/null && rm -rf .package.not.installed 2>/dev/null

echo -e "NanoPhase\nflye\nmetabat2\nrun_MaxBin.pl\nmetawrap\ncheckm\nracon\nmedaka\npolypolish\npolca.sh\nbwa\nseqtk\nminimap2\nstats.sh\nparallel\nperl\nsamtools" | while read package; do
if [[ "$(command -v $package)" ]]; then
	echo -e "$package\t`which $package`" | sed -e 's/polca.sh/POLCA/1' -e 's/run_MaxBin.pl/maxbin2/1' -e 's/stats.sh/BBMap/g' | awk '{printf "%-20s %s\n", $1,$2}' >> .package.installed
else
	echo "$package" | sed -e 's/polca.sh/POLCA/1' -e 's/run_MaxBin.pl/maxbin2/1' -e 's/stats.sh/BBMap/g' | awk '{printf "%-20s %s\n", $1,$2}' >> .package.not.installed
fi ; done

if [[ -s .package.installed ]]; then
	echo "===========================================================================================================
	The following packages have been found  @`date "+%Y/%m/%d -- %H:%M:%S"`"
	cat .package.installed | sed -e '1i#package\tlocation' | awk '{printf "%-20s %s\n", $1,$2}'
	echo "==========================================================================================================="
else
	echo "No required package has been found in the environment, please install, terminating..."
	exit 1
fi

if [[ ! -s .package.not.installed ]]; then
	echo "All required packages have been found in the environment"
	path_check=`cat .package.installed | awk '{printf "%-20s %s\n", $1,$2}' | awk '{print $2}' | while read path; do dirname $path; done | awk '!a[$1]++' | wc -l`
	if [[ $path_check -gt 1 ]]; then
		echo "Warning: [`cat .package.installed | awk '{printf "%-20s %s\n", $1,$2}' | awk '{print $2}' | while read path; do dirname $path; done | grep -v 'NanoPhase\/bin' | while read line; do grep -w $line .package.installed; done | awk '!a[$1]++ {print $1}' | tr '\n' ' ' | sed -e 's/ $//g'`] has not been installed in the [NanoPhase] env. Strongly recommend intalling all packages in the NanoPhase env, or it may result in a failure"
		rm -rf .package.installed
	else
		rm -rf .package.installed 2>/dev/null
	fi
else
	echo "Error: [`cat .package.not.installed | sed -e 's/ //g' | tr '\n' ' ' | sed -e 's/ $//g'`] cannot be found in the environment, please install. Now terminating..."
	rm -rf .package.not.installed
fi


