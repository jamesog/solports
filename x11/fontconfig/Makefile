NAME=		fontconfig
VERSION=	2.6.0
DESC=		Library for font customization
ARCHES=		sparc
CATEGORY=	net
BASEDIR=	/usr/local

GNUMAKE=	${MAKE}
BUILD_DEPENDS=	print:freetype textproc:expat

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--sysconfdir=/etc/${NAME} \
		--disable-docs

.include "../../Mk/port.mk"
