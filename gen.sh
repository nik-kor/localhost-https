#!/bin/bash

mkdir -p dist
cd dist

echo "Generating root CA"

passphrase="1234" # it's only for dev
rootCAName="my dev root cert"

openssl genrsa -des3 -passout pass:$passphrase -out rootCA.key 2048
openssl req -x509 -new -nodes -passin pass:$passphrase -key rootCA.key -sha256 -days 1024 -out rootCA.pem -subj "/CN=$rootCAName"
    # if you need more data in cert:
    # -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

# In attempt to automate the legalization of root CA

unamestr=`uname`

echo "Installing your root CA"

# should work on ubuntu/debian
if [[ "$unamestr" == 'Linux' ]]; then
    openssl x509 -outform der -in rootCA.pem -out rootCA.crt
    cp ./rootCA.crt /usr/local/share/ca-certificates
    sudo update-ca-certificates
elif [[ "$unamestr" == "Darwin" ]]; then
    which -s security

    if [ $? -ne 0 ]; then
        echo "!IMPORTANT! please add rootCA.pem to the list of trusted SSL certificates with keychain"
    else
        sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./rootCA.pem
    fi
else
    echo "!IMPORTANT! please add rootCA.pem to the list of trusted SSL certificates in your system"
fi

echo "Generating self-signed keys"

openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -subj "/CN=localhost" -passout pass:$passphrase
openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 500 -sha256 -extfile ../v3.ext -passin pass:$passphrase

echo "All good - just use dist/server.key and dist/server.crt in your http server"
