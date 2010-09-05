NAME=		barnyard
VERSION=	0.2.0
DESC=		Output system for Snort
ARCHES=		sparc
CATEGORY=	security
BASEDIR=	/usr/local

#BUILD_DEPENDS=	devel:autoconf263 devel:automake111
#BUILD_DEPENDS=	databases:mysql41
RUN_DEPENDS=	databases:mysql41 security:snort

EXTRA_FILES=	barnyard.conf=/etc/snort/barnyard.conf

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--sysconfdir=/etc/${NAME} \
		--enable-mysql

LDFLAGS+=	-lresolv
#CFLAGS+=	-I/usr/local/include/openssl -L/usr/local/lib
#CPPFLAGS+=	-I/usr/local/include/openssl -L/usr/local/lib
#CXXFLAGS+=	-I/usr/local/include/openssl -L/usr/local/lib

INSTALL_TARGETS=install install-data

.include "../../Mk/port.mk"
