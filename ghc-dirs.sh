#!/bin/sh

[ $# -lt 3 ] && echo "Usage: `basename $0` libdir pkg-ver [dynlibdir|pkglibdir]" && exit 1

set +x

libdir=$1
pkgver=$2

ghc_ver=$(ghc --numeric-version)
cabal_ver=$(ghc-pkg --global --simple-output list Cabal | sed -e "s/Cabal-//")

ghclibdir=${libdir}/ghc-${ghc_ver}

case $cabal_ver in
    1.24.*)
        pkglibdir="${ghclibdir}/${pkgver}-*"
        ;;
    1.22.*)
        pkglibdir="${ghclibdir}/*"
        ;;
    1.18.*)
        pkglibdir="${ghclibdir}/${pkgver}"
        ;;
esac

case $3 in
    dynlibdir)
        case $cabal_ver in
            1.24.0.*)
                echo "${pkglibdir}"
                ;;
            1.24.*)
                echo "$(dirname ${ghclibdir})"
                ;;
            *)
                echo "${pkglibdir}"
                ;;
        esac
        ;;
    pkglibdir)
        echo "${pkglibdir}"
        ;;
esac
