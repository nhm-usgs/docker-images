#! /bin/sh

python /usr/local/src/onhm-fetcher-parser/pkg/onhm_fp_script.py \
       -d"$DAYS" -i'/var/lib/nhm/ofp/Data' -o'/var/lib/nhm/ofp/Output'
