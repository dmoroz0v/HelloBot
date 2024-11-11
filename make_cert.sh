#!/bin/bash

readonly PATH_TO_CURR_DIR=`dirname $0`

source $PATH_TO_CURR_DIR/.env

rm -f $PATH_TO_CURR_DIR/Cert/key.pem
rm -f $PATH_TO_CURR_DIR/Cert/cert.pem

(cd $PATH_TO_CURR_DIR/Cert; openssl req -newkey rsa:2048 -sha256 -nodes -keyout key.pem -x509 -days 3650 -out cert.pem -subj "/C=$CERT_COUNTRY/ST=$CERT_CITY/L=$CERT_CITY/O=$CERT_COMPANY/OU=$CERT_DEPARTMENT/CN=$BOT_DOMAIN")
