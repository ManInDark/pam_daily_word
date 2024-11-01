build:
	mkdir -p bin
	gcc -fPIC -c provider.c -o bin/provider.o
	gcc -shared -o bin/provider.so bin/provider.o -lpam
	rm bin/provider.o
	cp list /tmp/list

install: package
	sudo apt install -y -f ./package/libpam-daily-word_${VERSION}_amd64.deb

remove:
	sudo apt remove -y libpam-daily-word

pamrule: build
	- sudo rm /etc/pam.d/test_app
	echo "auth required pam_daily_word.so tries=3" | sudo tee /etc/pam.d/test_app

test: install pamrule
	pamtester test_app jan authenticate

clean: remove
	- sudo rm /etc/pam.d/test_app
	- rm -r bin package

package: build
	mkdir -p tmp/usr/lib/x86_64-linux-gnu/security
	cp bin/provider.so tmp/usr/lib/x86_64-linux-gnu/security/pam_daily_word.so

	mkdir -p tmp/etc/daily-word
	cp list tmp/etc/daily-word/list

	mkdir -p tmp/DEBIAN
	echo "Package: libpam-daily-word" >> tmp/DEBIAN/control
	echo "Version: ${VERSION}" >> tmp/DEBIAN/control
	echo "Maintainer: ManInDark" >> tmp/DEBIAN/control
	echo "Depends: libpam0g" >> tmp/DEBIAN/control
	echo "Architecture: amd64" >> tmp/DEBIAN/control
	echo "Homepage: https://github.com/ManInDark/pam_daily_word" >> tmp/DEBIAN/control
	echo "Description: a daily word guessing PAM Module" >> tmp/DEBIAN/control

	- mkdir package
	dpkg --build tmp package
	rm -r tmp
