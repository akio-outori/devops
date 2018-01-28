#!/bin/bash -x

MONITORING_REPO_PATH=$1
MONTORING_INSTALL_PATH=$2

function install_plugins {
    if [ -d $MONITORING_REPO_PATH ]; then
        cd $MONITORING_REPO_PATH
    else
        echo "${MONITORING_REPO_PATH} does not exist!"
        exit 1
    fi

    ./tools/setup
    ./configure --prefix="${MONITORING_INSTALL_PATH}"
    make
    make install

}

install_plugins
