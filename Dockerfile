FROM centos:7

LABEL maintainer="Claudio Bantalouaks <cbantaloukas@ccdc.cam.ac.uk>"
# Based on conan-io/gcc_7-centos6 by
# LABEL maintainer="Luis Martinez de Bartolome <luism@jfrog.com>"

ENV PATH=/opt/rh/rh-python38/root/usr/local/bin:/opt/rh/rh-python38/root/usr/bin:/opt/rh/devtoolset-9/root/usr/bin:/opt/rh/rh-perl526/root/usr/local/bin:/opt/rh/rh-perl526/root/usr/bin:/opt/rh/sclo-git25/root/usr/bin:${PATH:+:${PATH}} \
    MANPATH=/opt/rh/rh-python38/root/usr/share/man:/opt/rh/devtoolset-9/root/usr/share/man:/opt/rh/rh-perl526/root/usr/share/man:/opt/rh/sclo-git25/root/usr/share/man:${MANPATH:+:${MANPATH}} \
    INFOPATH=/opt/rh/devtoolset-9/root/usr/share/info${INFOPATH:+:${INFOPATH}} \
    PCP_DIR=/opt/rh/devtoolset-9/root \
    PERL5LIB=/opt/rh/devtoolset-9/root/usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-9/root/usr/lib/perl5:/opt/rh/devtoolset-9/root//usr/share/perl5/vendor_perl:/opt/rh/sclo-git25/root/usr/share/perl5/vendor_perl${PERL5LIB:+:${PERL5LIB}} \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-9/root/usr/lib64:/opt/rh/devtoolset-9/root/usr/lib:/opt/rh/devtoolset-9/root/usr/lib64/dyninst:/opt/rh/devtoolset-9/root/usr/lib/dyninst:/opt/rh/rh-python38/root/usr/lib64:/opt/rh/rh-perl526/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    PKG_CONFIG_PATH=/opt/rh/rh-python38/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}} \
    XDG_DATA_DIRS="/opt/rh/rh-python38/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" \
    CXX=/opt/rh/devtoolset-9/root/usr/bin/g++ \
    CC=/opt/rh/devtoolset-9/root/usr/bin/gcc

RUN yum upgrade -y \
    && yum install -y centos-release-scl \
    && yum install -y \
       sudo \
       wget \
       make \
       glibc-devel \
       glibc-devel.i686 \
       libgcc.i686 \
       gmp-devel \
       mpfr-devel \
       libmpc-devel \
       nasm \
       m4 \
       libffi-devel \
       openssl-devel \
       openssl-static \
       pkgconfig \
       subversion \
       zlib-devel \
       xz \
       curl \
       xz-devel \
       tar \
       devtoolset-9-toolchain \
       rh-python38 \
       rh-perl526 \
       sclo-git25 \
       help2man \
       autoconf-archive \
    && yum clean all \
    && wget -O /tmp/autoconf-2.69.tar.gz --no-check-certificate --quiet https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz \
    && tar -zxf /tmp/autoconf-2.69.tar.gz -C /tmp \
    && pushd /tmp/autoconf-2.69 \
    && ./configure --prefix=/usr \
    && make -s \
    && make install \
    && popd \
    && rm -rf /tmp/autoconf-2.69* \
    && wget -O /tmp/automake-1.16.tar.gz --no-check-certificate --quiet https://ftp.gnu.org/gnu/automake/automake-1.16.tar.gz \
    && tar -zxf /tmp/automake-1.16.tar.gz -C /tmp \
    && pushd /tmp/automake-1.16 \
    && ./configure --prefix=/usr \
    && sed -i "s/'none';/'reduce';/g" bin/automake.in \
    && make -s \
    && make install \
    && popd \
    && rm -rf /tmp/automake-1.16* \
    && wget -O /tmp/cmake-3.22.1-Linux-x86_64.sh --no-check-certificate --quiet 'https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.sh' \
    && bash /tmp/cmake-3.22.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir \
    && rm /tmp/cmake-3.22.1-Linux-x86_64.sh \
    && pip install -q --upgrade --no-cache-dir pip \
    && pip install -q --no-cache-dir 'conan>=1.34.1,<2.0' conan_package_tools
