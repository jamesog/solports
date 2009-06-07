NAME=		neon28
VERSION=	0.28.4
DESC=		HTTP and WebDAV client library
ARCHES=		sparc i386
CATEGORY=	www
MAINTAINER=	jamesog@solports.org
BASEDIR=	/usr/local

DISTNAME=	neon-$(VERSION)$(EXTRACT_SUFX)
WRKSRC=		$(WRKDIR)/neon-$(VERSION)
DIST_SITE=	http://www.webdav.org/neon/

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=$(PREFIX)

WITH_SSL?=	yes

ifdef WITH_SSL
CONFIGURE_ARGS+=--with-ssl
endif

ifdef WITH_NLS
CONFIGURE_ARGS+=--enable-nls
else
CONFIGURE_ARGS+=--disable-nls
endif

include ../../Makefile.common
