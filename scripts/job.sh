#!/bin/bash

NPROC=4

mpiexec -np ${NPROC} ./main.x 
