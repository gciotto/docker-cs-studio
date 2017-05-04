#!/bin/bash

# Clone repository
git clone ${CSSTUDIO_LIB} ${LNLSTUDIO_PATH}/cs-studio

cd ${LNLSTUDIO_PATH}/cs-studio

# Build for versions 4.5.x (branch master), 4.4.x (branch 4.4.x) and 4.3.x (branch 4.3.x)
for VERSION in "master" "4.4.x" "4.3.x"
do
    git checkout ${VERSION}
    (cd core && mvn clean install)
    (cd application && mvn clean install)
done 


