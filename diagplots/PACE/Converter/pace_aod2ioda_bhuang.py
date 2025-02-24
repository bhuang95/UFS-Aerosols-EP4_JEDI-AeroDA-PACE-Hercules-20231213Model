#!/usr/bin/env python3

#
# (C) Copyright 2020 UCAR
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
#

import argparse
from datetime import datetime
import netCDF4 as nc
import numpy as np
import os

import pyiodaconv.ioda_conv_engines as iconv
from collections import defaultdict, OrderedDict
from pyiodaconv.orddicts import DefaultOrderedDict

locationKeyList = [
    ("latitude", "float"),
    ("longitude", "float"),
    ("dateTime", "long")
]

obsvars = ["aerosolOpticalDepth"]
channels = [1, 2, 3, 4, 5, 6, 7, 8, 9]
nchans = len(channels)
# Unit: micron
wavelengths = [0.354, 0.388, 0.480, 0.55, 0.67, 0.87, 1.24, 1.64, 2.2]
# Unit: micron/second
speed_light = 2.99792458E14
frequencies = [speed_light/x for x in wavelengths]
# A dictionary of global attributes.  More filled in further down.
AttrData = {}
AttrData['ioda_object_type'] = 'AOD'

# A dictionary of variable dimensions.
DimDict = {}

# A dictionary of variable names and their dimensions.
VarDims = {'aerosolOpticalDepth': ['Location', 'Channel'],
           'sensorCentralFrequency': ['Channel'],
           'sensorCentralWavelength': ['Channel'],
           'sensorChannelNumber': ['Channel']
        }

# Get the group names we use the most.
metaDataName = iconv.MetaDataName()
obsValName = iconv.OvalName()
obsErrName = iconv.OerrName()
qcName = iconv.OqcName()

int_missing_value = iconv.get_default_fill_val(np.int32)
float_missing_value = iconv.get_default_fill_val(np.float32)


class AOD(object):
    def __init__(self, filenames, mask, thin, maxobs):
        self.filenames = filenames
        self.mask = (mask == "True")
        self.thin = (thin == "True")
        self.maxobs = maxobs

        self.varDict = defaultdict(lambda: defaultdict(dict))
        self.outdata = defaultdict(lambda: DefaultOrderedDict(OrderedDict))
        self.varAttrs = DefaultOrderedDict(lambda: DefaultOrderedDict(dict))
        self._read()

    def _read(self):
        # set up variable names for IODA
        for iodavar in obsvars:
            self.varDict[iodavar]['valKey'] = iodavar, obsValName
            self.varDict[iodavar]['errKey'] = iodavar, obsErrName
            self.varDict[iodavar]['qcKey'] = iodavar, qcName
            self.varAttrs[iodavar, obsValName]['coordinates'] = 'longitude latitude'
            self.varAttrs[iodavar, obsErrName]['coordinates'] = 'longitude latitude'
            self.varAttrs[iodavar, qcName]['coordinates'] = 'longitude latitude'
            self.varAttrs[iodavar, obsValName]['_FillValue'] = -9999. #float_missing_value
            self.varAttrs[iodavar, obsErrName]['_FillValue'] = -9999. #float_missing_value
            self.varAttrs[iodavar, qcName]['_FillValue'] = -9999 #int_missing_value
            self.varAttrs[iodavar, obsValName]['units'] = '1'
            self.varAttrs[iodavar, obsErrName]['units'] = '1'

        # Make empty lists for the output vars
        self.outdata[('latitude', metaDataName)] = np.array([], dtype=np.float32)
        self.outdata[('longitude', metaDataName)] = np.array([], dtype=np.float32)
        self.outdata[('landSeaFlag', metaDataName)] = np.array([], dtype=np.int32)
        self.outdata[('dateTime', metaDataName)] = np.array([], dtype=object)
        for iodavar in obsvars:
            self.outdata[self.varDict[iodavar]['valKey']] = np.array([], dtype=np.float32)
            self.outdata[self.varDict[iodavar]['errKey']] = np.array([], dtype=np.float32)
            self.outdata[self.varDict[iodavar]['qcKey']] = np.array([], dtype=np.int32)

        # loop through input filenamess
        ntot=0
        for f in self.filenames:
            ncd = nc.Dataset(f, 'r')
            lons = ncd.groups['geolocation_data'].variables['longitude'][:].ravel()
            nlocs = lons.size
            if nlocs < 1: 
                print(f"No valid obs and skip file: {f}")
                continue
            else:
                print(f"Processing file: {f}")
                saveattrs = True
            

            # Need to change this if PACE AOD filename changes
            jday = f[-15:-8]
            hhmm = f[-7:-3]
            
            # define random seed (e.g., 202408300+39 from the file name Pace_L2_Merged_2024083.0039.nc)
            if self.thin:
                randseed = int((jday + hhmm[0:2])) + int(hhmm[2:])
            # define datetime
            base_datetime = datetime.strptime((jday + hhmm +"00Z"), "%Y%j%H%M%SZ") 
            print(f"-----File base datatime: {base_datetime}")

            # Only read and save global attributes for the first valid file
            if saveattrs:
                gatts = {attr: getattr(ncd, attr) for attr in ncd.ncattrs()}
                self.satellite = 'PACE'
                self.sensor = str(ncd.instrument)
                AttrData["platform"] = self.satellite
                AttrData["sensor"] = "v.viirs-m_npp" #self.sensor
                AttrData["landseaflag"] = "Ocean = 0; land = 1"
                AttrData["aodqcflag"] = "Ocean = 0,1,2,3; land = 0"
            
                # Set this to viirs for now for JEDI assimilaiton
                # need to change later
                # if AttrData['sensor'] == 'PACE': 
                #    AttrData['sensor'] = "v.viirs-m_npp"
 
            lats = ncd.groups['geolocation_data'].variables['latitude'][:].ravel()
            maskflags = ncd.groups['geophysical_data'].variables['Land_Sea_Flag'][:].ravel()
            vals = ncd.groups['geophysical_data'].variables['Aerosol_Optical_Depth'][:,:,:].reshape(nlocs, nchans)
            qcstmp = ncd.groups['geophysical_data'].variables['Quality_flag_Aerosol_Optical_Depth'][:,:].reshape(nlocs, 1)
            qcs = np.tile(qcstmp, (1,nchans))

            obs_time = np.full(np.shape(lons), base_datetime, dtype=object)

            if self.mask:
                # using 550nm AOD as a reference for maskout
                # May need change later
                mask = np.logical_not(vals[:,3].mask)
                lons = lons[mask]
                lats = lats[mask]
                maskflags = maskflags[mask]
                vals = vals[mask, :]
                qcs = qcs[mask, :]
                obs_time = obs_time[mask]

            ncd.close()

            # define errs[]
            # hard coded for now
            errs = np.zeros_like(vals);
            # wavelength = 354/388/480 nm: 0.05+0.30*AOD
            errs[:,0:3] = 0.05 + 0.30 * vals[:,0:3]
            # wavelength = 550/670 nm: 0.05+0.20*AOD
            errs[:,3:5] = 0.05 + 0.20 * vals[:,3:5]
            # wavelength = 870/1240/1640/2200 nm: 0.03+0.15*AOD
            errs[:,5:9] = 0.05 + 0.15 * vals[:,5:9]
            
            # set qc = 7 (for AOD value < 0 or > 5.0 
            # or 8 (for error < 1.0E-6) to not assimialte
            # this qc number may need to change
            qcs[vals < 0.] = 7
            qcs[vals > 5.] = 7
            qcs[errs < 1.0E-6] = 8
            

            nlocs1 = lons.size
            if nlocs1 > 0 :
                # Missing value in IODA file will cause very large minimization value in JEDI
                # (even with ObsFilter is applied)
                # In the current version, it only retains obs with QC=0 in Channel 1, 4, 5
                # This filtering will need to change after figuring out the missing value in IODA. 
                qcsmask_chan_4 = np.where(qcs[:,3]==0)
                qcsmask_chan_1_4_5=np.where((qcs[:,0]==0) & (qcs[:,3]==0) & (qcs[:,4]==0))
                qcsmask_filter = np.array(qcsmask_chan_1_4_5).ravel();
                size_qc_4 = np.array(qcsmask_chan_4).size
                size_qc_1_4_5= np.array(qcsmask_chan_1_4_5).size

                lons=lons[qcsmask_filter]
                lats=lats[qcsmask_filter]
                maskflags=maskflags[qcsmask_filter]
                obs_time=obs_time[qcsmask_filter]
                vals=vals[qcsmask_filter,:]
                errs=errs[qcsmask_filter,:]
                qcs=qcs[qcsmask_filter,:]

                # apply thinning mask if retained obs are more than the predefined maxobs per granule
                nlocs2 = lons.size
                if self.thin and nlocs2 > self.maxobs:
                    print(f"-----Thin data to maxobs with seed: {randseed}")
                    np.random.seed(randseed)
                    mask_thin = np.random.randint(0, nlocs2, self.maxobs)
                    mask_thin.sort()
                    lons = lons[mask_thin]
                    lats = lats[mask_thin]
                    maskflags = maskflags[mask_thin]
                    obs_time = obs_time[mask_thin]
                    vals = vals[mask_thin, :]
                    errs = errs[mask_thin, :]
                    qcs = qcs[mask_thin, :]

                #  Write out data
                self.outdata[('longitude', metaDataName)] = np.append(self.outdata[('longitude', metaDataName)], np.array(lons, dtype=np.float32))
                self.outdata[('latitude', metaDataName)] = np.append(self.outdata[('latitude', metaDataName)], np.array(lats, dtype=np.float32))
                self.outdata[('landSeaFlag', metaDataName)] = np.append(self.outdata[('landSeaFlag', metaDataName)], np.array(maskflags, dtype=np.int32))
                self.outdata[('dateTime', metaDataName)] = np.append(self.outdata[('dateTime', metaDataName)], np.array(obs_time, dtype=object))
                self.outdata[('sensorCentralFrequency', metaDataName)] = np.array(frequencies, dtype=np.float32)
                self.varAttrs[('sensorCentralFrequency', metaDataName)]['units'] = 'Hz'
                self.outdata[('sensorCentralWavelength', metaDataName)] = np.array(wavelengths, dtype=np.float32)
                self.varAttrs[('sensorCentralWavelength', metaDataName)]['units'] = 'microns'

                for iodavar in obsvars:
                    self.outdata[self.varDict[iodavar]['valKey']] = np.append(
                        self.outdata[self.varDict[iodavar]['valKey']], np.array(vals, dtype=np.float32))
                    self.outdata[self.varDict[iodavar]['errKey']] = np.append(
                        self.outdata[self.varDict[iodavar]['errKey']], np.array(errs, dtype=np.float32))
                    self.outdata[self.varDict[iodavar]['qcKey']] = np.append(
                        self.outdata[self.varDict[iodavar]['qcKey']], np.array(qcs, dtype=np.int32))

                nlocs3 = lons.size
                ntot += nlocs3
                if size_qc_4 != size_qc_1_4_5:
                    print("*******************************QC size different")
                    print(f"Stats-{f}_QC4-{size_qc_4}_QC145-{size_qc_1_4_5}_nlocs3-{nlocs3}_ntot-{ntot}")
                else:
                    print(f"-----{nlocs3} new obs saved with total nobs = {ntot} now")
            else:
                print(f"-----No obs saved.")
            
            # No need to save global attrributes from here
            saveattrs = False

        DimDict['Location'] = len(self.outdata[('latitude', metaDataName)])
        DimDict['Channel'] = np.array(channels, dtype=np.int32)

def main():

    parser = argparse.ArgumentParser(
        description=('Read PACE aerosol optical depth file(s) and Converter'
                     ' of native NetCDF format for observations of optical'
                     ' depth from PACE multi-wavelength to IODA-V3 netCDF format.')
    )
    parser.add_argument(
        '-i', '--input',
        help="path of viirs aod input file(s)",
        type=str, nargs='+', required=True)
    parser.add_argument(
        '-o', '--output',
        help="name of ioda-v3 output file",
        type=str, required=True)
    parser.add_argument(
        '-k', '--mask',
        help="maskout missing values: True/False, default=False",
        type=str, required=True)
    parser.add_argument(
        '-t', '--thin',
        help="option to thin: True/False, default=False" 
             "If True, define --maxobs",
        type=str, default=False)
    parser.add_argument(
        '-m', '--maxobs',
        help="maximum number of obs after thinning", 
        type=int, default=2000)


    args = parser.parse_args()

    # setup the IODA writer

    # Read in the AOD data
    aod = AOD(args.input, args.mask, args.thin, args.maxobs)

    # write everything out

    writer = iconv.IodaWriter(args.output, locationKeyList, DimDict)
    writer.BuildIoda(aod.outdata, VarDims, aod.varAttrs, AttrData)


if __name__ == '__main__':
    main()
