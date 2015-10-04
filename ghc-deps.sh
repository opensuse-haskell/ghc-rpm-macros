#!/bin/sh
# find rpm requires for Haskell GHC libraries

[ $# -ne 1 ] && echo "Usage: `basename $0` %{buildroot}%{ghclibdir}" && exit 1

set +x

PKGBASEDIR=$1
PKGCONFDIR=$PKGBASEDIR/package.conf.d

files=$(cat)

for i in $files; do
    case $i in
        # exclude builtin_rts.conf
	$PKGCONFDIR/*-*.conf)
	    PKGVER=$(echo $i | sed -e "s%$PKGCONFDIR/\(.\+\)-.\+.conf%\1%")
	    DEPS=$(/usr/libexec/ghc-pkg-wrapper $PKGBASEDIR field $PKGVER depends | sed -e "s/^depends: \+//" -e "s/builtin_rts//" -e "s/\(bin-package-db\|ghc-prim\|integer-gmp\)-[^ ]\+//")
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
