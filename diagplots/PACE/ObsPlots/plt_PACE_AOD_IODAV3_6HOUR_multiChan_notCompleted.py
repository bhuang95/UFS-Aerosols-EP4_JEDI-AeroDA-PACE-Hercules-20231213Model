import sys,os
sys.path.append('/scratch1/BMC/gsd-fv3-dev/MAPP_2018/bhuang/JEDI-2020/JEDI-FV3/expCodes/METplus-diag/METplus_pkg//pyscripts/lib')
os.environ['PROJ_LIB'] = '/contrib/anaconda/anaconda3/latest/share/proj'
from mpl_toolkits.basemap import Basemap
import netCDF4 as nc
import numpy as np
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import matplotlib.colors as mpcrs
import matplotlib.cm as cm
from ndate import ndate
import os, argparse
#from datetime import datetime
#from datetime import timedelta

def setup_cmap(name,nbar,mpl,whilte,reverse):
    nclcmap='/scratch1/BMC/gsd-fv3-dev/MAPP_2018/bhuang/JEDI-2020/JEDI-FV3/expCodes/METplus-diag/METplus_pkg/pyscripts/colormaps/'
    cmapname=name
    f=open(nclcmap+'/'+cmapname+'.rgb','r')
    a=[]
    for line in f.readlines():
        if ('ncolors' in line):
            clnum=int(line.split('=')[1])
        a.append(line)
    f.close()
    b=a[-clnum:]
    c=[]

    selidx=np.trunc(np.linspace(0, clnum-1, nbar))
    selidx=selidx.astype(int)

    for i in selidx[:]:
        if mpl==1:
            c.append(tuple(float(y) for y in b[i].split()))
        else:
            c.append(tuple(float(y)/255. for y in b[i].split()))

    
    if reverse==1:
        ctmp=c
        c=ctmp[::-1]
    if white==-1:
        c[0]=[1.0, 1.0, 1.0]
    if white==1:
        c[-1]=[1.0, 1.0, 1.0]
    elif white==0:
        c[int(nbar/2-1)]=[1.0, 1.0, 1.0]
        c[int(nbar/2)]=c[int(nbar/2-1)]

    d=mpcrs.LinearSegmentedColormap.from_list(name,c,selidx.size)
    return d



def plot_map_satter_inc(lons, lats, obs, cmap_aod, titlepre, cycpre):
    vvend1='max'
    ccmap1=cmap_aod
    bounds=[0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1.0]
    norm1=mpcrs.BoundaryNorm(bounds, ccmap1.N)

    fig=plt.figure(figsize=[6, 3])
    for ipt in range(1):
        ax=fig.add_subplot(1,1,ipt+1)
        data=obs
        tstr=f"VIIRS/S-NPP 550 nm AOD at {cycpre}"
        vvend=vvend1
        cmap=ccmap1
        norm=norm1

        font1=14
        font2=12
        font3=12
        
        if ipt==100:
            ax.set_axis_off()
        else:
            #map=Basemap(projection='cyl',llcrnrlat=-45,urcrnrlat=45,llcrnrlon=-45,urcrnrlon=45,resolution='c')
            #parallels = np.arange(-45.,45,45.)
            #meridians = np.arange(-45,45,45.)
            map=Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,llcrnrlon=-180,urcrnrlon=180,resolution='c')
            parallels = np.arange(-90.,90,45.)
            meridians = np.arange(-180,180,90.)
            map.drawcoastlines(color='black', linewidth=0.2)
            map.drawparallels(parallels,labels=[True,False,False,False],linewidth=0.2, fontsize=font2, color='grey', dashes=(None,None))
            map.drawmeridians(meridians,labels=[False,False,False,True],linewidth=0.2, fontsize=font2, color='grey', dashes=(None,None))
            x,y=map(lons, lats)
            cs=map.scatter(lons,lats, s=1, c=data, marker='.', cmap=cmap, norm=norm)
            cb=map.colorbar(cs,"right", size=0.1, pad=0.02, extend=vvend)
            cb.ax.tick_params(labelsize=font2)
            ellblack = matplotlib.patches.Ellipse(xy=map(10,22), width=56, height=23, color='black',linewidth=3,fill=False)
            ellred = matplotlib.patches.Ellipse(xy=map(17,-2), width=23, height=15, color='red',linewidth=3,fill=False)
            ellblue = matplotlib.patches.Ellipse(xy=map(-25,10), width=27, height=21, color='blue',linewidth=3,fill=False)
            #ax.add_patch(ellblack)
            #ax.add_patch(ellred)
            #ax.add_patch(ellblue)
        #ax.autoscale()
        
            ax.set_title(tstr, fontsize=font1)
        #if ipt==2:     
        #    fig.subplots_adjust(bottom=0.04)
        #    cbar_ax = fig.add_axes([0.06, 0.04, 0.4, 0.02])
        #    cb=fig.colorbar(cs, cax=cbar_ax, orientation='horizontal', ticks=bounds[::3], extend=vvend)
        #    cb.ax.tick_params(labelsize=font2)


    #fig.tight_layout(rect=[0.0, 0.05, 1.0, 1.0])
    #fig.tight_layout(rect=[0.0, 0.04, 1.0, 1.0])
    fig.tight_layout()
    pname = f"{titlepre}-{cycpre}.png"
    plt.savefig(pname, format='png')
    plt.close(fig)
    return

def plot_scatter(obs, hofx, hofx1, cyc):
    fig=plt.figure(figsize=[11,5])
    ax=fig.add_subplot(121)
    ax.set_title('AOD Bckg. vs Obs.', fontsize=18)
    plt.scatter(obs, hofx, s=20, marker='.', color='blue')
    plt.xlim(0, 1.5)
    plt.ylim(0, 1.5)
    plt.plot([0.0, 1.5],[0.0, 1.5], color='red', linewidth=4, linestyle='--')
    plt.xlabel('AOD Obs', fontsize=16)
    plt.ylabel('AOD Bckg. HofX', fontsize=16)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)

    ax=fig.add_subplot(122)
    ax.set_title('AOD Anal. vs Obs.', fontsize=18)
    plt.scatter(obs, hofx1, s=20, marker='.', color='blue')
    plt.xlim(0, 1.5)
    plt.ylim(0, 1.5)
    plt.plot([0.0, 1.5],[0.0, 1.5], color='red', linewidth=4, linestyle='--')
    plt.xlabel('AOD Obs', fontsize=16)
    plt.ylabel('AOD Anal. HofX', fontsize=16)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)

    plt.savefig('AOD-scatter-%s.png' % (str(cyc)))
    return

def plot_hist(obs, hofx, hofx1, innov, innov1, cyc):
    fig = plt.figure(figsize=[14,8])
    ax=fig.add_subplot(231) 
    ax.set_title('AOD Obs', fontsize=20)
    plt.hist(obs, bins=21, range=[0, 1.5], facecolor='blue')
    plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)

    ax=fig.add_subplot(232) 
    ax.set_title('AOD Bckg. Hofx', fontsize=20)
    plt.hist(hofx, bins=21, range=[0, 1.5], facecolor='blue')
    plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    ax=fig.add_subplot(233) 

    ax.set_title('AOD Bckg. Innov.', fontsize=20)
    plt.hist(innov, bins=21, range=[-1.5, 1.5], facecolor='blue')
    plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)

    ax=fig.add_subplot(234) 
    ax.set_title('AOD Obs', fontsize=20)
    plt.hist(obs, bins=21, range=[0, 1.5], facecolor='blue')
    plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)

    ax=fig.add_subplot(235) 
    ax.set_title('AOD Anal. Hofx', fontsize=20)
    plt.hist(hofx1, bins=21, range=[0, 1.5], facecolor='blue')
    plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)

    ax=fig.add_subplot(236) 
    ax.set_title('AOD Anal. Innov.', fontsize=20)
    plt.hist(innov1, bins=21, range=[-1.5, 1.5], facecolor='blue')
    plt.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.savefig('AOD-hist-%s.png' % (str(cyc)))
    return


def concat_6tiles_aodhfx(ntiles, var, g2, v2, ioda, filedir, aodtyp, cyc, field):
    for itilem1 in range(ntiles):
        itile=itilem1
        filetmp='%s/aod_%s_hofx_3dvar_LUTs_%s_000%s.%s' % (filedir, aodtyp, cyc, str(itile), field)
        print(filetmp)
        nctmp=NetCDFFile(filetmp)
        if ioda == 1:
            varv=nctmp.variables[var][:]
        else:
            varg=nctmp.groups[g2]
            if g2 == 'hofx':
               varv=varg[v2][:,0]
            else:
               varv=varg[v2][:]
        if (itile == 0):
            varvarr=varv.flatten()
        else:
            varvarr=np.concatenate((varvarr, varv.flatten()), axis=0)
        nctmp.close()
    return varvarr


if __name__ == '__main__':

    obsdir='/work/noaa/gsd-fv3-dev/bhuang/expRuns/UFS-Aerosols_RETcyc/AeroReanl/TestData/JEDI/IODA/internal-20241210/TestScripts/PACEAODCONVERTER-Bo/tmp'
    cycst=2024032300
    cyced=2024032400
    wagelengths=['354', '388', '480', '550', '670', \
                 '870', '1240', '1640', '2200']
    inc_h=6

    nbars=21
    cbarname='WhiteBlueGreenYellowRed-v1'
    mpl=0
    white=-1
    reverse=0
    cmap_aod=setup_cmap(cbarname,nbars,mpl,white,reverse)

    lcol_bias=[[115,  25, 140], [  50, 40, 105], [  0,  18, 120], [   0,  35, 160], \
               [  0,  30, 210], [  5,  60, 210], [  4,  78, 150], \
               [  5, 112, 105], [  7, 145,  60], [ 24, 184,  31], \
               [ 74, 199,  79], [123, 214, 127], [173, 230, 175], \
               [222, 245, 223], [255, 255, 255], [255, 255, 255], \
               [255, 255, 255], [255, 255, 210], [255, 255, 150], \
               [255, 255,   0], [255, 220,   0], [255, 200,   0], \
               [255, 180,   0], [255, 160,   0], [255, 140,   0], \
               [255, 120,   0], [255,  90,   0], [255,  60,   0], \
               [235,  55,   35], [190,  40, 25], [175,  35,  25], [116,  20,  12]]
    acol_bias=np.array(lcol_bias)/255.0
    tcol_bias=tuple(map(tuple, acol_bias))
    cmapbias_name='aod_bias_list'
    cmapbias=mpcrs.LinearSegmentedColormap.from_list(cmapbias_name, tcol_bias, N=32)
    cmap_bias=cmapbias


    gmeta = "MetaData"
    gobs = "ObsValue"

    vlon = "longitude"
    vlat = "latitude"
    vobs = "aerosolOpticalDepth"
    
    cyc=cycst
    while cyc < cyced:
        cymd=str(cyc)[:8]
        ch=str(cyc)[8:]
        ncfile = f'{obsdir}/{cyc}/NOAA_VIIRS_AOD_npp.{cyc}.iodav3.nc'
        print(ncfile)
        with nc.Dataset(ncfile, 'r') as ncdata:
            metagrp = ncdata.groups[gmeta]
            obsgrp = ncdata.groups[gobs]
            lon = metagrp[vlon][:]
            lat = metagrp[vlat][:]
            obs = obsgrp[vobs][:,:]

        titlepre = f"VIIRS-AOD-{cyc}"
        cycpre = f"{cyc}"
        plot_map_satter_inc(lon, lat, obs, cmap_aod, titlepre, cycpre)
        cyc=ndate(cyc, inc_h)
exit()
