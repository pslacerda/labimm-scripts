#!/bin/env python
# -*- encoding: utf-8 -*-

import sys

bases = "ARG", "HIS", "LYS"
acids = "ASP", "GLU"

ph, inf = float(sys.argv[1]), open(sys.argv[2])

for line in inf:
    name, _, _, pka, _ = line.split()
    pka = float(pka)
        
    if name not in acids + bases:
        prot = None
    elif ph == pka:
        prot = "pKa = pH"
    elif name in acids:
        prot = 0 if pka < ph else 1
    elif name in bases and name != "HIS":
        prot = 1 if pka < ph else 0
    elif name == "HIS":
        prot = 2 if pka < ph else "Nδ1 or Nε2"

    print("%s  %s" % (line.strip(), prot))
