# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 autotools
EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/CESNET/ipfixcol.git"}
KEYWORDS="~amd64 ~x86"
SRC_URI=""
EGIT_BRANCH="master"
EGIT_COMMIT="3019ef9b8fa35070bb00419894fd6cae41aebb03"
DESCRIPTION="A flexible IPFIX flow data collector"
HOMEPAGE="https://www.liberouter.org/ipfixcol/"

LICENSE="GPL-2"
SLOT="0"
IUSE="openssl -sctp -unirec -fastbit -postgres"

DEPEND="sctp? ( dev-libs/sctp )
	app-doc/doxygen
	fastbit? ( dev-db/fastbit-ibis )
	openssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/dlopen.patch"
	if ! use unirec ; then
		sed -i -e "s/plugins\/storage\/unirec//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable unirec"
		sed -i -e "/plugins\/storage\/unirec/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable unirec"
	fi
	if ! use fastbit; then
		sed -i -e "s/plugins\/storage\/fastbit//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable fastbit"
		sed -i -e "s/tools\/fbitdump//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable fastbit"
		sed -i -e "s/tools\/fbitconvert//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable fastbit"
		sed -i -e "s/tools\/fbitmerge//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable fastbit"
		sed -i -e "s/tools\/fbitexpire//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable fastbit"

		sed -i -e "/plugins\/storage\/fastbit/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable fastbit"
		sed -i -e "/tools\/fbitdump/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable fastbit"
		sed -i -e "/tools\/fbitconvert/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable fastbit"
		sed -i -e "/tools\/fbitmerge/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable fastbit"
		sed -i -e "/tools\/fbitexpire/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable fastbit"
	fi
	if ! use postgres; then
		sed -i -e "s/plugins\/storage\/postgres//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable postgres"
		sed -i -e "/plugins\/storage\/postgres/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable postgres"
	fi
	sed -i -e "$,$ s/ \\\//g" "${WORKDIR}/${P}/Makefile.am"
	autoreconf -i
}
src_configure() {

	econf \
		$(use_enable sctp sctp) \
		$(use_with unirec unirec) \
		$(use_with openssl openssl)

}
