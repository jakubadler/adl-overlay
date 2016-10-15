# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-2

DESCRIPTION="A minimalist web browser with sophisticated security features designed-in"
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/conformal/xombrero.git"
EGIT_BRANCH="master"
EGIT_SOURCEDIR="${WORKDIR}/${P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="dev-libs/glib:2
	dev-libs/libbsd
	dev-libs/libgcrypt:0
	net-libs/libsoup
	net-libs/gnutls
	net-libs/webkit-gtk:3
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-apps/groff
	dev-libs/atk
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/pixman"

S="${WORKDIR}/${P}/linux"

src_prepare() {
	cd "${WORKDIR}/${P}" && epatch "${FILESDIR}/fonts-${PV}.patch" || die "epatch failed"
	cd "${WORKDIR}/${P}" && epatch "${FILESDIR}/css-${PV}.patch" || die "epatch failed"
	cd "${WORKDIR}/${P}" && epatch "${FILESDIR}/adblock-${PV}.patch" || die "epatch failed"

	cd "${S}"

	sed -i \
		-e 's/-O2//' \
		-e 's/-ggdb3//' \
		-e 's#/usr/local#/usr#' \
		Makefile || die 'sed Makefile failed.'
	sed -i \
		-e 's#/usr/local#/usr#' \
		GNUmakefile || die 'sed GNUmakefile failed.'
	sed -i \
		-e 's#https://www\.cyphertite\.com#https://www.gentoo.org/#' \
		-e "s#/usr/local#/usr#" \
		../xombrero.h || die 'sed ../xombrero.c failed.'
	sed -i \
		"s#Icon=#Icon=/usr/share/${PN}/#" \
		../xombrero.desktop || die 'sed ../xombrero.desktop failed.'
	sed -i "s:Application;::" ../xombrero.desktop || die
}

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDADD="${LDFLAGS}" emake
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX=/usr \
		install

	if use examples;then
		insinto "/usr/share/doc/${PF}/examples"
		doins \
			../${PN}.conf \
			../playflash.sh \
			../favorites
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

