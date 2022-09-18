#!/bin/bash

cd zeronet-conservancy
git pull

cp ../docker-compose.yml docker-compose.yml
cp ../Dockerfile.integrated_tor Dockerfile.integrated_tor
cp ../torrc.txt torrc

