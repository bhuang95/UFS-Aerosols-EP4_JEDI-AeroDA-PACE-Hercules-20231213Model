#!/bin/bash
#SBATCH -J pltEmis
#SBATCH -A wrf-chem
#SBATCH -o ./pltPACEAOD.out
#SBATCH -e ./pltPACEAOD.out 
#SBATCH -n 1
#SBATCH -p service
#SBATCH -t 05:30:00

set -x
#module use -a /contrib/anaconda/modulefiles
#module load anaconda/latest
#module load python/3.10.8

#JEDIMOD=/work/noaa/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc/AeroReanl/TestData/JEDI/IODA/internal-20241210/jedi_module_base.hercules.spack-stack-1.7.0.intel.sh

module load miniconda3/24.3.0
#module load  miniconda2/4.7.12.1
#python plt_PACE_AOD_IODAV3_multiChans_00Z200Z.py
python plt_PACE_AOD_IODAV3_multiChans_00Z200Z_Keep0.py
exit

curdir=$(pwd)
plotdir=/scratch2/BMC/gsd-fv3-dev/MAPP_2018/bhuang/JEDI-2020/JEDI-FV3/conferencePlots/2024AMS/VIIRSAOD

cp ${curdir}/plt_VIIRS_AOD_IODAV3_6HOUR.py ${plotdir}

cd ${plotdir}
python plt_VIIRS_AOD_IODAV3_6HOUR.py
