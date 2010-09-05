NAME=		snortnotify
VERSION=	2.0
DESC=		Provides email reports of Snort alerts
ARCHES=		sparc
CATEGORY=	security
BASEDIR=	/usr/local

DISTNAME=	${NAME}-v2${EXTRACT_SUFX}
WRKSRC=		${WRKDIR}/${NAME}-v${VERSION}

NO_BUILD=	true

.include "../../Mk/port.mk"

# XXX: Must be a better way to do this!
fakeinstall:
	@mkdir -p ${WRKINST}/etc
	@cp -p ${WRKSRC}/SnortNotify.conf ${WRKINST}/etc
	@mkdir -p ${WRKINST}/${PREFIX}/bin
	@cp -p ${WRKSRC}/SnortNotify.pl ${WRKINST}/${PREFIX}/bin
	@mkdir -p ${WRKINST}/${PREFIX}/share/${NAME}
	@cp -p ${WRKSRC}/SnortNotify.sql ${WRKINST}/${PREFIX}/share/${NAME}

