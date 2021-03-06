TERMUX_PKG_HOMEPAGE=https://golang.org/
TERMUX_PKG_DESCRIPTION="Go programming language compiler"
local _MAJOR_VERSION=1.9.3
# Use the ~ deb versioning construct in the future:
TERMUX_PKG_VERSION=2:${_MAJOR_VERSION}
TERMUX_PKG_SRCURL=https://storage.googleapis.com/golang/go${_MAJOR_VERSION}.src.tar.gz
TERMUX_PKG_SHA256=4e3d0ad6e91e02efa77d54e86c8b9e34fbe1cbc2935b6d38784dca93331c47ae
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_DEPENDS="clang"

termux_step_make_install () {
	termux_setup_golang

	TERMUX_GOLANG_DIRNAME=${GOOS}_$GOARCH
	TERMUX_GODIR=$TERMUX_PREFIX/lib/go
	rm -Rf $TERMUX_GODIR
	mkdir -p $TERMUX_GODIR/{src,lib,pkg/tool/$TERMUX_GOLANG_DIRNAME,pkg/include,pkg/${TERMUX_GOLANG_DIRNAME}}

	cd $TERMUX_PKG_SRCDIR/src
	env CC_FOR_TARGET=$CC \
	    CXX_FOR_TARGET=$CXX \
	    CC=gcc \
	    GO_LDFLAGS="-extldflags=-pie" \
	    GOROOT_BOOTSTRAP=$GOROOT \
	    GOROOT_FINAL=$TERMUX_GODIR \
	    ./make.bash

	cd ..
	cp bin/$TERMUX_GOLANG_DIRNAME/{go,gofmt} $TERMUX_PREFIX/bin
	cp VERSION $TERMUX_GODIR/
	cp pkg/tool/$TERMUX_GOLANG_DIRNAME/* $TERMUX_GODIR/pkg/tool/$TERMUX_GOLANG_DIRNAME/
	cp -Rf src/* $TERMUX_GODIR/src/
	cp pkg/include/* $TERMUX_GODIR/pkg/include/
	cp -Rf lib/* $TERMUX_GODIR/lib
	cp -Rf pkg/${TERMUX_GOLANG_DIRNAME}/* $TERMUX_GODIR/pkg/${TERMUX_GOLANG_DIRNAME}/
}

termux_step_post_massage () {
	find . -path '*/testdata*' -delete
}
