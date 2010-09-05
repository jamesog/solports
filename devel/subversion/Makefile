NAME=		subversion
VERSION=	1.6.9
DESC=		Subversion
ARCHES=		sparc i386
CATEGORY=	devel
MAINTAINER=	james@netinertia.co.uk
BASEDIR=	/usr/local

DIST_SITE=	http://subversion.tigris.org/downloads/

BUILD_DEPENDS=	devel:apr devel:apr-util www:neon28 databases:sqlite
RUN_DEPENDS=	${BUILD_DEPENDS}

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--with-apr=${PREFIX}/bin/apr-1-config \
		--with-apr-util=${PREFIX}/bin/apu-1-config \
		--with-sqlite=${PREFIX} \
		--with-neon=${PREFIX}

WITH_SSL=	yes

.ifdef WITH_SSL
CONFIGURE_ARGS+=--with-ssl
.endif

.ifdef WITH_NLS
CONFIGURE_ARGS+=--enable-nls
.else
CONFIGURE_ARGS+=--disable-nls
.endif

.ifdef WITH_BDB
CONFIGURE_ARGS+=--with-berkeley-db
.else
CONFIGURE_ARGS+=--without-berkeley-db
.endif

.include "../../Mk/port.mk"
