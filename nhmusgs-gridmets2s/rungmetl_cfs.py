import gridmet_cfsv2 as gm
import grd2shp
import geopandas as gpd
import argparse
from pathlib import Path
import sys
from netCDF4 import Dataset
from netCDF4 import num2date
import datetime
import sys
import numpy as np
import csv
import datetime

etype_dict = {'day0': 0, 'day1': 1, 'day2': 2, 'all': 3, 'median': 4}
itype_dict = {'area_weighted_mean': 0, 'zonal_stats': 1}


def valid_path(s):
    if Path(s).exists():
        return s
    else:
        raise argparse.ArgumentError(f'Path does not exist: {s}')


def valid_file(s):
    if Path(s).exists():
        return s
    else:
        raise argparse.ArgumentError(f'File does not exist: {s}')


def valid_etype(s):
    if s in etype_dict.keys():
        return s
    else:
        raise argparse.ArgumentError(f'Not a valid extraction type: {s}')


def valid_interp(s):
    if s in itype_dict.keys():
        return s
    else:
        raise argparse.ArgumentError(f'Not a valid interpolation type: {s}')

def valid_date(s):
    try:
        return datetime.datetime.strptime(s, "%Y-%m-%d")
    except ValueError:
        msg="Not a valid date: '{0}'.".format(s)
        raise argparse.ArgumentTypeError(msg)


def parser():
    my_parser = argparse.ArgumentParser(prog='runGMETL_CFSv2',
                                        description='ETL for gridMET CFSv2 (NOAA)')

    my_parser.add_argument('-t', '--type_extract', type=valid_etype,
                           help='extraction method: (median) or (enseble)', metavar='extraction type',
                           default='median', required=False, choices=['day0', 'day1', 'day2', 'all', 'median'])

    my_parser.add_argument('-s', '--shape_file', type=valid_file,
                           help='path/file.shp - path to shapefile', metavar='path/shapefile.shp',
                           default=None, required=True)

    my_parser.add_argument('-w', '--weights_file', type=valid_file,
                           help='path/weights.csv - path to weights file', metavar='path/weights.csv',
                           default=None, required=True)

    my_parser.add_argument('-o', '--outpath', type=valid_path,
                           help='Output path (location of netcdf output files)', metavar='output_path',
                           default=None, required=True)

    my_parser.add_argument('-e', '--elev_file', type=valid_file,
                           help='path/elev.gpkg - path to elevation file, used to convert specific humidity ' +
                                'to relative humidity',
                           metavar='path/elev.gpkg',
                           default=None, required=True)

    my_parser.add_argument('-i', '--interp_type', type=valid_interp,
                           help='interpolate grid to shape using mean weighted-area or rasterio zonal stats',
                           metavar='interpolation type',
                           choices=['area_weighted_mean', 'zonal_stats'],
                           default='area_weighted_mean', required=True)

    my_parser.add_argument('-d', '--date_tag', type=valid_date,
                           help='Date tag used to identify ouputfile created by this process',
                           metavar='Date tag',
                           default=None, required=True)

    return my_parser


def args(parser):
    return parser.parse_args()


def main():
    my_parser = parser()
    my_args = args(my_parser)
    etype = etype_dict[my_args.type_extract]
    itype = itype_dict[my_args.interp_type]
    shpf = my_args.shape_file
    wghtf = my_args.weights_file
    elevf = my_args.elev_file
    opth = my_args.outpath
    datetag = my_args.date_tag

    gm_vars = ['air_temperature',
               'air_temperature',
               'precipitation_amount',
               'wind_speed',
               'surface_downwelling_shortwave_flux_in_air',
               'specific_humidity']

    m = gm.Gridmet(type=etype)
    ds1 = m.tmax.median(dim='time', skipna=True, keep_attrs=True)
    ds2 = m.tmin.median(dim='time', skipna=True, keep_attrs=True)
    ds3 = m.prcp.mean(dim='time', skipna=True, keep_attrs=True)
    ds4 = m.wind_speed.median(dim='time', skipna=True, keep_attrs=True)
    ds5 = m.srad.median(dim='time', skipna=True, keep_attrs=True)
    ds6 = m.specific_humidity.median(dim='time', skipna=True, keep_attrs=True)
    dat = [ds1, ds2, ds3, ds4, ds5, ds6]
    vout = ['tmax', 'tmin', 'prcp', 'ws', 'srad', 'shum']
    gdf = gpd.read_file(shpf)
    g2s = grd2shp.Grd2Shp()
    g2s.initialize(grd=dat,
                   calctype=itype,
                   shp=gdf,
                   wght_file=wghtf,
                   time_var='day',
                   lat_var='lat',
                   lon_var='lon',
                   var=gm_vars,
                   var_output=vout,
                   opath=opth,
                   fileprefix='f_')
    for i in range(30):
        g2s.run_weights()

    g2s.write_file(elev_file=elevf, punits=1, datetag=datetag)



if __name__ == "__main__":
    sys.exit(main())
