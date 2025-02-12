#!/bin/bash

echo "
INFORMIXDIR=/opt/IBM/Informix_Client-SDK
export INFORMIXDIR

DB_LOCALE=en_US.57372
export DB_LOCALE
" >> /etc/apache2/envvars
