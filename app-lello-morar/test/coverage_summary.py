#!/usr/bin/env python3
"""Resumo de cobertura por arquivo de um lcov.

Uso: python3 test/coverage_summary.py coverage/<arquivo>.lcov.info lib/feature/<feature>
"""
import collections, sys
lcov = sys.argv[1]
prefix = sys.argv[2] if len(sys.argv) > 2 else 'lib/'
tot = collections.Counter(); hit = collections.Counter(); f = None
for line in open(lcov):
    line = line.strip()
    if line.startswith('SF:'): f = line[3:]
    elif line.startswith('LF:'): tot[f] += int(line[3:])
    elif line.startswith('LH:'): hit[f] += int(line[3:])
files = [p for p in tot if p.startswith(prefix)]
T = sum(tot[p] for p in files); H = sum(hit[p] for p in files)
print(f"{prefix}: {H}/{T} = {100*H/T if T else 0:.1f}%")
for p in sorted(files, key=lambda p: hit[p]-tot[p]):
    if tot[p]-hit[p] > 0:
        print(f"  {tot[p]-hit[p]:5d} faltam  ({hit[p]}/{tot[p]})  {p}")
