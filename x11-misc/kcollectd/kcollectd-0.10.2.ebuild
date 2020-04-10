# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Kcollectd KDE gui collectd graphing system."
HOMEPAGE="https://gitlab.com/aerusso/kcollectd"
SRC_URI="https://gitlab.com/aerusso/kcollectd/-/archive/v0.10.2/kcollectd-v0.10.2.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-libs/appstream
		net-analyzer/rrdtool
		dev-util/cmake
		kde-frameworks/extra-cmake-modules
		kde-frameworks/kdoctools
		kde-frameworks/kconfig
		kde-frameworks/kguiaddons
		kde-frameworks/kio
		kde-frameworks/kxmlgui
		kde-frameworks/kiconthemes
		kde-frameworks/kwidgetsaddons
		kde-frameworks/kdelibs4support"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/kcollectd-v0.10.2"

src_configure() {
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
