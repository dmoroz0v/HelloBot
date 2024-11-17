#!/bin/sh
sh ./Cert/make_cert.sh
exec ./App "$@"
