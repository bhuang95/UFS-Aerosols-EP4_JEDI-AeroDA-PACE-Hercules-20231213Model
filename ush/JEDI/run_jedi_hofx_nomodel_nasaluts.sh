#!/bin/bash
set -x

#NDATE=${NDATE:-"/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-Reanl-Hercules/misc/ndate/ndate"}
NDATE=${HOMEgfs}/misc/ndate/ndate
JEDIDIR=${HOMEjedi:-"$HOMEgfs/sorc/jedi.fd/"}
DATA=${DATA:-"$pwd/analysis.$$"}
ROTDIR=${ROTDIR:-"/scratch1/BMC/gsd-fv3-dev/MAPP_2018/bhuang/JEDI-2020/JEDI-FV3/expRuns/aero_c96_jedi3densvar/dr-data/"}
OBSDIR_NRT=${OBSDIR_NRT:-"MissingOBSDIR_NRT"}
AODTYPE=${AODTYPE:-"MissingAODTYPE"}
AODCHANS_HOFX=${AODCHANS_HOFX:-"MissingAODCHANS_HOFX"}
RSTDIR=${RSTDIR:-"MissingRSTDIR"}
TRCR=${TRCR:-"MissingTRCR"}
HOFXDIR=${HOFXDIR:-"MissingHOFXDIR"}
ANLTIME=${CDATE:-"2017100100"}
STARTWIN=$($NDATE -3 $CDATE)
CASE=${CASE:-"C384"} # no lower case
LEVS=${LEVS:-"128"}
NCORES=${NCORES:-"6"}
LAYOUT=${LAYOUT:-"1,1"}
IO_LAYOUT=${IO_LAYOUT:-"1,1"}

CASEC=$(echo ${CASE} |cut -c2-5)
NPX=$((CASEC+1))
NPY=$((CASEC+1))
NPZ=$((LEVS-1))
FIELDMETADIR=${JEDIDIR}/fv3-jedi/test/Data/fieldmetadata/
FV3DIR=${JEDIDIR}/fv3-jedi/test/Data/fv3files/
#CRTMFIX=${HOMEgfs}/fix/jedi_crtm_fix_20200413/CRTM_fix/Little_Endian/
CRTMFIX=${JEDIDIR}/fv3-jedi/test/Data/crtm
JEDIEXE=${JEDIDIR}/bin/fv3jedi_hofx_nomodel.x

# Define some aliases
NCP="/bin/cp -r"
NRM="/bin/rm -rf"
NMV="/bin/mv -f"
NLN="/bin/ln -sf"

# set date format
AYY=$(echo ${ANLTIME} | cut -c1-4)
AMM=$(echo ${ANLTIME} | cut -c5-6)
ADD=$(echo ${ANLTIME} | cut -c7-8)
AHH=$(echo ${ANLTIME} | cut -c9-10)
ANLTIMEFMT=${AYY}-${AMM}-${ADD}T${AHH}:00:00Z

SYY=$(echo ${STARTWIN} | cut -c1-4)
SMM=$(echo ${STARTWIN} | cut -c5-6)
SDD=$(echo ${STARTWIN} | cut -c7-8)
SHH=$(echo ${STARTWIN} | cut -c9-10)
STWINFMT=${SYY}-${SMM}-${SDD}T${SHH}:00:00Z


cd ${DATA}
# Link fv3 nemelist files
DATAINPUT=${DATA}/INPUT
[[ -d ${DATAINPUT} ]] && ${NRM} ${DATAINPUT}
mkdir -p ${DATAINPUT}
${NCP} ${FV3DIR}/fmsmpp.nml 		${DATA}/fmsmpp.nml
${NCP} ${FV3DIR}/field_table_gfdl 	${DATA}/field_table_gfdl
${NCP} ${FV3DIR}/akbk${NPZ}.nc4 		${DATAINPUT}/akbk.nc
${NCP} ${FIELDMETADIR}/ufs-aerosol.yaml ${DATA}/ufs-aerosol.yaml

# Link crtm files (only for VIIRS and MODIS)
mkdir -p ${DATA}/CRTM/
LUTS="AerosolCoeff.bin CloudCoeff.bin  
      v.viirs-m_npp.SpcCoeff.bin v.viirs-m_npp.TauCoeff.bin 
      v.modis_terra.SpcCoeff.bin  v.modis_terra.TauCoeff.bin 
      v.modis_aqua.SpcCoeff.bin v.modis_aqua.TauCoeff.bin"

for LUT in ${LUTS}; do
    ${NLN} ${CRTMFIX}/${LUT} ${DATA}/CRTM/${LUT}
done

LUTS=`ls ${CRTMFIX}/NPOESS.* | awk -F "/" '{print $NF}'`
for LUT in ${LUTS}; do
    ${NLN} ${CRTMFIX}/${LUT} ${DATA}/CRTM/${LUT}
done

LUTS=`ls ${CRTMFIX}/USGS.* | awk -F "/" '{print $NF}'`
for LUT in ${LUTS}; do
    ${NLN} ${CRTMFIX}/${LUT} ${DATA}/CRTM/${LUT}
done

LUTS=`ls ${CRTMFIX}/FASTEM6.* | awk -F "/" '{print $NF}'`
for LUT in ${LUTS}; do
    ${NLN} ${CRTMFIX}/${LUT} ${DATA}/CRTM/${LUT}
done

# Link NASA look-up tables
${NLN} ${JEDIDIR}/geos-aero/test/testinput/geosaod_pace.rc ${DATA}/geosaod_pace.rc
${NLN} ${JEDIDIR}/geos-aero/test/testinput/Chem_MieRegistry.rc ${DATA}/Chem_Registry.rc
${NLN} ${JEDIDIR}/geos-aero/test/Data ${DATA}/

#if [ "${AODTYPE}" == *"AERONET"* ]; then
if ( echo ${AODTYPE} | grep -q "AERONET" ); then
    ${NLN} ${JEDIDIR}/geos-aero/test/testinput/geosaod_aeronet.rc ${DATA}/geosaod_aeronet.rc
fi

# Link observations (only for VIIRS or MODIS)
OBSTIME=${ANLTIME}
#if [ "${AODTYPE}" == "NOAA_VIIRS" ]; then
if ( echo ${AODTYPE} | grep -q "NOAA_VIIRS" ); then
    OBSIN=${OBSDIR_NRT}/${OBSTIME}/${AODTYPE}_AOD_npp.${OBSTIME}.iodav3.nc
    #OBSIN1=${OBSDIR_NRT}/${OBSTIME}/${AODTYPE}_AOD_j01.${OBSTIME}.iodav3.nc
    SENSORID=v.viirs-m_npp
    #SENSORID1=v.viirs-m_npp
    OBSOUT=aod_viirs_npp_obs_${OBSTIME}.nc4
    #OBSOUT1=aod_viirs_j01_obs_${OBSTIME}.nc4
    HOFXOUT=${AODTYPE}_npp_obs_hofx_3dvar_LUTs_${TRCR}_${OBSTIME}.nc4
    #HOFXOUT1=${AODTYPE}_j01_obs_hofx_3dvar_LUTs_${TRCR}_${OBSTIME}.nc4
    ${NLN} ${OBSIN} ${DATAINPUT}/${OBSOUT}
    #${NLN} ${OBSIN1} ${DATAINPUT}/${OBSOUT1}
elif ( echo ${AODTYPE} | grep -q "NASA_PACE_OCI" ); then
    OBSIN=${OBSDIR_NRT}/${OBSTIME}/${AODTYPE}_AOD_${OBSTIME}.nc
    #OBSIN1=${OBSDIR_NRT}/${OBSTIME}/${AODTYPE}_AOD_j01.${OBSTIME}.iodav3.nc
    SENSORID=v.viirs-m_npp
    #SENSORID1=v.viirs-m_npp
    OBSOUT=aod_pace_oci_obs_${OBSTIME}.nc4
    #OBSOUT1=aod_viirs_j01_obs_${OBSTIME}.nc4
    HOFXOUT=${AODTYPE}_obs_hofx_3dvar_LUTs_${TRCR}_${OBSTIME}.nc4
    #HOFXOUT1=${AODTYPE}_j01_obs_hofx_3dvar_LUTs_${TRCR}_${OBSTIME}.nc4
    ${NLN} ${OBSIN} ${DATAINPUT}/${OBSOUT}
    #${NLN} ${OBSIN1} ${DATAINPUT}/${OBSOUT1}
#elif [ "${AODTYPE}" == *"AERONET"* ]; then
elif ( echo ${AODTYPE} | grep -q "AERONET" ); then
    OBSIN=${OBSDIR_NRT}/${OBSTIME}/${AODTYPE}_AOD.${OBSTIME}.iodav3.nc
    SENSORID=aeronet
    OBSOUT=aeronet_aod.${OBSTIME}.nc4
    HOFXOUT=${AODTYPE}_obs_hofx_3dvar_LUTs_${TRCR}_${OBSTIME}.nc4
    ${NLN} ${OBSIN} ${DATAINPUT}/${OBSOUT}
else
    echo "AODTYBE must be VIIRS or AERONET; exit this program now!"
    exit 1
fi

# link deterministic background/analysis
ANLPREFIX=${AYY}${AMM}${ADD}.${AHH}0000
DIAGDIR=${DATA}/DIAG
[[ -d ${DIAGDIR} ]] && ${NRM} ${DIAGDIR}
mkdir -p ${DIAGDIR}

## Link ensemble bckg and analysis
GESCPLR_IN=${RSTDIR}/${ANLPREFIX}.coupler.res
GESCPLR_OUT=${DATAINPUT}/${ANLPREFIX}.coupler.res
${NLN} ${GESCPLR_IN} ${GESCPLR_OUT}

ITILE=1
while [ ${ITILE} -le 6 ]; do
    TILESTR=`printf %1i ${ITILE}`

    TILEFILE=${TRCR}.res.tile${TILESTR}
    TILEGES_IN=${RSTDIR}/${ANLPREFIX}.${TILEFILE}.nc
    TILEGES_OUT=${DATAINPUT}/${ANLPREFIX}.${TILEFILE}.nc
    ${NLN} ${TILEGES_IN} ${TILEGES_OUT}

    TILEFILE=fv_core.res.tile${TILESTR}
    TILEGES_IN=${RSTDIR}/${ANLPREFIX}.${TILEFILE}.nc
    TILEGES_OUT=${DATAINPUT}/${ANLPREFIX}.${TILEFILE}.nc
    ${NLN} ${TILEGES_IN} ${TILEGES_OUT}

   ITILE=$((ITILE+1))
done

## Link diag files to run dir
#NPROCS=$((NCORES-1))
#IPROC=0
#while [ ${IPROC} -le ${NPROCS} ]; do
#    IPROCSTR=`printf %04d ${IPROC}`
#    ${NLN} ${HOFXDIR}/${HOFXOUTPRE}_${IPROCSTR}.nc4 ${DIAGDIR}/${HOFXOUTPRE}_${IPROCSTR}.nc4
#    IPROC=$((IPROC+1))
#done

# Link executable
${NLN} ${JEDIEXE} ${DATA}/fv3jedi_hofx_nomodel.x

# Gnerate control yaml block
STABLK="  
state:
  datetime: ${ANLTIMEFMT}
  filetype: fms restart
  datapath: INPUT/
  filename_core: ${ANLPREFIX}.fv_core.res.nc
  filename_trcr: ${ANLPREFIX}.${TRCR}.res.nc
  filename_cplr: ${ANLPREFIX}.coupler.res
  state variables: [T,delp,sphum,
                    so4,bc1,bc2,oc1,oc2,
                    dust1,dust2,dust3,dust4,dust5,
                    seas1,seas2,seas3,seas4,seas5]
"

# Generate the yaml block for AOD observations
#if [ "${AODTYPE}" == "NOAA_VIIRS" ]; then
if ( echo ${AODTYPE} | grep -q "NASA_PACE_OCI" ); then
OBSBLK="  
observations:
  observers:    
  - obs space:
      name: Aod
      obsdatain:
        engine:
          type: H5File
          obsfile: ./INPUT/${OBSOUT}
      obsdataout:
        engine:
          type: H5File
          obsfile: ./DIAG/${HOFXOUT}
      simulated variables: [aerosolOpticalDepth]
      channels: ${AODCHANS_HOFX}
    obs operator:
      name: AodLUTs
      obs options:
        #Sensor_ID: ${SENSORID}
        #EndianType: little_endian
        #CoefficientPath: ./CRTM/
        AerosolOption: aerosols_gocart_1
        RCFile: geosaod_pace.rc
        model units coeff: 1.e-9
"
#  - obs space:
#      name: Aod
#      obsdatain:
#        engine:
#          type: H5File
#          obsfile: ./INPUT/${OBSOUT1}
#      obsdataout:
#        engine:
#          type: H5File
#          obsfile: ./DIAG/${HOFXOUT1}
#      simulated variables: [aerosolOpticalDepth]
#      channels: 4
#    obs operator:
#      name: AodLUTs
#      obs options:
#        Sensor_ID: ${SENSORID}
#        EndianType: little_endian
#        CoefficientPath: ./CRTM/
#        AerosolOption: aerosols_gocart_1
#        RCFile: geosaod.rc
#        model units coeff: 1.e-9

#elif [ "${AODTYPE}" == *"AERONET"* ]; then
elif ( echo ${AODTYPE} | grep -q "AERONET" ); then
OBSBLK="  
observations:
  observers:    
  - obs space:
      name: Aod
      obsdatain:
        engine:
          type: H5File
          obsfile: ./INPUT/${OBSOUT}
      obsdataout:
        engine:
          type: H5File
          obsfile: ./DIAG/${HOFXOUT}
      simulated variables: [aerosolOpticalDepth]
      channels: 1-8
    obs operator:
      name: AodLUTs
      obs options:
        Sensor_ID: ${SENSORID}
        AerosolOption: aerosols_gocart_1
        RCFile: geosaod_aeronet.rc
        model units coeff: 1.e-9
    obs filters:
    - filter: Temporal Thinning
      seed_time: ${ANLTIMEFMT}
      min_spacing: PT06H
      category_variable:
        name: MetaData/stationIdentification
"
else
    echo "AODTYPE must be VIIRS or AERONET; exit this program now!"
    exit 1
fi

# Create yaml file
#window begin: &date '${STWINFMT}'
#window length: PT6H
cat << EOF > ${DATA}/hofx_nomodel_aero_${AODTYPE}.yaml
time window:
  begin: ${STWINFMT}
  length: PT6H
geometry:
  fms initialization:
    namelist filename: fmsmpp.nml
    field table filename: field_table_gfdl
  akbk: ./INPUT/akbk.nc
  layout: [${LAYOUT}]
  io_layout: [${IO_LAYOUT}]
  npx: ${NPX}
  npy: ${NPY}
  npz: ${NPZ}
  ntiles: 6
  field metadata override: ufs-aerosol.yaml

${STABLK}
${OBSBLK}
EOF

cat ${DATA}/hofx_nomodel_aero_${AODTYPE}.yaml

#source ${HOMEjedi}/jedi_module_base.hera.sh
#export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOMEjedi}/lib/"
#export OMP_NUM_THREADS=1
#ulimit -s unlimited

srun --export=all -n ${NCORES} ./fv3jedi_hofx_nomodel.x "./hofx_nomodel_aero_${AODTYPE}.yaml" "./hofx_nomodel_aero.log"
ERR=$?
if [ ${ERR} -ne 0 ]; then
   echo "JEDI hofx failed and exit the program!!!"
   exit ${ERR}
fi

[[ -f ${HOFXDIR}/${HOFXOUT} ]] && ${NRM} ${HOFXDIR}/${HOFXOUT}
${NMV} ${DIAGDIR}/${HOFXOUT} ${HOFXDIR}/${HOFXOUT}
#if ( echo ${AODTYPE} | grep -q "NOAA_VIIRS" ); then
#    ${NMV} ${DIAGDIR}/${HOFXOUT1} ${HOFXDIR}/${HOFXOUT1}
#fi
${NCP} ${DATA}/hofx_nomodel_aero_${AODTYPE}.yaml ${HOFXDIR}/hofx_nomodel_aero_${AODTYPE}_${TRCR}.yaml

ERR=$?
if [ ${ERR} -ne 0 ]; then
   echo "Moving hofx failed and exit the program!!!"
   exit ${ERR}
fi

exit ${ERR}
