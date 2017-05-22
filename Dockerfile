#
# A Docker container image containing Control System Studio libraries and product.
# It is intended to provide the compiled jar libraries via a p2 repository.
# Port 80 is exposed in order to allow this image to receive HTTP requests.
#
# Gustavo Ciotto Pinton
# Brazilian Synchrotron Light Source Laboratory
# Controls Group
# 

FROM maven:latest

MAINTAINER Gustavo Ciotto Pinton

# Update image and install required packages
RUN apt-get -y update
RUN apt-get install -y git openjfx xmlstarlet

# CSStudio environment variables
ENV CSSTUDIO_LIB_PATH /opt/cs-studio
ENV CSSTUDIO_LIB https://github.com/ControlSystemStudio/cs-studio.git
ENV CSSTUDIO_LIB_BRANCH 4.4.x
ENV CSSTUDIO_PRODUCT https://github.com/lnls-sirius/org.csstudio.product.git
ENV CSSTUDIO_REPO ${CSSTUDIO_LIB_PATH}/repository

# Clone repository - since it takes a reasonable time, we moved this command out 
# from setup-csstudio.sh, in order to take advantage of the Docker cache mechanism
RUN git clone --branch ${CSSTUDIO_LIB_BRANCH}  ${CSSTUDIO_LIB} ${CSSTUDIO_LIB_PATH}/cs-studio

RUN java -version

RUN mkdir ${CSSTUDIO_REPO}

# We use the same cache mechanism to analyze maven dependencies and download maven plugins
RUN (cd ${CSSTUDIO_LIB_PATH}/cs-studio/core && mvn clean)
RUN (cd ${CSSTUDIO_LIB_PATH}/cs-studio/applications && mvn clean)

# Build everything
RUN mkdir -p ${CSSTUDIO_LIB_PATH}/scripts
COPY setup-csstudio.sh \
    setup-lnls-studio.sh \ 
    ${CSSTUDIO_LIB_PATH}/scripts/

# Compile cs-studio libraries
RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-csstudio.sh master 4.5 core
RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-csstudio.sh master 4.5 applications

RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-csstudio.sh 4.4.x 4.4 core
RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-csstudio.sh 4.4.x 4.4 applications

# LNLS Studio environment variables
ENV LNLSTUDIO_PATH /opt/lnlstudio
ENV LNLSTUDIO_GIT https://github.com/lnls-sirius/org.csstudio.product.git
ENV LNLSTUDIO_REPO ${LNLSTUDIO_PATH}/repository

RUN git clone ${LNLSTUDIO_GIT} ${LNLSTUDIO_PATH}

RUN mkdir -p ${LNLSTUDIO_REPO}

# Clone and build lnls-studio product
RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-lnls-studio.sh master 4.5.1
RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-lnls-studio.sh 4.4.x 4.4.2
RUN ${CSSTUDIO_LIB_PATH}/scripts/setup-lnls-studio.sh 4.3.x 4.3.5

# Remove maven local repository - enable this if you are not going to test new 
# RUN /root/.m2

# Setting HTTPD apache server up
RUN apt-get install -y apache2

# Point to folders 
RUN ln -s ${LNLSTUDIO_REPO} /var/www/html/lnls-studio

CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]

