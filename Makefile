build:
	mkdir -p bin
	gcc -O3 -fsanitize=undefined -fstack-protector-strong -Wall -fPIC -c provider.c -o bin/provider.o
	gcc -O3 -fsanitize=undefined -fstack-protector-strong -Wall -shared -o bin/provider.so bin/provider.o -lpam
	rm bin/provider.o

install: package
	sudo apt install -y -f ./package/libpam-daily-word_${VERSION}_amd64.deb

remove:
	sudo apt remove -y libpam-daily-word

pamrule:
	- sudo rm /etc/pam.d/test_app
	echo "auth required pam_daily_word.so tries=3" | sudo tee /etc/pam.d/test_app

test: install pamrule
	pamtester test_app jan authenticate

clean: remove
	- sudo rm /etc/pam.d/test_app
	- rm -r bin package tmp

package: build
	echo "Package: libpam-daily-word" >> control
	echo "Version: ${VERSION}" >> control
	echo "Maintainer: ManInDark" >> control
	echo "Depends: libpam0g" >> control
	echo "Architecture: ${ARCH}" >> control
	echo "Homepage: https://github.com/ManInDark/pam_daily_word" >> control
	echo "Description: a daily word guessing PAM Module" >> control
	echo "Section: misc" >> control
	echo "Priority: optional" >> control

	sudo install -D -m 644 -o root -g root bin/provider.so tmp/usr/lib/x86_64-linux-gnu/security/pam_daily_word.so
	sudo install -D -m 644 -o root -g root list tmp/etc/daily-word/list
	sudo install -D -m 644 -o root -g root control tmp/DEBIAN/control

	- mkdir package
	dpkg --build tmp package
	- sudo rm -r tmp control

update-repository:
	wget -O /tmp/libpam-daily-word_${VERSION}_amd64.deb https://github.com/ManInDark/pam_daily_word/releases/download/${VERSION}/libpam-daily-word_${VERSION}_amd64.deb
	wget -O /tmp/libpam-daily-word_${VERSION}_arm64.deb https://github.com/ManInDark/pam_daily_word/releases/download/${VERSION}/libpam-daily-word_${VERSION}_arm64.deb
	wget -O /tmp/libpam-daily-word_${VERSION}_armhf.deb https://github.com/ManInDark/pam_daily_word/releases/download/${VERSION}/libpam-daily-word_${VERSION}_armhf.deb
	reprepro -b repository/debian includedeb bookworm /tmp/libpam-daily-word_*