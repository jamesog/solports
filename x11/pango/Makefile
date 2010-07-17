NAME=		pango
VERSION=	1.20.5
DESC=		Pango text rendering library
ARCHES=		sparc
CATEGORY=	net
BASEDIR=	/usr/local

#DIST_SITE=	ftp://ftp.gtk.org/pub/pango/

BUILD_DEPENDS=	devel:glib graphics:cairo

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=$(PREFIX) \
		--sysconfdir=/etc/$(NAME)

include ../../Makefile.common
