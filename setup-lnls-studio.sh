#!/bin/bash

cd ${LNLSTUDIO_PATH}

MAVEN_FLAGS="-Dcsstudio.composite.repo=${CSSTUDIO_REPO} -P platform-mars"
MAVEN_GOALS="tycho-p2-director:archive-products"

echo "Building branch ${1} ..."
git checkout ${1}

mvn ${MAVEN_FLAGS} ${MAVEN_GOALS}

mkdir -p ${LNLSTUDIO_REPO}/${2}

cp ${LNLSTUDIO_PATH}/repository/target/products/*.tar.gz ${LNLSTUDIO_REPO}/${2}
cp ${LNLSTUDIO_PATH}/repository/target/products/*.zip ${LNLSTUDIO_REPO}/${2}

# Cleans repository folders before continuing
mvn clean

