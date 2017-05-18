#!/bin/bash

#
# A simple bash script to build a Docker image containing cs-studio plugins and products
#
# Gustavo Ciotto Pinton
#

. ./env-vars.sh

docker build -t ${DOCKER_MANTAINER_NAME}/${DOCKER_NAME} .

