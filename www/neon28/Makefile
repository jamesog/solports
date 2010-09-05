NAME=		neon28
VERSION=	0.29.3
DESC=		HTTP and WebDAV client library
ARCHES=		sparc i386
CATEGORY=	www
MAINTAINER=	james@netinertia.co.uk
BASEDIR=	/usr/local

DISTNAME=	neon-${VERSION}
WRKSRC=		${WRKDIR}/neon-${VERSION}
DIST_SITE=	http://www.webdav.org/neon/

BUILD_DEPENDS=	textproc:expat

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--enable-shared \
		--with-libs=${PREFIX}/ssl:${PREFIX}

CC+=		${CFLAGS}

WITH_SSL?=	yes

.ifdef WITH_SSL
CONFIGURE_ARGS+=--with-ssl
.endif

.ifdef WITH_NLS
CONFIGURE_ARGS+=--enable-nls
.else
CONFIGURE_ARGS+=--disable-nls
.endif

.include "../../Mk/port.mk"
