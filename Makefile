build:
	mkdir -p bin
	gcc -fPIC -c provider.c -o bin/provider.o
	gcc -shared -o bin/provider.so bin/provider.o -lpam
	gcc -o bin/testconsumer consumer.c -lpam -lpam_misc
	rm bin/provider.o
	cp list /tmp/list

link: build
	sudo ln -s $(shell pwd)/bin/provider.so /usr/lib/x86_64-linux-gnu/security/pam_testprovider.so

pamrule:
	- sudo rm /etc/pam.d/test_app
	echo "auth required pam_testprovider.so" | sudo tee /etc/pam.d/test_app

test:
	./bin/testconsumer jan

clean:
	- sudo rm /usr/lib/x86_64-linux-gnu/security/pam_testprovider.so
	- sudo rm /etc/pam.d/test_app
	- rm -r bin
	- rm /tmp/list