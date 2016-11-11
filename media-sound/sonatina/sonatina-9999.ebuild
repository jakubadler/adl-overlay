# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="A simple MPD client inspired by Sonata"
HOMEPAGE="https://github.com/jakubadler/sonatina"
SRC_URI=""
EGIT_REPO_URI="https://github.com/jakubadler/sonatina.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/gtk+-3.10
		media-libs/libmpdclient"
RDEPEND="${DEPEND}"

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="${D}/usr" install
}
