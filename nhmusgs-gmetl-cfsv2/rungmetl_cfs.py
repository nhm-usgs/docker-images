import gridmet_cfsv2 as gm
import grd2shp
import xarray as xr
import geopandas as gpd
import argparse

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

def parser():
    my_parser = argparse.ArgumentParser(prog='runGMETL_CFSv2',
                            description='ETL for gridMET CFSv2 (NOAA)')

    my_parser.add_argument('-t', '--type_extract', type=str,
                        help='extraction method: (median) or (enseble)', metavar='extraction type',
                        default='median', required=False, choices=['median', 'ensemble'])

    my_parser.add_argument('-s', --'shape_file', type=valid_file,
                        help='path/file.shp - path to shapefile', metavar='path/shapefile.shp',
                        default=None, required=True)

    my_parser.add_argument('-w', '-weights_file', type=valid_file, 
                        help='path/weights.csv - path to weights file', metavar='path/weights.csv',
                        default=None, required=True)

    my_parser.add_argument('-0', '-outpath', type=valid_path, 
                        help='Output path (location of netcdf output files)', metavar='output_path',
                        default=None, required=True)

    my_parser.add_argument('-e', '-elev_file', type=valid_file, 
                        help='path/elev.gpkg - path to elevation file, used to convert specific humidity to relative humidity',
                         metavar='path/elev.gpkg',
                        default=None, required=True)

def args(parser):
    return parser.parse_args()

def main():
    my_parser = parser()
    my_args = args(my_parser)

    if my_args.tyep_extact == 'median':
        etype = 0
    else:
        etype = 1

    shpf = my_args.shape_file
    wghtf = my_args.weights_file
    elevf = my_args.elev_file
    opth = my_args.outpath

    gm_vars=['air_temperature', 
         'air_temperature',
         'precipitation_amount',
         'wind_speed', 
         'surface_downwelling_shortwave_flux_in_air',
         'specific_humidity']

    m = gm.Gridmet(type=etype)
    ds1 = m.tmax
    ds2 = m.tmin
    ds3 = m.prcp
    ds4 = m.wind_speed
    ds5 = m.srad
    ds6 = m.specific_humidity
    dat = [ds1, ds2, ds3, ds4, ds5, ds6]
    vout = ['tmax', 'tmin', 'prcp', 'ws', 'srad', 'shum']
    gdf = gpd.read_file(shpf)
    g2s = grd2shp.Grd2Shp()
    pin = g2s.initialize(grd=dat,
                        calctype=etype,
                        shp=gdf,
                        wght_file=wghtf,
                        time_var='day',
                        lat_var='lat',
                        lon_var='lon',
                        var=gm_vars,
                        var_output=vout,
                        opath=opth,
                        fileprefix='f_')
    numts = g2s.num_timesteps
    for i in range(1):
        g2s.run_weights()

    g2s.write_file(elev_file=elevf, punits=1)
                
