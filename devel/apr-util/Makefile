NAME=		apr-util
VERSION=	1.3.9
DESC=		Apache Portable Runtime Utility Library
ARCHES=		sparc i386
CATEGORY=	devel
MAINTAINER=	james@netinertia.co.uk
BASEDIR=	/usr/local

DIST_SITE=	http://www.mirrorservice.org/sites/ftp.apache.org/apr/

BUILD_DEPENDS=	devel:apr

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	--prefix=${PREFIX} \
		--with-apr=${PREFIX}/bin/apr-1-config

.include "../../Mk/port.mk"
