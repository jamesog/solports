NAME=		subversion
VERSION=	1.6.2
DESC=		Subversion
ARCHES=		sparc i386
CATEGORY=	devel
MAINTAINER=	jamesog@solports.org
BASEDIR=	/usr/local

DIST_SITE=	http://subversion.tigris.org/downloads/

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=$(PREFIX) \
		--with-apr=$(PREFIX)/bin/apr-1-config \
		--with-apr-util=$(PREFIX)/bin/apu-1-config

WITH_SSL=	yes

ifdef WITH_SSL
CONFIGURE_ARGS+=--with-ssl
endif

ifdef WITH_NLS
CONFIGURE_ARGS+=--enable-nls
else
CONFIGURE_ARGS+=--disable-nls
endif

ifdef WITH_BDB
CONFIGURE_ARGS+=--with-berkeley-db
else
CONFIGURE_ARGS+=--without-berkeley-db
endif

include ../../Makefile.common