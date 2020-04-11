FLAC_VERSION=1.3.3
MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: all clean cleancache build install

all: build

# xcode calls install
install: all

flac-${FLAC_VERSION}.tar.xz:
	wget https://ftp.osuosl.org/pub/xiph/releases/flac/flac-${FLAC_VERSION}.tar.xz
	touch -m -t 200001010000 flac-1.3.3.tar.xz

flac/configure: flac-${FLAC_VERSION}.tar.xz
	mkdir -p flac
	tar xfj flac-${FLAC_VERSION}.tar.xz -C ${MAKEFILE_DIR}/flac --strip-components=1
	find flac -name "stream_encoder.c" -delete
	cat flac/src/libFLAC/Makefile.am | grep -v stream_encoder > /tmp/Makefile.am
	cp /tmp/Makefile.am flac/src/libFLAC/Makefile.am
	cd flac && ./autogen.sh

flac/Makefile: flac/configure
	cd flac && \
		./configure --prefix=${MAKEFILE_DIR}/output \
			--enable-static=yes \
			--enable-shared=no \
			--disable-cpplibs \
			--disable-ogg \
			--disable-xmms-plugin

output/lib/libFLAC.a: flac/Makefile
	cd flac/src/libFLAC && make install

output/include/FLAC/metadata.h: flac/Makefile
	cd flac/include/FLAC && make install

build: output/lib/libFLAC.a output/include/FLAC/metadata.h

clean:
	rm -rf output flac
	rm -rf *.flac

cleancache: clean
	rm -f flac-${FLAC_VERSION}.tar.xz

