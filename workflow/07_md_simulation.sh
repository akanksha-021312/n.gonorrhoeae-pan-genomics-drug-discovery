#!/bin/bash

# Generate topology
gmx pdb2gmx -f protein.pdb -o processed.gro -water spc -ff oplsaa

# Define box
gmx editconf -f processed.gro -o newbox.gro -c -d 1.0 -bt triclinic

# Solvate
gmx solvate -cp newbox.gro -cs spc216.gro -o solv.gro -p topol.top

# Adding ions
gmx grompp -f inputs/ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr

gmx genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

# Energy minimization
gmx grompp -f inputs/minim.mdp -c 1AKI_solv_ions.gro -p topol.top -o em.tpr

gmx mdrun -deffnm em

# Equilibration
gmx grompp -f inputs/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr

gmx mdrun -deffnm nvt

gmx grompp -f inputs/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr

gmx mdrun -deffnm npt


# Production MD (100 ns)
gmx grompp -f inputs/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_10.tpr

gmx mdrun -deffnm md_0_100ns