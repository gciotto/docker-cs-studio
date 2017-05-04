#
# A Docker container image containing Control System Studio libraries and product.
# It is intended to provide the compiled jar libraries via a p2 repository.
# Port 80 is exposed in order to allow this image to receive HTTP requests.
#
# Gustavo Ciotto Pinton
# Brazilian Synchrotron Light Source Laboratory
# Controls Group
# 

FROM httpd:latest

MAINTAINER Gustavo Ciotto Pinton

# Environment variables
ENV LNLSTUDIO_PATH /opt/${LNLSTUDIO_FDR}
ENV CSSTUDIO_LIB https://github.com/ControlSystemStudio/cs-studio.git
ENV CSSTUDIO_PRODUCT https://github.com/lnls-sirius/org.csstudio.product.git

# Update image and install required packages
RUN apt-get -y update
RUN apt-get install -y git maven

# Clone github repositories and build everything
RUN mkdir -p ${LNLSTUDIO_PATH}/scripts
COPY setup-csstudio.sh \
     setup-product.sh \ 
     /opt/${LNLSTUDIO_FDR}/scripts/

# Clone and compile cs-studio libraries
RUN /opt/${LNLSTUDIO_FDR}/scripts/setup-csstudio.sh

# Clone and build lnls-studio product
RUN /opt/${LNLSTUDIO_FDR}/scripts/setup-product.sh

