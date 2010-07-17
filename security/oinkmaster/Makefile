NAME=		oinkmaster
VERSION=	2.0
DESC=		Utility for managing and updating Snort rules
ARCHES=		sparc
CATEGORY=	security
BASEDIR=	/usr/local

NO_BUILD=	true

include ../../Makefile.common

fakeinstall:
	@mkdir -p $(WRKINST)/etc
	@cp -p $(WRKSRC)/oinkmaster.conf $(WRKINST)/etc
	@mkdir -p $(WRKINST)/$(PREFIX)/bin
	@cp -p $(WRKSRC)/oinkmaster.pl $(WRKINST)/$(PREFIX)/bin/oinkmaster
	@mkdir -p $(WRKINST)/$(PREFIX)/man/man1
	@cp -p $(WRKSRC)/oinkmaster.1 $(WRKINST)/$(PREFIX)/man/man1

