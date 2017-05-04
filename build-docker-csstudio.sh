#!/bin/bash

#
# A simple bash script to build a Docker image containing cs-studio plugins and products
#
# Gustavo Ciotto Pinton
#

. ./env-vars-specific.sh


        docker build --build-arg ARCHAPPL_MYIDENTITY=${ARCHAPPL_MYIDENTITY} --build-arg APPLIANCE_UNIT=${APPLIANCE} -t ${DOCKER_MANTAINER_NAME}/${DOCKER_NAME}-${APPLIANCE} .
        echo "Ok!"
done
