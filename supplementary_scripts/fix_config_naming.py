#!/usr/bin/env python3
################################################################
# This script is from metawrap (https://github.com/bxlab/metaWRAP/blob/master/bin/metawrap-scripts/)
# I changed it a little for python3 compatibility
###############################################################

import sys

for line in open(sys.argv[1]):
        if line[0]==">":
                for c in line:
                        if c=="=": c="_"
                        sys.stdout.write(c)
        else:
                print(line.rstrip())
