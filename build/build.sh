#!/bin/bash

BUILDDIR=`pwd`
BASE=$(dirname `pwd`)
VERSION=$(cat $BASE/pgfaker.control | grep default_version | cut -f2 -d\')
LOGDIR=${BASE}/target/logs
ARTIFACTDIR=${BASE}/target/artifacts
PGRXVERSION=0.10.2

#PG_VERS=("pg12" "pg13" "pg14" "pg15" "pg16")
PG_VERS=("pg16")

echo $BASE
echo $VERSION
echo $LOGDIR
echo $ARTIFACTDIR
echo "pgrx Version: ${PGRXVERSION}"

mkdir -p ${LOGDIR}
mkdir -p ${ARTIFACTDIR}


for image in `ls docker/  ` ; do

    OS_DIST=$(echo ${image}|cut -f2 -d-)
    OS_VER=$(echo ${image}|cut -f3 -d-)

    echo $OS_DIST
    echo $OS_VER
    echo "Pg Version: ${PG_VER}"

    cd ${BUILDDIR}

    cd docker/${image}
    echo "  Building Docker image: ${image}"
    docker build -t ${image} --build-arg PGRXVERSION=${PGRXVERSION}  . 2>&1 > ${LOGDIR}/${image}-build.log || exit 1

    for PG_VER in ${PG_VERS[@]} ; do

        echo "Build pgfaker: ${image}-${PG_VER}"
        docker run \
            -e pgver=${PG_VER} \
            -e image=${image} \
            -v ${BASE}:/build \
            --rm \
            ${image} \
            /bin/bash -c '/build/build/package.sh ${pgver} ${image}' \
                > ${LOGDIR}/${image}-${PG_VER}-package.sh.log 2>&1 || echo 'Building this version might have encountered error.'

        echo "${image}-${PG_VER}:  finished"
    done

done

echo 'Built packages are available under ../target/release/pgfaker-pgXX/'
