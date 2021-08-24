#!/bin/bash

NPROC_O=16

qsub -cwd -S /bin/bash -q normal.q@hercules1 -N mousetrap -o data/mousetrap.out -e data/mousetrap.err -pe make $NPROC_O -v NPROC=$NPROC_O scripts/job.sh &

