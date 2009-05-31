NAME=		apache
VERSION=	2.2.11
DESC=		Apache Web Server
ARCHES=		sparc i386
CATEGORY=	www
MAINTAINER=	jamesog@solports.org
BASEDIR=	/usr/local

DISTNAME=	httpd-$(VERSION)$(EXTRACT_SUFX)
WRKSRC=		$(WRKDIR)/httpd-$(VERSION)
DIST_SITE=	http://www.mirrorservice.org/sites/ftp.apache.org/httpd/$(DISTNAME)

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=$(PREFIX) \
		--enable-layout=FreeBSD \
		--enable-http

ifdef WITH_SSL
CONFIGURE_ARGS+=--enable-ssl
endif

ifdef WITH_DAV
CONFIGURE_ARGS+=--enable-dav
endif

ifdef WITH_SUEXEC
CONFIGURE_ARGS+=--enable-suexec
endif

ifdef WITH_CGI
CONFIGURE_ARGS+=--enable-cgi
endif

ifdef WITH_DAV_FS
CONFIGURE_ARGS+=--enable-dav-fs
endif

ifdef WITH_REWRITE
CONFIGURE_ARGS+=--enable-rewrite
endif

include ../../Makefile.common
