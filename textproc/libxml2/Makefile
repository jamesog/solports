NAME=		libxml2
VERSION=	2.7.6
DESC=		XML Parser Library
ARCHES=		sparc i386
CATEGORY=	textproc
BASEDIR=	/usr/local

DIST_SITE=	ftp://xmlsoft.org/libxml2/

# Does not compile with Sun Studio - use GCC
#CC=		gcc
CFLAGS+=	-I/usr/local/include
LDFLAGS+=	-L/usr/lib/64 -L/usr/local/lib
MAKE_ENV+=	LIBTOOL=${PREFIX}/bin/libtool
CONFIGURE_ENV+=	LIBTOOL=${PREFIX}/bin/libtool

HAS_CONFIGURE=	yes

.include "../../Mk/port.mk"
