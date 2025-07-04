# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9,10,11,12,13} )
PYTHON_REQ_USE="xml"
inherit python-single-r1

DESCRIPTION="TreeLine is a structured information storage program"
HOMEPAGE="http://treeline.bellz.org/"
#SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${P}.tar.gz"
SRC_URI="https://github.com/doug-101/TreeLine/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep 'dev-python/pyqt5[${PYTHON_USEDEP}]' python3_{8,9,10,11,12,13} )
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/TreeLine"

src_prepare() {
	default

	rm doc/LICENSE || die

	python_export PYTHON_SITEDIR
	sed -i "s;prefixDir, 'lib;'${PYTHON_SITEDIR};" install.py || die
}

src_install() {
	"${EPYTHON}" install.py -x -p /usr/ -d /usr/share/doc/${PF} -b "${D}" || die
}
