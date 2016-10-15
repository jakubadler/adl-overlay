# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_P="${PN}${PV}"
DESCRIPTION="An efficient compressed bitmap index technology"
HOMEPAGE="https://sdm.lbl.gov/fastbit"
SRC_URI="https://codeforge.lbl.gov/frs/download.php/409/${MY_PN}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}/${MY_P}" "${WORKDIR}/${P}"
}

src_configure() {
	econf --includedir=${EPREFIX}/usr/include/fastbit
}

