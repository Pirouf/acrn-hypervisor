FROM debian:stable-slim

# to get the recent acpica-tools, add unstable repo
RUN echo "deb http://deb.debian.org/debian unstable main" >/etc/apt/sources.list.d/unstable.list

RUN (\
  echo "Package: *"; \
  echo "Pin: release a=stable"; \
  echo "Pin-Priority: 700"; \
  echo ""; \
  echo "Package: *"; \
  echo "Pin: release a=unstable"; \
  echo "Pin-Priority: 600") >> /etc/apt/preferences

RUN apt-get clean all
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
	build-essential \
	git \
	git-buildpackage \
	devscripts \
	debhelper \
	wget \
	python3 \
	dh-python \
	python3-setuptools \
	python3-all \
	python3-pip \
	python3-wheel

# ACRN build needs kconfiglib, not available as Debian package
RUN pip3 install kconfiglib


# install additional build dependencies for ACRN
RUN apt-get install -y --no-install-recommends \
	debhelper \
	gnu-efi \
	libssl-dev \
	libpciaccess-dev \
	uuid-dev \
	libsystemd-dev \
	libevent-dev \
	libxml2-dev \
	libusb-1.0-0-dev \
	libblkid-dev \
	e2fslibs-dev \
	pkg-config \
	libnuma-dev \
	python3-sphinx \
	python3-breathe \
	python3-sphinx-rtd-theme \
	rsync \
	doxygen \
	graphviz

# documentation build needs sphinx-tabs not available as Debian package
RUN pip3 install sphinx-tabs

RUN apt-get install --no-install-recommends -y -t unstable acpica-tools

# mount your ACRN repository source at /acrn-hypervisor
VOLUME /acrn-hypervisor/
WORKDIR /acrn-hypervisor/

RUN useradd docker-build
USER docker-build

# build ACRN packages as user docker-build
ENTRYPOINT gbp buildpackage -us -uc

