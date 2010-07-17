NAME=		glib
VERSION=	2.20.3
DESC=		GLib
ARCHES=		sparc
CATEGORY=	net
BASEDIR=	/usr/local

BUILD_DEPENDS=	devel:automake110 devel:pkg-config
RUN_DEPENDS=	$(BUILD_DEPENDS)

HAS_CONFIGURE=	yes
#CONFIGURE_SCRIPT=autogen.sh
CONFIGURE_ARGS=	--prefix=$(PREFIX) \
		--disable-gtk-doc \
		--disable-man \
		--disable-fam

include ../../Makefile.common
