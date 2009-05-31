NAME=		squid
VERSION=	2.7.STABLE6
DESC=		Squid Web Proxy
ARCHES=		sparc i386
CATEGORY=	www
MAINTAINER=	jamesog@solports.org
BASEDIR=	/usr/local/squid

DIST_SITE=	http://www.squid-cache.org/Versions/v2/2.7/$(DISTNAME)

SQUIDUID=	squid
SQUIDGID=	squid

WITH_STOREIO_MODULES=aufs ufs
WITH_SNMP=	yes
WITH_ICMP=	yes
WITH_HTCP=	yes
WITH_DEVPOLL=	yes
WITH_LARGEFILES=yes

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=$(PREFIX)

ifdef WITH_STOREIO_MODULES
CONFIGURE_ARGS+=--enable-storeio="$(WITH_STOREIO_MODULES)"
endif

ifdef WITH_SNMP
CONFIGURE_ARGS+=--enable-snmp
endif

ifdef WITH_ICMP
CONFIGURE_ARGS+=--enable-icmp
endif

ifdef WITH_HTCP
CONFIGURE_ARGS+=--enable-htcp
endif

ifdef WITH_DEVPOLL
CONFIGURE_ARGS+=--enable-devpoll
endif

ifdef WITH_LARGEFILES
CONFIGURE_ARGS+=--with-large-files
endif

include ../../Makefile.common
