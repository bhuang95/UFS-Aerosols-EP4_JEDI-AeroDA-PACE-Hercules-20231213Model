#!/bin/bash
#SBATCH -n 1
#SBATCH -t 02:20:00
#SBATCH -p service
#SBATCH -A chem-var
#SBATCH -J aodhfx-201801
#SBATCH -D ./
#SBATCH -o ./hofx_diff.out
#SBATCH -e ./hofx_diff.out


# This jobs plots the AOD, HOFX and their difference in a 3X1 figure.
set -x 

#module use -a /contrib/anaconda/modulefiles
#module load anaconda/latest
module load miniconda3/24.3.0

codedir=$(pwd)
#topexpdir=/scratch2/BMC/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc
topexpdir=/work/noaa/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc/PACE-20231213Model/
ndate=/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-Reanl-Hercules-20231213Model/misc/ndate/ndate
#pyexec=plt_VIIRS_AOD_HOFX_DIFF_MultChans-2024032300-2024032400.py
pyexec=plt_VIIRS_AOD_HOFX_DIFF_MultChans-2024032300-2024032400-Keep0.py
#pyexec=plt_VIIRS_AOD_HOFX_DIFF_MultChans-2024032300-2024032400-relativeBias.py

cycst=2024032300 # Starting cycle
cyced=2024032300 # Ending cycle
	# All four cycles at 00/06/12/18Z has to be available at a certain day. Otherwise, it will crash/ 
	
# (if cycinc=24, set cycst and cyced as YYYYMMDD00)
cycinc=30
# (6 or 24 hours)

#freerunexp="FreeRun-1C192-0C192-201710"
#freerunexp="RET_EP4_FreeRun_NoSPE_YesSfcanl_v15_0dz0dp_1M_C96_202006"
#freerunexp="AeroReanl_EP4_FreeRun_NoSPE_YesSfcanl_v14_0dz0dp_1M_C96_201801"
	# Not necessary
aerodaexp="AeroDA_Chan_1_4_5_20240323"
#aerodaexp="AeroDA_Chan_4_20240323"
exps="${aerodaexp}"

for exp in ${exps}; do
    topplotdir=${topexpdir}/${exp}/diagplots/VIIRS_AOD_HOFX_DIFF
    if ( echo ${aerodaexp} | grep ${exp} ); then
        aeroda=True
        emean=False
        prefix=AeroDA_Chan_1_4_5
        #prefix=AeroDA_Chan_4
    elif ( echo ${freerunexp} | grep ${exp} ); then
        aeroda=False
        emean=False
        prefix=FreeRun
    else
	echo "Please deefine aeroda, emean, prefix accordingly for your exps"
    fi

    #datadir=${topexpdir}/${exp}/dr-data-backup
    datadir=${topexpdir}/${exp}/dr-data

    plotdir=${topplotdir}/${prefix}
    [[ ! -d ${plotdir} ]] && mkdir -p ${plotdir}

    cp ${pyexec} ${plotdir}/

    cd ${plotdir}/

    cyc=${cycst}
    while [ ${cyc} -le ${cyced} ]; do
        echo ${cyc}
        python ${pyexec} -c ${cyc} -i ${cycinc} -a ${aeroda} -m ${emean} -p ${prefix} -t ${datadir}
        ERR=$?
        [[ ${ERR} -ne 0 ]] && exit 100
        cyc=$(${ndate} ${cycinc} ${cyc})
    done
done
exit 0
