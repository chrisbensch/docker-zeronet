#!/bin/bash

cd zeronet-conservancy
git pull

cp ../docker-compose.yml docker-compose.yml
cp ../Dockerfile.integrated_tor Dockerfile.integrated_tor
cp ../torrc.txt torrc

docker build . -F Dockerfile.integrated_tor -t chrisbensch/docker-zeronet:latest
