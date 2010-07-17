NAME=		zlib
VERSION=	1.2.3
DESC=		zlib compression library
ARCH=		sparc
CATEGORY=	application
VENDOR=		http://www.zlib.net packaged for MHCB
BASEDIR=	/usr/local

HAS_CONFIGURE=	true
CONFIGURE_ARGS=	--shared --prefix=$(PREFIX)
DESTDIRNAME=	prefix
FAKE_PREFIX=	$(WRKINST)$(PREFIX)

include ../../Makefile.common
