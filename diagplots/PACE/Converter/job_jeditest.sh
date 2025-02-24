#!/bin/bash
#SBATCH -n 6
#SBATCH -A wrf-chem
#SBATCH -q debug
#SBATCH -p hercules
#SBATCH -t 00:10:00
#SBATCH -o jedi-test.log
#SBATCH -e jedi-test.log


JEDIBuild=/work/noaa/gsienkf/bhuang/expCodes/JEDI/jedi-bundle-Hercules/PR/MapTest/jedi-bundle-20240830/BuildIntel
JEDIEXEC=${JEDIBuild}/bin/fv3jedi_var.x

source ${JEDIBuild}/../../jedi_module_base.hercules.spack-stack-1.7.0.intel.sh

cd ${JEDIBuild}/fv3-jedi/test
/opt/slurm/bin/srun -n 6 ${JEDIEXEC} testinput/hyb-fgat_gfs_aero_pace.yaml
