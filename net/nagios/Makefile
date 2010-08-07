NAME=		nagios
VERSION=	3.2.1
DESC=		Nagios
ARCHES=		sparc i386
CATEGORY=	editors
MAINTAINER=	jamesog@solports.org
BASEDIR=	/opt/nagios

DIST_SITE=	http://kent.dl.sourceforge.net/sourceforge/nagios/

CC=gcc

HAS_CONFIGURE=	yes

NAGIOSUSER=	nagios
NAGIOSGROUP=	nagios

NAGIOSHTMURL=	/nagios
NAGIOSCGIURL=	$(NAGIOSHTMURL)/cgi-bin

CONFIGURE_ARGS=	--prefix=$(PREFIX) \
		--sbindir=$(PREFIX)/cgi-bin \
		--with-nagios-user=$(NAGIOSUSER) \
		--with-nagios-group=$(NAGIOSUSER) \
		--with-command-user=$(NAGIOSUSER) \
		--with-command-group=webservd \
		--with-mail=/usr/bin/mailx \
		--with-htmurl=$(NAGIOSHTMURL) \
		--with-cgiurl=$(NAGIOSCGIURL)

INSTALL_TARGET=	install install-commandmode install-config

include ../../Makefile.common
