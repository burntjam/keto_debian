#!/bin/bash


if [ $# -ne 1 ]; then
	echo "Must provide the path to the keto build"
    exit -1
fi

KETO_BUILD=$1

cp -f $KETO_BUILD/build/install/bin/* keto/opt/keto/bin/.
cp -f $KETO_BUILD/build/install/shared/* keto/opt/keto/shared/.
cp -rf $KETO_BUILD/build/install/keys/* keto/opt/keto/keys/.
cp -rf $KETO_BUILD/build/install/document_root/* keto/opt/keto/document_root/.

dpkg-deb --build keto

