NAME=		snort
VERSION=	2.8.4.1
DESC=		Open Source Network Intrusion Detection
ARCHES=		sparc
CATEGORY=	security
BASEDIR=	/usr/local

BUILD_DEPENDS=	net:libpcap devel:pcre
RUN_DEPENDS=	net:libpcap devel:pcre

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--sysconfdir=/etc/snort \
		--enable-perfprofiling \
		--with-mysql

.include "../../Mk/port.mk"
