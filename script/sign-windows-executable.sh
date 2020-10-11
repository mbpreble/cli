#!/bin/bash
set -e

PATH=$1

# Assume we... did something to get the cert downloaded
CERTIFICATE_PATH="testCertificate.pfx"

PASSWORD=${"GITHUB_CERT_PASSWORD"}
PROGRAM_NAME="GitHub CLI"

# Probably need a password for one of these...
openssl pkcs12 -in ${"CERTIFICATE_PATH"} -nocerts -nodes -out key.pem
openssl rsa -in key.pem -outform PVK -pvk-strong -out pvk.pvk
openssl pkcs12 -in ${"CERTIFICATE_PATH"} -nokeys -nodes -out cert.pem
openssl crl2pkcs7 -nocrl -certfile cert.pem -outform DER -out spc.spc

signcode \
  -spc spc.spc
  -v pvk.pvk
  -n ${"PROGRAM_NAME"}
  -t http://timestamp.digicert.com
  -a sha256
