# vi:set ts=4:
##########
#
# Solaris Package System
#
##########
#
# **************************************************
# * Please view me with 4-column tabs! (:set ts=4) *
# **************************************************
#
# Variables which may be used in package Makefiles:
#
# REQUIRED VARIABLES
#
# NAME				- Short package name
# VERSION			- The software version
# DESC				- Short description of package
# ARCHES			- Architectures on which this package will work,
#						e.g. sparc, i386, all
# CATEGORY			- Package category e.g. application
# MAINTAINER		- E-mail address of package maintainer
#
# OPTIONAL VARIABLES
#
# PKGPREFIX			- Short code prefixed to package name (SVr4 only).
#					  Default: PORT
# PKGREVISION		- The package revision
# LONGDESC			- Longer description of the package (<255 chars)
# VENDOR			- Vendor description
# BASEDIR			- Default location to install if relocatable
# EXTRACT_SUFX		- Distribution file suffix
#					  Default: .tar.gz
# INSTALL_SCRIPTS	- Scripts to run during install
# REMOVE_SCRIPTS	- Scripts to run on remove
# SMF_MANIFEST		- SMF manifest to install
# SMF_METHOD		- SMF method to install (requires SMF_MANIFEST)
# BUILD_DEPENDS		- Space-separated list of packages to required to build
# RUN_DEPENDS		- Space-separated list of packages to required to run
# CONFLICTS			- Space-separated list of packages which conflict
# EXTRA_FILES		- List of files to be copied into the package
#
# The following affect build options:
#
# PREFIX			- Install prefix for package files. Usually BASEDIR.
#					  Default: /usr/local if BASEDIR unset
#					           ${BASEDIR} if BASEDIR is set
# NO_BUILD			- If set, do not attempt to call make(1) at any stage.
# HAS_CONFIGURE		- If set, the software uses a configure script. The
#					  configure stage will not do anything if this is
#					  not set.
# CONFIGURE_SCRIPT	- Name of configure script.
#					  Default: configure
# CONFIGURE_ARGS	- Arguments to pass to configure.
#					  Default: "--prefix=${PREFIX}"
# MAKE_ARGS			- Arguments to pass to make.
#					  Default: none
#
# PACKAGE OPTIONS
#
# PKGFORMAT			- 'ips' or 'svr4' - determined automatically if not
#					  specified.
# IPSREPO			- URI of IPS repository
#					  Default: http://localhost:10000/
#
# The following are set automatically. Do not set them unless you
# know what you are doing!
#
# PKGINFO			- Location of the pkginfo file
#					  Default: ${PKGDIR}/pkginfo
# PROTOTYPE			- Location of the prototype file
#					  Default: ${PKGDIR}/Prototype
# DISTINFO			- Location of the distribution info file (contains checksums)
#					  Default: ${PKGDIR}/distinfo
# SPOOLDIR			- Working directory for pkgmk(1)
#					  Default: ${PKGDIR}/spool
# CLASSES			- The classes used in the prototype file
#					  Default: "none" if SMF_MANIFEST is not set
#					           "none smf" if SMF_MANIFEST is set
# PKGSTORE			- Where datastream packages are stored
#					  Default: ${PORTSDIR}/packages
#
##########
#
# Available targets:
#
# fetch				- Fetches the source distfile(s)
# checksum			- Checks the validity of downloaded distfiles
# extract			- Extract the sources to ${WRKSRC}
# configure			- Run the configure script, if HAS_CONFIGURE is defined
# build				- Default target
# fakeinstall		- Installs to ${WRKINST}
# install			- Alias of fakeinstall
# prototype			- Generate the Prototype file
# pkginfo			- Generate the pkginfo file
# pkg				- Build the package datastream
#
# reconfigure		- Re-run configure target
# rebuild			- Re-run build target
#
# clean				- Remove ${WRKDIR} and all working data
#
# makesum			- Creates the DISTINFO file
#
##########
#
# Standard variables
#
#####
PORTSDIR?=	/export/pkg
PKGSTORE?=	${PORTSDIR}/packages
PKGPREFIX?=	PORT
DISTDIR?=	${PORTSDIR}/distfiles

# Package defaults
PKGNAME?=	${NAME}${PKGNAMESUFFIX}-${VERSION}
PKGDIR?=	${.CURDIR}
SPOOLDIR?=	${PKGDIR}/spool
PKGINFO?=	${WRKDIR}/pkginfo
PROTOTYPE?=	${PKGDIR}/Prototype
DEPENDFILE?=	${WRKDIR}/depend
# IPS
METADATA?=	${WRKDIR}/metadata
IPSREPO?=	http://localhost:10000/

WRKDIR?=	${PKGDIR}/work
WRKSRC?=	${WRKDIR}/${NAME}-${VERSION}
WRKINST?=	${WRKDIR}/root
FILESDIR?=	${PKGDIR}/files
SMFDIR?=	${PKGDIR}/smf
DISTINFO?=	${PKGDIR}/distinfo
CLASSES?=	none
DISTNAME?=	${NAME}-${VERSION}
DISTFILES?=	${DISTNAME}${EXTRACT_SUFX}
EXTRACT_SUFX?=	.tar.gz
.ifndef BASEDIR
PREFIX?=	/usr/local
.else
PREFIX?=	${BASEDIR}
.endif
CONFIGURE_ARGS?=--prefix=${PREFIX}
FAKE_PREFIX?=${WRKINST}

CHECKINSTALL?=	${PKGDIR}/checkinstall
PREINSTALL?=	${PKGDIR}/preinstall
POSTINSTALL?=	${PKGDIR}/postinstall
PREREMOVE?=		${PKGDIR}/preremove
POSTREMOVE?=	${PKGDIR}/postremove

TMPPROTOTYPE?=	${WRKDIR}/.Prototype.mktmp

# Default maintainer
MAINTAINER?=	ports@openindiana.org

# Get the machine arch
.ifndef ARCH
ARCH!=		uname -p
ISAINFO_B!=	isainfo -b
CFLAGS+=	-m${ISAINFO_B}
CXXFLAGS+=	-m${ISAINFO_B}
.endif

.if ${ARCH:Mamd64} || ${ARCH:Msparcv9}
ARCH_IS_64BIT=	true
.endif

.if ${.CURDIR} != ${PKGDIR}
.if defined(ARCHES) && empty(ARCHES:M${ARCH})
.error ${PKGNAME} does not run on the ${ARCH} platform.
.endif
.endif

UNAME_R!=	uname -r

.ifndef PKGFORMAT
.if ${UNAME_R} == 5.11
PKGFORMAT=	ips
.else
PKGFORMAT=	svr4
.endif
.endif

CC?=	gcc
CXX?=	g++

MAKE_CONF?=/etc/make.conf

# Application paths
AWK?=	/usr/xpg4/bin/awk
# XXX: do not use env -i unless you set PATH somewhere...
ENV?=	/usr/bin/env
TAR?=	/usr/sfw/bin/gtar
TRUE?=	/usr/bin/true
WGET?=	/usr/sfw/bin/wget

ALL_FAKE_FLAGS?=${DESTDIRNAME}=${FAKE_PREFIX}
_FAKE_SETUP=	PREFIX=${WRKINST} ${DESTDIRNAME}=${WRKINST}
MAKE_ENV+=		PREFIX=${PREFIX} CC="${CC}" CFLAGS="${CFLAGS}" \
				CXX=${CXX} CXXFLAGS="${CXXFLAGS}" \
				LDFLAGS="${LDFLAGS}" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}" \
				CXXLDFLAGS="${CXXLDFLAGS}"
CONFIGURE_SCRIPT?=configure
DESTDIRNAME?=	DESTDIR
ALL_TARGET?=	all
INSTALL_TARGET?=install

CONFIGURE_ENV+=	PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig \
				CC="${CC}" CFLAGS="${CFLAGS}" CXX=${CXX} CXXFLAGS="${CXXFLAGS}" \
				LDFLAGS="${LDFLAGS}" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}" \
				CXXLDFLAGS="${CXXLDFLAGS}"
.if ${EXTRACT_SUFX} == .tar.gz
EXTRACT_CMD?=	/usr/bin/gzip
.else
.if ${EXTRACT_SUFX} == .tar.bz2
EXTRACT_CMD?=	/usr/bin/bzip2
.endif
.endif

FETCH_CMD?=		${WGET}
FIND_CMD?=		/usr/bin/find

EXTRACT_BEFORE_ARGS?=	-dc
EXTRACT_AFTER_ARGS?=	| ${TAR} xf -

#ifdef BASEDIR
FIND_AFTER_ARGS?=	| sort
# Strip the leading / from the PREFIX
FIND_NON_PREFIX?=	| grep -v ${PREFIX:/%=%}
#else
#FIND_AFTER_ARGS?=	| sed -e 's,^,/,'
#endif

#PKGPROTO_AFTER_ARGS=	`echo ${PREFIX} | sed -e 's,^/,,'`=${PREFIX}
_WRKINST=			${WRKINST:S/${PKGDIR}\///}
PKGPROTO_AFTER_ARGS=	| ${AWK} '{print $$1,$$2,"/" $$3 "=${_WRKINST}/" $$3,$$4,$$5,$$5}'
#PKGPROTO_AFTER_ARGS=	| ${AWK} '{print $$1,$$2,"/" $$3 "=./" $$3,$$4,$$5,$$5}'
PKGADD_ARGS?=	-G

PROTO_SUB+=	PREFIX=${PREFIX} PKGDIR=${PKGDIR} WRKDIR=${WRKDIR} SMFDIR=${SMFDIR} WRKINST=${WRKINST}

# How to do nothing.
DO_NADA?=	${TRUE}

CHECKSUM_ALGORITHMS?=	sha256

# Add PKGREVISION to the package file name if it is set
.ifdef PKGREVISION
PKGFILE?=	${PKGNAME}_${PKGREVISION}_${ARCH}.pkg
.else
PKGFILE?=	${PKGNAME}_${ARCH}.pkg
.endif

.if ${.CURDIR} != ${PKGDIR}
# The following are required in pkginfo(4), so check for them here
.ifndef ARCH
.error ARCH must be defined
.endif
.ifndef CATEGORY
.error CATEGORY must be defined
.endif
.ifndef DESC
.error DESC must be defined
.endif
.ifndef NAME
.error NAME must be defined
.endif
.ifndef VERSION
.error VERSION must be defined
.endif
.endif

# Alter CLASSES if SMF is used
.ifdef SMF_MANIFEST
CLASSES	+=	smf
.endif

all: build

# XXX: This needs fixing since implementing categories!
show-depends:
.ifdef BUILD_DEPENDS
	@echo "==> ${PKGNAME} has the following build dependencies:"
.for dep in ${BUILD_DEPENDS}
	@echo "  ${dep:S/:/\//}"
.endfor
.for dep in ${BUILD_DEPENDS}
	@cd ${PORTSDIR}/${dep:S/${PKGNAMEPREFIX}//:S/:/\//} && \
		${MAKE} -s show-depends
.endfor
.endif
.ifdef RUN_DEPENDS
	@echo "==> ${PKGNAME} has the following runtime dependencies:"
.for dep in ${RUN_DEPENDS}
	@echo "  ${dep:S/:/\//}"
.endfor
.for dep in ${RUN_DEPENDS}
	@cd ${PORTSDIR}/${dep:S/${PKGNAMEPREFIX}//:S/:/\//} && \
		${MAKE} -s show-depends
.endfor
.endif

makesum:
	@if [ -f ${DISTINFO} ]; then cat /dev/null > ${DISTINFO}; fi
	@cd ${DISTDIR}; \
	if [ -n "${DISTFILES}" ]; then \
	for file in ${DISTFILES}; do \
		for alg in ${CHECKSUM_ALGORITHMS}; do \
			digest -v -a $$alg $$file >> ${DISTINFO}; \
		done; \
	done; \
	fi

checksum: fetch
	@if [ -n "${DISTFILES}" ]; then \
		cd ${DISTDIR}; \
		for file in "${DISTFILES}"; do \
			for alg in ${CHECKSUM_ALGORITHMS}; do \
				cksum=`${AWK} -v alg=$$alg -v file=$$file '$$1 == alg && $$2 == "(" file ")" {print $$4}' ${DISTINFO}`; \
				mksum=`digest -a $$alg $$file`; \
				if [ "$$cksum" = "$$mksum" ]; then \
					echo "=> $$alg checksum OK for $$file"; \
				else \
					echo "=> $$alg checksum mismatch for $$file"; \
					exit 1; \
				fi; \
			done; \
		done; \
	fi

# XXX: This needs fixing since implementing categories!
depends:
.ifdef BUILD_DEPENDS
.for dep in ${BUILD_DEPENDS}
	@cat=${dep:S/:/ /:[1]}; \
	port=${dep:S/:/ /:[2]}; \
	pkginfo=`pkginfo -q ${PKGPREFIX}$$port`; \
	if [ $$? -eq 0 ]; then \
		echo "==> ${PKGNAME} depends on package: $$port (already installed)"; \
	else \
		if [ -d ${PORTSDIR}/$$cat/$$port ]; then \
			echo "==> ${PKGNAME} depends on package: $$port"; \
			cd ${PORTSDIR}/$$cat/$$port; \
			${MAKE} clean build && ${MAKE} installpkg; \
			if [ $$? -eq 0 ]; then \
				echo "==> Returning to build of ${PKGNAME}"; \
			else \
				exit $?; \
			fi; \
		else \
			echo "==> ${PKGNAME} depends on package: $$port - not found"; \
			exit 1; \
		fi; \
	fi
.endfor
.endif

fetch:
	@if [ ! -d ${DISTDIR} ]; then mkdir ${DISTDIR}; fi
	@if [ -n "${DISTFILES}" ]; then \
	cd ${DISTDIR}; \
	for file in "${DISTFILES}"; do \
		if [ -f ${DISTDIR}/$$file ]; then \
			${DO_NADA}; \
		else \
			echo "==> Fetching for ${PKGNAME}"; \
			${FETCH_CMD} -c ${DIST_SITE}$$file; \
			if [ ! -d ${WRKDIR} ]; then mkdir ${WRKDIR}; fi; \
		fi; \
	done; \
	fi

extract: checksum
	@if [ -f ${WRKDIR}/.extract_done ]; then \
		${DO_NADA}; \
	else \
		if [ ! -d ${WRKDIR} ]; then mkdir ${WRKDIR}; fi; \
		if [ -n "${DISTFILES}" ]; then \
			echo "==> Extracting for ${PKGNAME}"; \
			for file in "${DISTFILES}"; do \
				if [ ! -f ${DISTDIR}/$$file ]; then \
					echo "==> Error: Could not find distfile"; \
					exit 1; \
				fi; \
				cd ${WRKDIR} && ${EXTRACT_CMD} ${EXTRACT_BEFORE_ARGS} ${DISTDIR}/$$file ${EXTRACT_AFTER_ARGS}; \
				if [ $$? -ne 0 ]; \
				then \
					exit 1; \
				fi; \
			done; \
			touch ${WRKDIR}/.extract_done; \
		fi; \
	fi

# XXX: patch yet to be implemented!
patch: extract
	@${DO_NADA}

configure: depends patch
.ifdef HAS_CONFIGURE
	@if [ -f ${WRKDIR}/.configure_done ]; then \
		${DO_NADA}; \
	else \
		echo "==> Configuring for ${PKGNAME}"; \
		cd ${WRKSRC} && ${ENV} ${CONFIGURE_ENV} ./${CONFIGURE_SCRIPT} ${CONFIGURE_ARGS}; \
		if [ $$? -gt 0 ]; then \
			echo "===> Configure failed."; \
			exit 1; \
		fi; \
		touch ${WRKDIR}/.configure_done; \
	fi
.endif
.ifdef PERL_CONFIGURE
	@if [ -f ${WRKDIR}/.configure_done ]; then \
		${DO_NADA}; \
	else \
		echo "==> Configuring for ${PKGNAME}"; \
		cd ${WRKSRC} && ${ENV} ${CONFIGURE_ENV} perl Makefile.PL; \
		if [ $$? -gt 0 ]; then \
			echo "===> Configure failed."; \
			exit 1; \
		fi; \
		touch ${WRKDIR}/.configure_done; \
	fi
.endif

build: configure
.ifndef NO_BUILD
	@if [ -f ${WRKDIR}/.build_done ]; then \
		${DO_NADA}; \
	else \
		echo "==> Building for ${PKGNAME}"; \
		cd ${WRKSRC} && ${MAKE} ${MAKE_ARGS} ${ALL_TARGET}; \
		if [ $$? -gt 0 ]; then \
			echo "===> Build failed."; \
			exit 1; \
		fi; \
		touch ${WRKDIR}/.build_done; \
	fi
.endif

fakeinstall: build
.ifndef NO_BUILD
	@if [ -f ${WRKDIR}/.fakeinstall_done ]; then \
		${DO_NADA}; \
	else \
		echo "==> Running fake install for ${PKGNAME}"; \
		if [ ! -d ${WRKINST} ]; then mkdir ${WRKINST}; fi; \
		cd ${WRKSRC} && ${ENV} ${MAKE_ENV} ${_FAKE_SETUP} ${MAKE} ${ALL_FAKE_FLAGS} ${INSTALL_TARGET} && \
		touch ${WRKDIR}/.fakeinstall_done; \
	fi
.endif

# Target to make a local IPS repository
ipsrepo:
	@if [ -d ${PKGSTORE} -a "$(ls -A ${PKGSTORE})" ]; then \
		echo "==> Error: ${PKGSTORE} not empty"; \
	else \
		if [ ! -d ${PKGSTORE} ]; then mkdir ${PKGSTORE}; fi; \
		hostname=`hostname`; \
		pkgrepo create ${PKGSTORE} && \
		pkgrepo -s ${PKGSTORE} set-property publisher/prefix=$$hostname && \
		echo "==> IPS repository created at file://${PKGSTORE}/" || \
		echo "==> Unable to create IPS repository"; \
	fi

install: fakeinstall
pkg: install ${PKGFILE}
pkginfo: ${PKGINFO}
prototype: ${PROTOTYPE}

# For IPS
metadata: ${METADATA}

CATEGORY:=${CATEGORY:S/ /,/}

${PKGINFO}:
	@if [ -f $@ ]; then rm $@; fi
	@echo "PKG=${PKGPREFIX}${NAME}${PKGNAMESUFFIX}" >> $@
	@echo "NAME=${DESC}" >> $@
	@echo "VERSION=${VERSION}" >> $@
	@echo "CATEGORY=application,${CATEGORY}" >> $@
	@echo "ARCH=${ARCH}" >> $@
.ifdef PKGLONGDESC
	@echo "DESC=${LONGDESC}" >> $@
.endif
.ifdef VENDOR
	@echo "VENDOR=${VENDOR}" >> $@
.endif
.ifdef EMAIL
	@echo "EMAIL=${EMAIL}" >> $@
.endif
	@echo "CLASSES=${CLASSES}" >> $@
.ifdef ISTATES
	@echo "ISTATES=${ISTATES}" >> $@
.endif
.ifdef RSTATES
	@echo "RSTATES=${RSTATES}" >> $@
.endif
.ifdef BASEDIR
	@echo "BASEDIR=${BASEDIR}" >> $@
.endif

${METADATA}:
	@if [ -f $@ ]; then rm $@; fi
	@echo "set name=pkg.name value='${NAME}${PKGNAMESUFFIX}'" >> $@
	@echo "set name=pkg.description value='${DESC}'" >> $@
	@echo "set name=description value='${DESC}'" >> $@
	@echo "set name=packager value='${MAINTAINER}'" >> $@

${DEPENDFILE}:
	@if [ -f $@ ]; then rm $@; fi
.ifdef RUN_DEPENDS
.for dep in ${RUN_DEPENDS}
	@cat=${dep:C/(.*):/\1/}; \
	 pkg=${dep:C/:(.*)/\1}; \
	 desc=`${MAKE} -s -C ${PORTSDIR}/$$cat/$$pkg -VDESC`; \
	 echo "P ${PKGPREFIX}$$pkg $$desc" >> $@
.endfor
.endif
.ifdef CONFLICTS
.for conflict in ${CONFLICTS}
	@cat=${conflict:C/(.*):/\1/}; \
	 pkg=${conflict:C/:(.*)/\1}; \
	 desc=`${MAKE} -s -C ${PORTSDIR}/$$cat/$$pkg -VDESC`; \
	 echo "I ${PKGPREFIX}$$pkg $$desc" >> $@
.endif	

${PROTOTYPE}:
	@if [ -f $@ ]; then rm $@; fi
#	@echo "!search ${WRKDIR:${PKGDIR}/%=%)" >> $@
	@echo "!search %%WRKDIR%%" >> $@
	@echo "i pkginfo" >> $@
.ifdef RUN_DEPENDS
	@echo "i depend" >> $@
.endif
.ifdef SMF_MANIFEST
.endif
	@echo "!search %%PKGDIR%%" >> $@
.ifdef INSTALL_SCRIPTS
.for script in ${INSTALL_SCRIPTS}
	@echo i ${script} >> $@
.endfor
.endif
.ifdef REMOVE_SCRIPTS
.for script in ${REMOVE_SCRIPTS}
	@echo i ${script} >> $@
.endfor
.endif
.ifndef NO_BUILD
#
# Find items outside of PREFIX first
#
#	@echo "!search $(WRKINST:$(PKGDIR)/%=%)" >> $@
	@echo "!search %%WRKINST%%" >> $@
	@cd ${WRKINST}; ${FIND_CMD} * ${FIND_AFTER_ARGS} ${FIND_NON_PREFIX} | \
		pkgproto ${PKGPROTO_AFTER_ARGS} >> $@
#
# Then find items within PREFIX
#
#	@echo "!search ${WRKINST:${PKGDIR}/%=%}${PREFIX}" >> $@
	@echo "!search %%WRKINST%%%%PREFIX%%" >> $@
	@cd ${WRKINST}${PREFIX}; ${FIND_CMD} * ${FIND_AFTER_ARGS} | \
		pkgproto >> $@
.endif
.ifdef EXTRA_FILES
#	@echo "!search ${FILESDIR:${PKGDIR}/%=%}" >> $@
	@echo "!search %%FILESDIR%%" >> $@
.for file in ${EXTRA_FILES}
	@echo "${file:S/=/ /}" | \
	 ${AWK} '{ print "f none",$$2 "=" $$1,"0644 root bin" }' >> $@
.endfor
.endif
.ifdef SMF_MANIFEST
	@svccfg validate ${PKGDIR}/smf/${SMF_MANIFEST}; \
	if [ $$? -gt 0 ]; then \
		echo "===> Error: SMF manifest did not validate."; \
		exit 1; \
	fi
	@echo "!search %%SMFDIR%%" >> $@
	@echo "i i.smf" >> $@
.ifdef SMF_METHOD
	@echo "d smf /lib ? ? ?" >> $@
	@echo "d smf /lib/svc ? ? ?" >> $@
	@echo "d smf /lib/svc/method ? ? ?" >> $@
	@echo "f smf /lib/svc/method/${SMF_METHOD:S/.sh$//}=${SMF_METHOD} 0555 root bin" >> $@
.endif
	@echo "d smf /var ? ? ?" >> $@
	@echo "d smf /var/svc ? ? ?" >> $@
	@echo "d smf /var/svc/manifest ? ? ?" >> $@
	@echo "d smf /var/svc/manifest/site ? ? ?" >> $@
	@echo "f smf /var/svc/manifest/site/${SMF_MANIFEST}=${SMF_MANIFEST} 0444 root sys" >> $@
.endif
	@echo "==> Prototype has been generated. Please check and adjust as necessary."

${TMPPROTOTYPE}:
	if [ -f ${PROTOTYPE} ]; then \
		sed ${PROTO_SUB:S/$/!g/:S/^/ -e s!%%/:S/=%%!/} ${PROTOTYPE} > $@; \
	fi

${PKGFILE}: ${PKGINFO} ${DEPENDFILE} ${TMPPROTOTYPE}
	@if [ ! -d ${SPOOLDIR} ]; then mkdir ${SPOOLDIR}; fi
	@echo "==> Generating package"
	@cd ${PKGDIR} && \
		pkgmk -o -f ${TMPPROTOTYPE} -d ${SPOOLDIR} -b ${WRKINST}${PREFIX} -r ${PKGDIR} -a ${ARCH}
	@if [ ! -d ${PKGSTORE} ]; then mkdir ${PKGSTORE}; fi
	@pkgtrans -s ${SPOOLDIR} ${PKGSTORE}/${PKGFILE} ${PKGPREFIX}${NAME}${PKGNAMESUFFIX}
	@echo "==> Package has been created in ${PKGSTORE}."

# This target will only build the package if it doesn't yet exist.
# The pkg target will always rebuild.
check-pkg:
	@if [ ! -f ${PKGSTORE}/${PKGFILE} ]; then ${MAKE} pkg; fi

installpkg: check-pkg
	@pkginfo -q ${PKGPREFIX}${NAME}; \
	if [ $$? -eq 0 ]; then \
		echo "===> ${PKGNAME} is already installed."; \
	else \
		if [ -f ${PKGSTORE}/${PKGFILE} ]; then \
			pfexec pkgadd ${PKGADD_ARGS} -d ${PKGSTORE}/${PKGFILE} ${PKGPREFIX}${NAME}${PKGNAMESUFFIX}; \
			if [ $$? -gt 0 ]; then \
				echo "===> Install of ${PKGNAME} FAILED."; \
				exit 1; \
			else \
				echo "==> ${PKGNAME} installed successfully."; \
			fi; \
		else \
			echo "===> Error: ${PKGFILE} not found"; \
		fi; \
	fi

reconfigure:
	@if [ -f ${WRKDIR}/.configure_done ]; then rm ${WRKDIR}/.configure_done; fi
	@${MAKE} configure

rebuild:
	@if [ -f ${WRKDIR}/.build_done ]; then rm ${WRKDIR}/.build_done; fi
	@${MAKE} build

clean:
	@echo "==> Cleaning for ${PKGNAME}"
	@if [ -f ${PKGINFO} ]; then rm ${PKGINFO}; fi
	@if [ -d ${SPOOLDIR} ]; then rm -rf ${SPOOLDIR}; fi
	@if [ -d ${WRKDIR} ]; then rm -rf ${WRKDIR}; fi

.PHONY: ${PKGINFO} ${PROTOTYPE} ${DEPENDFILE} ${PKGFILE} ${TMPPROTOTYPE} ${METADATA}

# include any file listed in MAKE_CONF, if it exists, to allow site-wide overrides
.-include "${MAKE_CONF}"
