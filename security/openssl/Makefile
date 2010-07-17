NAME=		openssl
VERSION=	0.9.8k
DESC=		OpenSSL
ARCHES=		i386 sparc
BASEDIR=	/usr/local

DIST_SITE=	http://www.openssl.org/source/

HAS_CONFIGURE=	true
CONFIGURE_SCRIPT=Configure

ifeq ($(ARCH),sparc)
CFLAGS=		-m64 -xarch=sparc -xtarget=ultra2
CONFIGURE_ARGS= solaris64-sparcv9-cc shared --prefix=$(PREFIX)
else
CONFIGURE_ARGS= solaris64-x86_64-cc shared --prefix=$(PREFIX)
endif

#CONFIGURE_SCRIPT=config
#CONFIGURE_ARGS=	--prefix=$(PREFIX) \
#		--openssldir=$(PREFIX)/openssl \
#		solaris64-sparcv9-gcc 

DESTDIRNAME=	INSTALL_PREFIX

include ../../Makefile.common
