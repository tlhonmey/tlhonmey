# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="xbarrier -- tool to draw arbitrary barrier lines on an X display which the cursor may not cross."
HOMEPAGE="https://github.com/nwwdles/xbarrier/"
SRC_URI="https://github.com/nwwdles/xbarrier/archive/refs/tags/v1.1.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXfixes"
RDEPEND="${DEPEND}"
BDEPEND=""



