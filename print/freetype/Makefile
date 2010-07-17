NAME=		freetype
VERSION=	2.3.9
DESC=		Freetype Font Engine
ARCHES=		sparc
CATEGORY=	net
BASEDIR=	/usr/local

GNUMAKE=	gmake
BUILD_DEPENDS=	devel:pkg-config devel:libtool

HAS_CONFIGURE=	yes
CONFIGURE_ENV+=	gmake
MAKE_ENV+=	gmake
#CONFIGURE_ARGS=	--prefix=$(PREFIX) \
#		--without-zlib

include ../../Makefile.common
