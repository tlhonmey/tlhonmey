# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake
inherit git-r3
inherit flag-o-matic


DESCRIPTION="Intel's Openvino tool suite and benchmark app.  (Note:  I don't care about anything but the benchmark app.)"
HOMEPAGE="https://github.com/openvinotoolkit/openvino"
#SRC_URI="https://github.com/openvinotoolkit/openvino"
EGIT_REPO_URI="https://github.com/openvinotoolkit/openvino"
EGIT_COMMIT="2022.1.0.dev20220218"
RESTRICT=network-sandbox
EGIT_CLONE_TYPE=single


LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND="media-libs/opencv
		sci-libs/tensorflow"
RDEPEND="${DEPEND}"
BDEPEND="dev-vcs/git
		|| ( dev-libs/intel-neo dev-libs/intel-compute-runtime )
		|| ( dev-util/shellcheck dev-util/shellcheck-bin )
		dev-python/cython
		dev-python/pip
		dev-vcs/git-lfs
		kde-frameworks/extra-cmake-modules
		dev-python/virtualenv
		dev-python/clang-python
		"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DENABLE_OPENCV=OFF"
		"-DTREAT_WARNING_AS_ERROR=OFF"
		"-DENABLE_FASTER_BUILD=ON"
		"-DENABLE_PYTHON=OFF"
		"-DENABLE_TESTS=OFF"
		"-DCMAKE_BUILD_TYPE=Release"
		"-DENABLE_OV_ONNX_FRONTEND=ON"
		"-DENABLE_OV_PADDLE_FRONTEND=OFF"
		"-DENABLE_OV_IR_FRONTEND=ON"
		"-DENABLE_OV_TF_FRONTEND=ON"
		"-DENABLE_BEH_TESTS=OFF"
		"-DENABLE_FUNCTIONAL_TESTS=OFF"
		"-DENABLE_ERROR_HIGHLIGHT=ON"
		"-DENABLE_NCC_STYLE=OFF"
	)
	cmake_src_configure
}

src_compile() {
	#append-flags "-Wno-array-bounds"
	filter-flags "-Werror"
	cmake_src_compile
}

src_install() {
	#cmake_src_install
	dodir /opt/openvino
	cp -v -R "${S}/bin" "${D}/opt/openvino/" || die "Install failed!"
	dodir /bin
	echo '#! /bin/bash
	export LD_LIBRARY_PATH="/opt/openvino/bin/intel64/RelWithDebInfo/lib/"
	/opt/openvino/bin/intel64/RelWithDebInfo/benchmark_app $@
	' > "${D}/bin/benchmark_app"
	chmod 555 "${D}/bin/benchmark_app"

	echo "$FILESDIR"
	cp -v "${FILESDIR}/get_framediff_images.py" "${D}/bin/"

	dodir /usr/share/doc/openvino
	echo "get_framediff_images.py requires Python's OpenCV-Python for which there is no ebuild yet" > "${D}/usr/share/doc/openvino/TODO.TXT"
}
