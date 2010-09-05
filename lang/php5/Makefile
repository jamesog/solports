NAME=		php
VERSION=	5.2.10
DESC=		PHP: Hypertext Preprocessor
ARCHES=		sparc i386
CATEGORY=	lang
BASEDIR=	/usr/local

WITH_FASTCGI=	true
WITH_MYSQL=	true
WITH_OPENSSL=	true

BUILD_DEPENDS=	www:apache22 devel:pkg-config security:openssl
RUN_DEPENDS=	www:apache22 security:openssl

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--sysconfdir=/etc/${NAME} \
		--with-apxs2 \
		--with-openssl=/usr/local/include/openssl \
		--with-zlib \
		--enable-ftp \
		--with-gd

LDFLAGS=	"-R /usr/local/lib"

.ifdef WITH_FASTCGI
CONFIGURE_ARGS+=--enable-fastcgi
.endif

.ifdef WITH_MYSQL
CONFIGURE_ARGS+=--with-mysql
.endif

.ifdef WITH_OPENSSL
CONFIGURE_ARGS+=--with-openssl=/usr/local/ssl
.endif

.include "../../Mk/port.mk"
