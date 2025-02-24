#!/bin/bash

set -x

RORUNCMD="/apps/contrib/rocoto/1.3.6/bin/rocotorun"
XMLDIR="/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-PACE-Hercules-20231213Model/dr-work-mpi/xmlFiles"
DBDIR="/work/noaa/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc/PACE-20231213Model/xmlDB/"

EXPS="
AeroDA_Chan_4_20240323_Diag
AeroDA_Chan_1_4_5_20240323_Diag
"   
#AeroDA_Chan_4_20240323
#AeroDA_Chan_1_4_5_20240323
#AeroDA_Chan_1_4_5_20240323
for EXP in ${EXPS}; do
    echo "${RORUNCMD} -w ${XMLDIR}/${EXP}.xml -d ${DBDIR}/${EXP}.db"
    ${RORUNCMD} -w ${XMLDIR}/${EXP}.xml -d ${DBDIR}/${EXP}.db
done



hh=$(date +%H)
#mm=$(date +%m)
#if [ "${mm}" = "00" ]; then
evenhrs="00 02 04 06 08 10 12 14 16 18 20 22"
oddhrs="01 03 05 07 09 11 13 15 17 19 21 23"
for hr in ${evenhrs}; do
if [ "${hh}" = "${hr}" ]; then
/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-PACE-Hercules-20231213Model/dr-work-mpi/xmlFiles/job_rcml_failed_gdasefcs_resubmit.sh
fi
done
for hr in ${oddhrs}; do
if [ "${hh}" = "${hr}" ]; then
/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-PACE-Hercules-20231213Model/dr-work-mpi/xmlFiles/job_rcml_failed_gdasefcs.sh
fi
done
#fi
