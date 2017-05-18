#!/bin/bash

cd ${CSSTUDIO_LIB_PATH}/cs-studio
        
# Activates maven profile
MAVEN_FLAGS="-P uploadRepo"

if [ "${3}" == "applications" ] ; then
        MAVEN_APP_FLAGS="-Dcsstudio.composite.repo=${CSSTUDIO_REPO}/core/${2}"
else
        MAVEN_APP_FLAGS=""
fi

MAVEN_GOALS=verify

echo "Building branch ${1} ..."
git checkout ${1}

(cd ${3} && sed -i "s~<upload.root>.*$~<upload.root>file://${CSSTUDIO_REPO}/</upload.root>~" pom.xml && mvn ${MAVEN_FLAGS} ${MAVEN_APP_FLAGS} ${MAVEN_GOALS})

git checkout ${3}/pom.xml

ls -l ${CSSTUDIO_REPO}


