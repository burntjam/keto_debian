#!/bin/bash

function build {
    if [ $# -ne 2 ]; then
        echo "Must provide the path to the keto build and version $#"
        exit -1
    fi

    KETO_BUILD=$1
    KETO_VERSION=$2
    KETO_DATE=`date`

    mkdir -p keto/opt/keto/tmp
    mkdir -p keto/opt/keto/document_root
    mkdir -p keto/opt/keto/data
    mkdir -p keto/opt/keto/bin
    mkdir -p keto/opt/keto/log
    mkdir -p keto/opt/keto/keys
    mkdir -p keto/opt/keto/shared
    mkdir -p keto/opt/keto/upgrade

    sed "s/VERSION_TAG/$KETO_VERSION/g" keto/resources/debian/control > keto/debian/control
    sed "s/VERSION_TAG/$KETO_VERSION/g" keto/resources/debian/changelog > keto/debian/changelog
    sed -i "s/DATE_TAG/$KETO_DATE/g" keto/debian/changelog
    echo "$KETO_VERSION" > keto/opt/keto/config/keto_version
    echo "1" > keto/opt/keto/config/auto_upgrade

    cp -f $KETO_BUILD/build/install/bin/* keto/opt/keto/bin/.
    cp -f $KETO_BUILD/build/install/shared/* keto/opt/keto/shared/.
    cp -rf $KETO_BUILD/build/install/keys/* keto/opt/keto/keys/.
    cp -rf $KETO_BUILD/build/install/document_root/* keto/opt/keto/document_root/.
    cp -rf $KETO_BUILD/build/install/upgrade/* keto/opt/keto/upgrade/.

    cd keto && fakeroot debian/rules binary && cd ../


    cd keto/opt/keto/shared/ && tar -zcvf ../../../../keto_shared_$KETO_VERSION.tar.gz * && cd ../../../../
    mkdir $KETO_VERSION
    mv -f keto_${KETO_VERSION}_all.deb $KETO_VERSION
    mv -f keto_shared_$KETO_VERSION.tar.gz $KETO_VERSION
    echo "$KETO_VERSION" > latest_version.txt

    s3cmd --acl-public --recursive put $KETO_VERSION s3://keto-release/linux/ubuntu/
    s3cmd --acl-public --recursive put latest_version.txt s3://keto-release/linux/ubuntu/
    echo "Clean up the version"
    rm -rf $KETO_VERSION
}


function clean {
    cd keto && debian/rules clean && cd ..
    rm -rf keto/opt/keto/bin
    rm -rf keto/opt/keto/shared
    rm -rf keto/opt/keto/keys
    rm -rf keto/opt/keto/document_root
    rm -rf keto/opt/keto/upgrade
}


if [ "$1" ==  "build" ]; then
    build $2 $3
elif [ "$1" ==  "clean" ]; then
    clean
else
    echo "Unrecognised parameters"
    echo "  ./build.sh build <build path> <version>"
    echo "  ./build.sh clean"
fi
