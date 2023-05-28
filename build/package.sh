#! /bin/bash
set -x

PG_VER=$1
IMAGE=$2

if [ "x${PG_VER}" == "x" ] || [ "x${IMAGE}" == "x" ] ; then
	echo 'usage:  ./package.sh <PG_VER> <image>'
	exit 1
fi

PKG_FORMAT=deb

PG_VER_SHORT=${PG_VER: -2}
echo "    Running pgrx init for ${PG_VER} (${PG_VER_SHORT})"

mkdir -p /home/docker/.pgrx/data-${PG_VER_SHORT}

cargo pgrx init --${PG_VER} /usr/lib/postgresql/${PG_VER_SHORT}/bin/pg_config

echo "Changing to build dir..."
cd /build

OSNAME=$(echo ${IMAGE} | cut -f2-3 -d-)
VERSION=$(cat pgfaker.control | grep default_version | cut -f2 -d\')

echo "pgfaker Building for:  ${OSNAME}-${VERSION}"

PG_CONFIG_DIR=$(dirname $(grep ${PG_VER} ~/.pgrx/config.toml | cut -f2 -d= | cut -f2 -d\"))
export PATH=${PG_CONFIG_DIR}:${PATH}

echo "   Packaging pgrx"
cargo pgrx package || exit $?


#
# cd into the package directory
#
cd target/release/pgfaker-${PG_VER} || exit $?

# strip the binaries to make them smaller
find ./ -name "*.so" -exec strip {} \;

#
# use 'fpm' to build a .deb
#
OUTNAME=pgfaker_${VERSION}_${OSNAME}_${PG_VER}_amd64
if [ "${PKG_FORMAT}" == "deb" ]; then
	rm ${OUTNAME}.deb || true

	fpm \
		-s dir \
		-t deb \
        --force \
		-n pgfaker-${OSNAME}-${PG_VER} \
		-v ${VERSION} \
		--deb-no-default-config-files \
		-p ${OUTNAME}.deb \
		-a amd64 \
		. || exit 1

else
	echo "Unrecognized value for PKG_FORMAT:  ${PKG_FORMAT}"
	exit 1
fi

echo "Packing complete: ${OUTNAME}.deb"