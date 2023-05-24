# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="BaCon Basic to C converter for *nix"
HOMEPAGE="http://www.basic-converter.org"
SRC_URI="http://www.basic-converter.org/stable/$P.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} dev-util/indent x11-terms/xterm"
BDEPEND=""

MAKEOPTS="-j1"

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
