# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 autotools eutils
EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/CESNET/ipfixcol.git"}
KEYWORDS="~amd64 ~x86"
SRC_URI=""
EGIT_BRANCH="master"
#EGIT_COMMIT="6cc4dc6df2f22da9b48c56b285ab64f608e2592c"
DESCRIPTION="A flexible IPFIX flow data collector"
HOMEPAGE="https://www.liberouter.org/ipfixcol/"

LICENSE="GPL-2"
SLOT="0"
IUSE="openssl -sctp -unirec -fastbit -postgres -json -nfdump -stats -geoip -uid"

DEPEND="sctp? ( dev-libs/sctp )
	app-doc/doxygen
	fastbit? ( dev-db/fastbit-ibis )
	openssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_prepare() {
	#epatch "${FILESDIR}/udp.patch"
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
	if ! use json; then
		sed -i -e "s/plugins\/storage\/json//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable json"
		sed -i -e "/plugins\/storage\/json/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable json"
	fi
	if ! use nfdump; then
		sed -i -e "s/plugins\/input\/nfdump//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable nfdump"
		sed -i -e "/plugins\/input\/nfdump/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable nfdump"
	fi
	if ! use stats; then
		sed -i -e "s/plugins\/intermediate\/profile_stats//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable stats"
		sed -i -e "/plugins\/intermediate\/profile_stats/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable stats"
		sed -i -e "s/plugins\/intermediate\/stats//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable stats"
		sed -i -e "/plugins\/intermediate\/stats/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable stats"
	fi
	if ! use geoip; then
		sed -i -e "s/plugins\/intermediate\/geoip//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable geoip"
		sed -i -e "/plugins\/intermediate\/geoip/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable geoip"
	fi
	if ! use uid; then
		sed -i -e "s/plugins\/intermediate\/uid//g" "${WORKDIR}/${P}/configure.ac" || die "couldn't disable uid"
		sed -i -e "/plugins\/intermediate\/uid/d" "${WORKDIR}/${P}/Makefile.am" || die "couldn't disable uid"
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
