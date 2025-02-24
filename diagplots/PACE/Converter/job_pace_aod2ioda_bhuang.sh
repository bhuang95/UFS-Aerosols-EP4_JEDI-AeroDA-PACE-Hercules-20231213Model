#!/bin/bash

set -x
module purge
TMPDIR=/work/noaa/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc/AeroReanl/TestData/JEDI/IODA/internal-20241210/TestScripts/PACEAODCONVERTER-Bo/tmp
MYDIR=/work/noaa/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc/AeroReanl/TestData/JEDI/IODA/internal-20241210
PACEDIR=/work/noaa/zrtrr/efaber/test_data_pace/NOAA_PACE
MASKOPT=True
THINOPT=True
MAXOBS=2000
CYCST=2024032300
CYCED=2024032400
CYCINC=6
NDATE=/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-Reanl-Hercules-20231213Model/misc/ndate/ndate

PYEXEC=pace_aod2ioda_bhuang.py
source ${MYDIR}/jedi_module_base.hercules.spack-stack-1.7.0.intel.sh
export PYTHONPATH=$PYTHONPATH:${MYDIR}/BuildIntel/lib/python3.10/
export PYTHONPATH=$PYTHONPATH:${MYDIR}/ioda-bundle/iodaconv/src

#python pace_aod2ioda_bhuang.py -i Pace_L2_Merged_2024083.0342.nc -o NASA_PACE_OCI_AOD_2024032306.nc -k True -t True -m 2000
#python pace_aod2ioda_bhuang.py -i Pace_L2_Merged_2024083.0402.nc -o NASA_PACE_OCI_AOD_2024032306.nc -k True -t True -m 2000
#exit

#PYINPUTS="Pace_L2_Merged_2024083.0039.nc Pace_L2_Merged_2024083.2312.nc"

CYC=${CYCST}
mkdir -p ${TMPDIR}
cp ${PYEXEC} ${TMPDIR}
cd ${TMPDIR}
while [ ${CYC} -le ${CYCED} ]; do
    OUTFILE="NASA_PACE_OCI_AOD_${CYC}.nc"
    WINBEG=$(${NDATE} -3 ${CYC})
    WINEND=$(${NDATE} +3 ${CYC})
    WINBEG_HR=${WINBEG:8:2}
    WINEND_HR=${WINEND:8:2}
    CYC_JDAY=${CYC:0:4}$(date -d ${CYC:0:8} +%j)
    WINBEG_JDAY=${WINBEG:0:4}$(date -d ${WINBEG:0:8} +%j)
    WINEND_JDAY=${WINEND:0:4}$(date -d ${WINEND:0:8} +%j)
    if [ ${WINBEG_JDAY} -ne ${CYC_JDAY} ]; then
        allfiles=$(ls ${PACEDIR}/Pace_L2_Merged_${WINBEG_JDAY}.????.nc ${PACEDIR}/Pace_L2_Merged_${CYC_JDAY}.????.nc  | sort -u)
    else
        allfiles=$(ls ${PACEDIR}/Pace_L2_Merged_${CYC_JDAY}.????.nc | sort -u)
    fi
    [[ -f files.input ]] && rm -rf files.input
    WINBEG_YDHM=${WINBEG_JDAY}${WINBEG_HR}00
    WINEND_YDHM=${WINEND_JDAY}${WINEND_HR}00
    for f in ${allfiles}; do
        basef=`basename ${f}`
        fdate=${basef:15:7}${basef:23:4}
        if [ ${fdate} -ge ${WINBEG_YDHM} ] && [ ${fdate} -lt ${WINEND_YDHM} ]; then
            ln -sf ${f} ./${basef}
	    echo ${basef} >> files.input
        fi
    done
    PYINPUTS=$(cat files.input)
python ${PYEXEC} -i ${PYINPUTS} -o ${OUTFILE} -k ${MASKOPT} -t ${THINOPT} -m ${MAXOBS}
ERR=$?
  if [ ${ERR} -ne 0 ]; then
      echo "PACE converter failed at ${CYC} and exit"
      exit 100
  else
      echo "PACE converter succeed at ${CYC}"
      rm -rf Pace_L2_Merged_???????.????.nc
      mkdir -p ${CYC}
      mv ${OUTFILE} ${CYC}/
  fi
  CYC=$(${NDATE} ${CYCINC} ${CYC})
done
