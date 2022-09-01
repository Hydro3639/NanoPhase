#!/usr/bin/env python3
################################################################
# This script is from metawrap (https://github.com/bxlab/metaWRAP/blob/master/bin/metawrap-scripts/)
# I changed it a little for python3 compatibility
###############################################################

import sys
import textwrap

dic={}
tmp_contig=""
for line in open(sys.argv[1]):
	if line[0]==">": 
		if tmp_contig!="":
			dic[name]=tmp_contig
			tmp_contig=""
		name=line.strip()
	else: tmp_contig+=line.strip()	
dic[name]=tmp_contig


for k in sorted(dic, key=lambda k: len(dic[k]), reverse=True):
        print(k)
	print(textwrap.fill(dic[k], 100, break_on_hyphens = False))
