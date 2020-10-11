#!/bin/bash
set -e

EXECUTABLE_PATH=$1

# Assume we... did something to get the cert downloaded
CERTIFICATE_PATH="testCertificate.pfx"

PROGRAM_NAME="GitHub CLI"

# Convert private key to the expected format
openssl pkcs12 -in ${CERTIFICATE_PATH} -nocerts -nodes -out private-key.pem  -passin pass:${GITHUB_CERT_PASSWORD}
openssl rsa -in private-key.pem -outform PVK -pvk-none -out private-key.pvk

# Convert certificate chain into the expected format
openssl pkcs12 -in ${CERTIFICATE_PATH} -nokeys -nodes -out certificate.pem -passin pass:${GITHUB_CERT_PASSWORD}
openssl crl2pkcs7 -nocrl -certfile certificate.pem -outform DER -out certificate.spc

signcode \
  -spc certificate.spc \
  -v private-key.pvk \
  -n $PROGRAM_NAME \
  -t http://timestamp.digicert.com \
  -a sha256 \
$EXECUTABLE_PATH
