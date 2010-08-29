NAME=		bind
PKGNAMESUFFIX=	96
VERSION=	9.6.1-P3
DESC=		ISC BIND DNS Server
ARCH=		sparc
CATEGORY=	application
BASEDIR=	/usr/local

DIST_SITE=	ftp://ftp.isc.org/isc/bind9/$(VERSION)/

#DISTNAME=	httpd-$(VERSION)$(EXTRACT_SUFX)
#WRKSRC=		$(WRKDIR)/httpd-$(VERSION)

INSTALL_SCRIPTS=checkinstall preinstall postinstall
REMOVE_SCRIPTS=	preremove

RUN_DEPENDS=	security:openssl

SMF_MANIFEST=	bind96.xml
SMF_METHOD=	dns-server

HAS_CONFIGURE=	true
CONFIGURE_ARGS=	--prefix=$(PREFIX) --sysconfdir=/etc/namedb

include ../../Makefile.common
