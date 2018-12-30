#!/bin/bash

#Copy paste the .xtc file, the starting tpr file and the .ndx (if present) into one folder and run the following commands in the terminal or run this script directly from the terminal

#concatenating all the trajectories that have run.

echo -en 0 "\n"10 "\n"20 "\n"30 "\n"40 "\n"50 "\n"60 "\n"70 "\n"80 "\n"90 "\n" | gmx trjcat -f *-1.xtc *-2.xtc *-3.xtc *-4.xtc *-5.xtc *-6.xtc *-7.xtc *-8.xtc *-9.xtc *-10.xtc -o 100ns.xtc -settime -overwrite -tu ns

# for removal of pbc errors.

echo -en 28 "\n"28 | gmx trjconv -f 100ns.xtc -s *MD-1.tpr -n *.ndx -o 100ns-pbc.pdb -pbc nojump -center -ur compact

echo -en 28 "\n"28 | gmx trjconv -f 100ns-pbc.pdb -s *MD-1.tpr -n *.ndx -o 100ns-pbc-fit.pdb -fit progressive

#Root-mean-square fluctuations - Average structure of the run protein - B-putty of the structure

echo 1 | gmx rmsf -f *-fit.pdb -s *.tpr -n *.ndx -o rmsf-per-residue.xvg -ox average-struct.pdb -oq bfactor.pdb -res

xmgrace rmsf-per-residue.xvg 

# RMSD with the backbone

echo 4 4 | gmx rms -f *-fit.pdb -s *.tpr -n *.ndx -o rmsd-bb.xvg -tu ns

xmgrace rmsd-bb.xvg

# RMSD with the average structure

echo 4 4 | gmx rms -f *-fit.pdb -s average-struct.pdb -o rmsd-bb-avg.xvg -tu ns

xmgrace rmsd-bb-avg.xvg

#concatenating the edr files

echo -en 0 "\n"10000 "\n"20000 "\n"30000 "\n"40000 "\n"50000 "\n"60000 "\n"70000 "\n"80000 "\n"90000 "\n" | gmx eneconv -f *1.edr *2.edr *3.edr *4.edr *5.edr *6.edr *7.edr *8.edr *9.edr *10.edr -o 100ns.edr -settime 

# For obtaining the potential of the given run

echo 10 0 | gmx energy -f 100ns.edr -o potential.xvg

xmgrace potential.xvg

#DSSP analyis of the run structure

echo 1 | gmx do_dssp -f *-fit.pdb -s *MD-1.tpr *.ndx -sc hr-sec.xvg -o hr-ss.xpm -dt 10

gmx xpm2ps -f hr-ss.xpm -o hr-ss.eps -size 4000

# Hydrogen bond analyis between the protein [1] and the ligand [12 - in my case]

echo -en 1 "\n"12 "\n" | gmx hbond -f *-fit.pdb -s *MD-1.tpr -n *.ndx -g Hr_noPBC-HB -num hbnum-Hr_noPBC -hbn hbindex-Hr_noPBC -hbm hbmap-Hr_noPBC

xmgrace hbnum-Hr_noPBC.xvg
