#!/bin/sh

[ $# -lt 3 ] && echo "Usage: `basename $0` libdir pkg-ver [dynlibdir|pkglibdir]" && exit 1

set +x

libdir=$1
pkgver=$2

GHC_VER=$(ghc --numeric-version)

ghclibdir=${libdir}/ghc-${GHC_VER}

case $GHC_VER in
    8.0.*)
        pkglibdir="${ghclibdir}/${pkgver}-*"
        ;;
    7.10.*)
        pkglibdir="${ghclibdir}/*"
        ;;
    7.8.*)
        pkglibdir="${ghclibdir}/${pkgver}"
esac

case $3 in
    dynlibdir)
        if [ "$GHC_VER" = "8.0.1.20161117" ]; then
            echo "$(dirname ${ghclibdir})"
        else
            echo "${pkglibdir}"
        fi
        ;;
    pkglibdir)
        echo "${pkglibdir}"
        ;;
esac
