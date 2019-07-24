#!/bin/bash

# Creates SSL certificates to use for testing. 
# Usage:
# - To make a wildcard certificate: ./make_ssl_keys.sh
# - To make a domain-based certificate: ./make_ssl_keys.sh some.domain.name.gov
#
# Example:
# $ ./make_ssl_keys.sh
# Generating a 4096 bit RSA private key
# .................................................................................................................++
# .......++
# writing new private key to './ssl.key'
# -----
# $ ls -al
# total 12
# drwxr-xr-x  5 usgs-user  usgs-user   170 Jul 23 15:22 .
# drwxr-xr-x  4 usgs-user  usgs-user   136 Jul 23 15:18 ..
# -rwxr-xr-x  1 usgs-user  usgs-user   359 Jul 23 15:22 make_ssl_keys.sh
# -rw-r--r--  1 usgs-user  usgs-user  2086 Jul 23 15:22 ssl.crt
# -rw-r--r--  1 usgs-user  usgs-user  3243 Jul 23 15:22 ssl.key

openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj \
    "/C=US/ST=Wisconsin/L=Middleton/O=WMA/CN=${1-*}" -keyout ./ssl.key -out ./ssl.crt