#Compilation instruction: make exec in the current dir
#Move the targted executable to the front and do "mkae"


#FC =  ifort -g -traceback -check all -fp-stack-check 
FC = mpiifort   #ifort #mpiifort
FCFLAGS = -qopenmp
NETCDF_F = $(netcdf_fortran_ROOT)
NETCDF_C = $(netcdf_c_ROOT)
LIBCDF = -I$(NETCDF_F)/include -L$(NETCDF_F)/lib -I$(NETCDF_C)/include -L$(NETCDF_C)/lib -lnetcdff -lnetcdf
DATETIME= /work/noaa/wrf-chem/bhuang/expCodes-Hercules//MariusLibs/libs/fortran-datetime
#/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-Reanl-Hercules-20231213Model/misc/MariusLibs/libs/fortran-datetime
#/home/mpagowsk/mapp_2018/libs/fortran-datetime
LIBDATETIME = -I$(DATETIME)/include -L$(DATETIME)/lib -lfortran_datetime
SLINT = /work/noaa/wrf-chem/bhuang/expCodes-Hercules//MariusLibs/libs/slint
LIBSLINT = -I$(SLINT) -L$(SLINT) -lslint
LDFLAGS = $(LIBCDF) $(LIBSLINT) $(LIBDATETIME)

#SOURCEDIR = /work/noaa/wrf-chem/bhuang/NRTdata_UFS-Aerosols/src_omp/src_omp
SOURCEDIR= /home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-PACE-Reanl-Hercules-20231213Model/misc/src_omp
#/home/bohuang/Workflow/UFS-Aerosols_NRTcyc/UFS-Aerosols-EP4_JEDI-AeroDA-Reanl-Orion/misc/src_omp
BUILDDIR = /work/noaa/wrf-chem/bhuang/expCodes-Hercules//src_omp/build
#/work/noaa/wrf-chem/bhuang/NRTdata_UFS-Aerosols/src_omp/build
#EXECDIR = /work/noaa/wrf-chem/bhuang/expCodes/HerculesCodes/src_omp/exec 
EXECDIR= /work/noaa/wrf-chem/bhuang/expCodes-Hercules//src_omp/exec
#/work/noaa/wrf-chem/bhuang/expCodes-Hercules/src_omp/exec
#/work/noaa/wrf-chem/bhuang/NRTdata_UFS-Aerosols/src_omp/exec

RM = /bin/rm -f

.SUFFIXES:

.SUFFIXES: .F .f90 .f .o

OBJ101 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/viirs2ioda_init.o \
	$(BUILDDIR)/viirs2ioda_nc.o \
	$(BUILDDIR)/viirs2ioda_vars.o \
	$(BUILDDIR)/viirs2ioda_thin.o \
	$(BUILDDIR)/viirs2ioda_old.o  	

OBJ102 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/fv3aod2obs.o

OBJ103 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_aod_nnr.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/module_obs_thinning_nnr.o \
	$(BUILDDIR)/nnr2ioda.o

OBJ104 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/module_gocart_cams.o \
	$(BUILDDIR)/module_fv3gocart2cams.o \
	$(BUILDDIR)/fv32pll.o

OBJ105 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/fv3aod2ll.o

OBJ105a = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/fv3aod2ll_reanalysis.o

OBJ106 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/module_m2.o \
	$(BUILDDIR)/module_gocart_cams.o \
	$(BUILDDIR)/module_m2gocart2cams.o \
	$(BUILDDIR)/m22p.o

OBJ107 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/calc_col_integrals.o

OBJ108 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/calc_col_integrals_cams.o

OBJ109 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_nucaps_co.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/module_obs_thinning_nucaps_co.o \
	$(BUILDDIR)/nucaps_co2ioda.o

OBJ110 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/calc_gas_col_integrals.o

OBJ111 = \
	$(BUILDDIR)/module_util_gbbepx.o \
	$(BUILDDIR)/convert_gbbepx.o

OBJ112 = \
	$(BUILDDIR)/module_util_gbbepx.o \
	$(BUILDDIR)/convert_gbbepx_noco.o

OBJ113 = \
	$(BUILDDIR)/module_util_gbbepx.o \
	$(BUILDDIR)/convert_gbbepx_fixfrp.o

OBJ114 = \
	$(BUILDDIR)/module_util_gbbepx.o \
	$(BUILDDIR)/convert_fix_modis.o

OBJ115 = \
	$(BUILDDIR)/module_util_gbbepx.o \
	$(BUILDDIR)/convert_gbbepx_nofrp2frp.o

OBJ116 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/fv32ll.o

OBJ116a = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/module_gocart_reanalysis.o \
	$(BUILDDIR)/fv32ll_reanalysis.o

OBJ117 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/module_m2.o \
	$(BUILDDIR)/module_gocart_cams.o \
	$(BUILDDIR)/module_m2gocart2cams.o \
	$(BUILDDIR)/geos2p.o

OBJ118 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_viirs2aeronet_args.o \
	$(BUILDDIR)/module_viirs_vars.o \
	$(BUILDDIR)/module_aeronet_vars.o \
	$(BUILDDIR)/module_viirs2ioda.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/viirs2aeronet.o

OBJ119 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/viirs2ioda_init.o \
	$(BUILDDIR)/viirs2ioda_nc.o \
	$(BUILDDIR)/viirs2ioda_vars.o \
	$(BUILDDIR)/viirs2ioda_thin.o \
	$(BUILDDIR)/viirs2ioda_lunar.o  	

OBJ120 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_viirs2aeronet_args.o \
	$(BUILDDIR)/module_viirs_vars.o \
	$(BUILDDIR)/module_aeronet_vars.o \
	$(BUILDDIR)/module_viirs2ioda.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/viirs2aeronet_lunar.o

OBJ121 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/module_improve.o \
	$(BUILDDIR)/fv32improve.o

OBJ122 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/fv3pm25.o

OBJ123 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/fv3aerospecies.o

OBJ124 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_viirs2aeronet_args.o \
	$(BUILDDIR)/module_aeronet_vars.o \
	$(BUILDDIR)/module_viirs_vars.o \
	$(BUILDDIR)/module_viirs2ioda.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/viirsaod_clim2ioda.o

OBJ125 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_aeronet_vars.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/module_viirs2aeronet_args.o \
	$(BUILDDIR)/module_viirs_vars.o \
	$(BUILDDIR)/module_viirs2ioda.o \
	$(BUILDDIR)/viirsaod_clim_interp2ioda.o

OBJ126 = \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_kinds.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_interp.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_aeronet_vars.o \
	$(BUILDDIR)/module_viirs2aeronet_args.o \
	$(BUILDDIR)/module_viirs_vars.o \
	$(BUILDDIR)/module_viirs2ioda.o \
	$(BUILDDIR)/fv3aod_interp2ioda.o

OBJ127 = \
	$(BUILDDIR)/orderpack.o \
	$(BUILDDIR)/module_constants.o \
	$(BUILDDIR)/module_viirs2aeronet_args.o \
	$(BUILDDIR)/module_netcdf_io.o \
	$(BUILDDIR)/module_utils.o \
	$(BUILDDIR)/module_fv3.o \
	$(BUILDDIR)/module_aeronet_vars.o \
	$(BUILDDIR)/module_viirs_vars.o \
	$(BUILDDIR)/module_viirs2ioda.o \
	$(BUILDDIR)/module_generic_thinning.o \
	$(BUILDDIR)/viirs2ioda.o

#$(EXECDIR)/viirs2ioda_old.x: $(OBJ101)
#	$(FC) $(OBJ101) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv32ll_reanalysis.x: $(OBJ116a)
#	$(FC) $(OBJ116a) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv3aod2ll.x: $(OBJ105)
#	$(FC) $(OBJ105) $(FCFLAGS) $(LDFLAGS) -o $@
 
#$(EXECDIR)/fv32ll.x: $(OBJ116)
#	$(FC) $(OBJ116) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv32pll.x: $(OBJ104)
#	$(FC) $(OBJ104) $(FCFLAGS) $(LDFLAGS) -o $@


#$(EXECDIR)/fv3aod2obs.x: $(OBJ102)
#	$(FC) $(OBJ102) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/nnr2ioda.x: $(OBJ103)
#	$(FC) $(OBJ103) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv32pll.x: $(OBJ104)
#	$(FC) $(OBJ104) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv3aod2ll.x: $(OBJ105)
#	$(FC) $(OBJ105) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv3aod2ll_reanalysis.x: $(OBJ105a)
#	$(FC) $(OBJ105a) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/m22p.x: $(OBJ106)
#	$(FC) $(OBJ106) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/calc_col_integrals.x: $(OBJ107)
#	$(FC) $(OBJ107) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/calc_col_integrals_cams.x: $(OBJ108)
#	$(FC) $(OBJ108) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/nucaps_co2ioda.x: $(OBJ109)
#	$(FC) $(OBJ109) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/calc_gas_col_integrals.x: $(OBJ110)
#	$(FC) $(OBJ110) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/convert_gbbepx.x: $(OBJ111)
#	$(FC) $(OBJ111) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/convert_gbbepx_noco.x: $(OBJ112)
#	$(FC) $(OBJ112) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/convert_gbbepx_fixfrp.x: $(OBJ113)
#	$(FC) $(OBJ113) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/convert_fix_modis.x: $(OBJ114)
#	$(FC) $(OBJ114) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/convert_gbbepx_nofrp2frp.x: $(OBJ115)
#	$(FC) $(OBJ115) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv32ll.x: $(OBJ116)
#	$(FC) $(OBJ116) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv32ll_reanalysis.x: $(OBJ116a)
#	$(FC) $(OBJ116a) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/geos2p.x: $(OBJ117)
#	$(FC) $(OBJ117) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/viirs2aeronet.x: $(OBJ118)
#	$(FC) $(OBJ118) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/viirs2ioda_lunar.x: $(OBJ119)
#	$(FC) $(OBJ119) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/viirs2aeronet_lunar.x: $(OBJ120)
#	$(FC) $(OBJ120) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv32improve.x: $(OBJ121)
#	$(FC) $(OBJ121) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv3pm25.x: $(OBJ122)
#	$(FC) $(OBJ122) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv3aerospecies.x: $(OBJ123)
#	$(FC) $(OBJ123) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/viirsaod_clim2ioda.x: $(OBJ124)
#	$(FC) $(OBJ124) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/viirsaod_clim_interp2ioda.x: $(OBJ125)
#	$(FC) $(OBJ125) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/fv3aod_interp2ioda.x: $(OBJ126)
#	$(FC) $(OBJ126) $(FCFLAGS) $(LDFLAGS) -o $@

#$(EXECDIR)/viirs2ioda.x: $(OBJ127)
#	$(FC) $(OBJ127) $(FCFLAGS) $(LDFLAGS) -o $@

$(BUILDDIR)/viirs2ioda_init.o: $(BUILDDIR)/viirs2ioda_vars.o

$(BUILDDIR)/viirs2ioda_old.o: $(BUILDDIR)/viirs2ioda_init.o \
                $(BUILDDIR)/viirs2ioda_vars.o \
                $(BUILDDIR)/viirs2ioda_nc.o \
                $(BUILDDIR)/viirs2ioda_thin.o

$(BUILDDIR)/viirs2ioda_nc.o: $(BUILDDIR)/viirs2ioda_vars.o $(BUILDDIR)/module_constants.o

$(BUILDDIR)/viirs2ioda_thin.o: $(BUILDDIR)/viirs2ioda_vars.o \
                $(BUILDDIR)/viirs2ioda_nc.o \
                $(BUILDDIR)/orderpack.o

$(BUILDDIR)/fv3aod2obs.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o

$(BUILDDIR)/module_fv3.o: $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/module_netcdf_io.o: $(BUILDDIR)/module_kinds.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/module_constants.o: $(BUILDDIR)/module_kinds.o
$(BUILDDIR)/module_obs_thinning_nnr.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_aod_nnr.o $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_generic_thinning.o 
$(BUILDDIR)/module_aod_nnr.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o 
$(BUILDDIR)/module_aod_nnr.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o 
$(BUILDDIR)/nnr2ioda.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_aod_nnr.o $(BUILDDIR)/module_obs_thinning_nnr.o 
$(BUILDDIR)/fv32pll.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_gocart_cams.o $(BUILDDIR)/module_utils.o $(BUILDDIR)/module_fv3gocart2cams.o
$(BUILDDIR)/fv32ll.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_utils.o 
$(BUILDDIR)/fv32ll_reanalysis.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_utils.o $(BUILDDIR)/module_gocart_reanalysis.o
$(BUILDDIR)/module_gocart_cams.o: $(BUILDDIR)/module_utils.o
$(BUILDDIR)/module_fv3gocart2cams.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_gocart_cams.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/fv3aod2ll.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/fv3aod2ll_reanalysis.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/module_m2gocart2cams.o: $(BUILDDIR)/module_gocart_cams.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/m22p.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_gocart_cams.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/geos2p.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_gocart_cams.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/module_m2.o: $(BUILDDIR)/module_netcdf_io.o 
$(BUILDDIR)/calc_col_integrals.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o $(BUILDDIR)/module_interp.o
$(BUILDDIR)/calc_col_integrals_cams.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o $(BUILDDIR)/module_interp.o
$(BUILDDIR)/module_nucaps_co.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/nucaps_co2ioda.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_nucaps_co.o $(BUILDDIR)/module_obs_thinning_nucaps_co.o 
$(BUILDDIR)/calc_gas_col_integrals.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o
$(BUILDDIR)/convert_gbbepx.o: $(BUILDDIR)/module_util_gbbepx.o
$(BUILDDIR)/convert_gbbepx_noco.o: $(BUILDDIR)/module_util_gbbepx.o
$(BUILDDIR)/convert_gbbepx_fixfrp.o: $(BUILDDIR)/module_util_gbbepx.o
$(BUILDDIR)/convert_fix_modis.o: $(BUILDDIR)/module_util_gbbepx.o
$(BUILDDIR)/convert_gbbepx_nofrp2frp.o: $(BUILDDIR)/module_util_gbbepx.o

$(BUILDDIR)/fv32pll.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_gocart_cams.o 

$(BUILDDIR)/viirs2aeronet.o: $(BUILDDIR)/orderpack.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_viirs2aeronet_args.o $(BUILDDIR)/module_viirs_vars.o $(BUILDDIR)/module_viirs2ioda.o $(BUILDDIR)/module_generic_thinning.o $(BUILDDIR)/module_aeronet_vars.o

$(BUILDDIR)/module_viirs_vars.o: $(BUILDDIR)/module_constants.o
$(BUILDDIR)/module_viirs2ioda.o: $(BUILDDIR)/module_viirs2aeronet_args.o $(BUILDDIR)/module_viirs_vars.o $(BUILDDIR)/module_aeronet_vars.o $(BUILDDIR)/orderpack.o

$(BUILDDIR)/module_aeronet_vars.o: $(BUILDDIR)/module_constants.o

$(BUILDDIR)/viirs2aeronet_lunar.o: $(BUILDDIR)/module_viirs2aeronet_args.o $(BUILDDIR)/module_viirs_vars.o $(BUILDDIR)/module_viirs2ioda.o $(BUILDDIR)/module_generic_thinning.o $(BUILDDIR)/module_aeronet_vars.o

$(BUILDDIR)/fv32improve.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_improve.o $(BUILDDIR)/module_utils.o 

$(BUILDDIR)/module_improve.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o

$(BUILDDIR)/fv3pm25.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o

$(BUILDDIR)/fv3aerospecies.o: $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_utils.o

$(BUILDDIR)/viirsaod_clim2ioda.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_viirs2ioda.o $(BUILDDIR)/module_viirs_vars.o

$(BUILDDIR)/viirsaod_clim_interp2ioda.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_viirs2ioda.o $(BUILDDIR)/module_viirs_vars.o $(BUILDDIR)/orderpack.o $(BUILDDIR)/module_viirs2aeronet_args.o $(BUILDDIR)/module_generic_thinning.o

$(BUILDDIR)/fv3aod_interp2ioda.o: $(BUILDDIR)/module_utils.o $(BUILDDIR)/module_kinds.o $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_interp.o $(BUILDDIR)/module_aeronet_vars.o $(BUILDDIR)/module_viirs2aeronet_args.o $(BUILDDIR)/module_viirs_vars.o $(BUILDDIR)/module_viirs2ioda.o  $(BUILDDIR)/module_netcdf_io.o $(BUILDDIR)/module_fv3.o $(BUILDDIR)/module_utils.o

$(BUILDDIR)/viirs2ioda.o: $(BUILDDIR)/module_constants.o $(BUILDDIR)/module_viirs2ioda.o $(BUILDDIR)/module_viirs_vars.o $(BUILDDIR)/orderpack.o $(BUILDDIR)/module_viirs2aeronet_args.o $(BUILDDIR)/module_generic_thinning.o


$(BUILDDIR)/%: $(BUILDDIR)/%.o
	$(FC) $(FCFLAGS) -o $@ $^ $(LDFLAGS) 
$(BUILDDIR)/%.o: $(SOURCEDIR)/%.f90
	$(FC) $(FCFLAGS) -c $< $(LDFLAGS) -o $@ -module $(BUILDDIR) 

clean:
	$(RM) $(BUILDDIR)/*.o $(BUILDDIR)/*.mod

