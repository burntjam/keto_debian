#!/bin/bash


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

dpkg-deb --build keto

