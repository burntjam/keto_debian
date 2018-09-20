#!/bin/bash

function build {
    if [ $# -ne 1 ]; then
        echo "Must provide the path to the keto build"
        exit -1
    fi

    KETO_BUILD=$1

    mkdir -p keto/opt/keto/tmp
    mkdir -p keto/opt/keto/document_root
    mkdir -p keto/opt/keto/data
    mkdir -p keto/opt/keto/bin
    mkdir -p keto/opt/keto/log
    mkdir -p keto/opt/keto/keys
    mkdir -p keto/opt/keto/shared

    cp -f $KETO_BUILD/build/install/bin/* keto/opt/keto/bin/.
    cp -f $KETO_BUILD/build/install/shared/* keto/opt/keto/shared/.
    cp -rf $KETO_BUILD/build/install/keys/* keto/opt/keto/keys/.
    cp -rf $KETO_BUILD/build/install/document_root/* keto/opt/keto/document_root/.

    cd keto && fakeroot debian/rules binary
}


function clean {
    rm -rf keto/opt/keto/bin
    rm -rf keto/opt/keto/shared
    rm -rf keto/opt/keto/keys
    rm -rf keto/opt/keto/document_root
}


if [ "$1" -eq  "build" ]; then
    build $2
elif ["$1" -eq  "build" ]; then
    clean
else
    echo "Unrecognised parameters"
    echo "\t./build.sh build <build path>"
    echo "\t./build.sh clean"
fi
