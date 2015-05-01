#!/bin/sh
# find rpm requires for Haskell GHC libraries

[ $# -ne 1 ] && echo "Usage: `basename $0` %{buildroot}%{ghclibdir}" && exit 1

set +x

PKGBASEDIR=$1
PKGCONFDIR=$PKGBASEDIR/package.conf.d
GHC_VER=$(basename $PKGBASEDIR | sed -e s/ghc-//)

# for a ghc build use the new ghc-pkg
INPLACE_GHCPKG=$PKGBASEDIR/../../bin/ghc-pkg-$GHC_VER

if [ -x "$INPLACE_GHCPKG" ]; then
    case $GHC_VER in
        7.8.*)
            GHC_PKG="$PKGBASEDIR/bin/ghc-pkg --global-package-db=$PKGCONFDIR"
            ;;
        7.6.*)
            GHC_PKG="$PKGBASEDIR/ghc-pkg --global-package-db=$PKGCONFDIR"
            ;;
        *)
            GHC_PKG="$PKGBASEDIR/ghc-pkg --global-conf=$PKGCONFDIR"
            ;;
    esac
else
    GHC_PKG="/usr/bin/ghc-pkg-${GHC_VER}"
fi

files=$(cat)

for i in $files; do
    case $i in
        # exclude builtin_rts.conf
	$PKGCONFDIR/*-*.conf)
	    PKGVER=$(echo $i | sed -e "s%$PKGCONFDIR/\(.\+\)-.\+.conf%\1%")
	    DEPS=$(${GHC_PKG} -f $PKGCONFDIR field $PKGVER depends | sed -e "s/^depends: \+//" -e "s/builtin_rts//" -e "s/\(bin-package-db\|ghc-prim\|integer-gmp\)-[^ ]\+//")
	    for d in $DEPS; do
		case $d in
		    *-*) echo "$d" | sed -e "s%\(.\+\)-\(.\+\)-.\+%ghc-\1-devel = \2%" ;;
		    *) ;;
		esac
	    done
	    ;;
        *)
            ;;
    esac
done
