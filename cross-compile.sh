GCCS="aarch64-linux-gnu-gcc arm-linux-gnueabi-gcc arm-linux-gnueabihf-gcc hppa64-linux-gnu-gcc i686-linux-gnu-gcc powerpc64le-linux-gnu-gcc s390x-linux-gnu-gcc mips-linux-gnu-gcc mipsel-linux-gnu-gcc alpha-linux-gnu-gcc arc-linux-gnu-gcc hppa-linux-gnu-gcc m68k-linux-gnu-gcc powerpc-linux-gnu-gcc powerpc64-linux-gnu-gcc riscv64-linux-gnu-gcc sh4-linux-gnu-gcc sparc64-linux-gnu-gcc"
mkdir package
for GCC in $GCCS; do
    ARCH=$(echo $GCC | sed 's/-.*//')
    echo "Cross-compiling for $ARCH"
    gcc -O3 -fsanitize=undefined -fstack-protector-strong -Wall -fPIC -c provider.c -o bin/provider_$ARCH.o
	gcc -O3 -fsanitize=undefined -fstack-protector-strong -Wall -shared -o bin/provider_$ARCH.so bin/provider_$ARCH.o -lpam

echo """
Package: libpam-daily-word
Version: ${VERSION}
Maintainer: ManInDark
Depends: libpam0g
Architecture: ${ARCH}
Homepage: https://github.com/ManInDark/pam_daily_word
Description: a daily word guessing PAM Module
Section: misc
Priority: optional
""" > control

    sudo install -D -m 644 -o root -g root bin/provider_$ARCH.so tmp/usr/lib/x86_64-linux-gnu/security/pam_daily_word.so
	sudo install -D -m 644 -o root -g root list tmp/etc/daily-word/list
	sudo install -D -m 644 -o root -g root control tmp/DEBIAN/control

    dpkg --build tmp package
    sudo rm -r tmp control

done