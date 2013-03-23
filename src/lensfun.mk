# This file is part of MXE.
# See index.html for further information.

PKG             := lensfun
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f26121093dfee85d6371c2c79dae22e6d1b8d0d6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/lensfun.berlios/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libpng glib

define $(PKG)_UPDATE
    echo 'TODO: Updates for package lensfun need to be fixed.' >&2;
    echo $(lensfun_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        TKP='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --sdkdir='$(PREFIX)/$(TARGET)' \
        --compiler=gcc \
        --target=windows.x86 \
        --mode=release \
        --vectorization= \
        --staticlibs=YES
    $(MAKE) -C '$(1)' -j '$(JOBS)' libs
    $(MAKE) -C '$(1)' -j 1 install

    #pkg-config file
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Requires: glib-2.0'; \
     echo 'Libs: -l$(PKG) -lstdc++ -lregex';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-lensfun.exe' \
        `'$(TARGET)-pkg-config' lensfun --cflags --libs`
endef