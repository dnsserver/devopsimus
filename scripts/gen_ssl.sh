#!/bin/bash

# From:
# https://github.com/grpc/grpc-java/tree/master/examples/example-tls#generating-self-signed-certificates-for-use-with-grpc

# Changes these CN's to match your hosts in your environment if needed.
SERVER_CN=localhost
mkdir -p ./sslcert-${SERVER_CN}
pushd ./sslcert-${SERVER_CN}
echo "Enter password for CA: "
read -s password
echo Generate CA key:
openssl genrsa -passout pass:$password -des3 -out ca.key 4096
echo Generate CA certificate:
# Generates ca.crt which is the trustCertCollectionFile
openssl req -passin pass:$password -new -x509 -days 365 -key ca.key -out ca.crt -subj "/CN=${SERVER_CN}"

######## Server ############
echo Generate server key:
openssl genrsa -passout pass:$password -des3 -out server.key 4096
echo Generate server signing request:
openssl req -passin pass:$password -new -key server.key -out server.csr -subj "/CN=${SERVER_CN}"
echo Self-signed server certificate:
# Generates server.crt which is the certChainFile for the server
openssl x509 -req -passin pass:$password -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt 
echo Remove passphrase from server key:
openssl rsa -passin pass:$password -in server.key -out server.key
# Generates server.pem which is the privateKeyFile for the Server
openssl pkcs8 -topk8 -nocrypt -in server.key -out server.pem

popd
