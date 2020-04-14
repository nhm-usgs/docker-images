# /bin/bash
#
# U.S. Geological Survey
#
# File - nhm.sh
#
# Purpose - Library of shell functions for NHM scripts.
#
# Authors - Steven Markstrom, Andrew Halper
#

last_simulation_date () {
  dir=$1
  restart_dir=$2

  # list restart files
  ls $dir$restart_dir*.restart > /dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    # there was a problem
    return 1
  fi

  # Determine the date for the last simulation by finding the last
  # restart file.
  ls $dir$restart_dir*.restart | sed 's/^.*\///;s/\.restart$//' | \
      sort | tail -1

} # last_simulation_date

restart_interval () {
  dir=$1
  restart_dir=$2
  gridmet_provisional_days=$3
  
  t=$(last_simulation_date $dir $restart_dir)
  
  # restart date is last simulation date + 1 day
  restart_date=`date --date "$t +1 days" --rfc-3339='date'`
  if [ "$?" -ne 0 ]; then
    echo "$restart_date"
    return 1
  fi

  # TODO: is this still relevant? Ask Steve.
  #
  #    # Determine the last date of the CBH files
  #    csd, ced, cfc = last_date_of_cbh_files(dir)
  #    if csd:
  #        print('last date in CBH files ', ced.strftime('%Y-%m-%d'))
  #        print('feature count in CBH files ', cfc)
  #
  #    else:
  #        print('log message: last_date_of_cbh failed.')
  
  # Determine the dates for the data pull.
  today=`date --rfc-3339='date'`
  yesterday=`date --date "$today -1 days" --rfc-3339='date'`
  pull_date=`date --date "$yesterday -$gridmet_provisional_days days" \
           --rfc-3339='date'`
  
  # if the restart date is before the pull date...
  if [ $(date -d "$restart_date" +%s) -lt $(date -d "$pull_date" +%s) ]; then
    pull_date="$restart_date"	# ...reset the pull date
  fi

  # return restart interval in ISO 8601 format
  echo "$pull_date/$yesterday"

} # restart_interval 

simulation_interval () {
  dir=$1
  restart_dir=$2
  gridmet_provisional_days=$3

  # if simulation interval is not specified...
  if [ -z "$NHM_INTERVAL" ]; then
    # ...calculate restart interval
    echo $(restart_interval $dir 'restart/' '59')
  else
    echo $NHM_INTERVAL
  fi
}

# start date of ISO 8601 interval
interval_start () {
  echo $1 | cut -d/ -f1
}

# end date of ISO 8601 interval
interval_end () {
  echo $1 | cut -d/ -f2
}
