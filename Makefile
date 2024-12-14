VERSION = 9.0.98
SHA512 = "07d87286e8ee84bb291069c596cf36233e56a14e3ecb6d65eea0fa7c7042ce5e75f5db31f210b96b6b25b80b34e626dd26c5a6ed5c052384a8587d62658b5e16 *apache-tomcat-9.0.98.tar.gz"

.DEFAULT_GOAL := rpm


download:   
	if [ ! -f ./apache-tomcat-${VERSION}.tar.gz ]; then wget https://downloads.apache.org/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz; fi
	echo "${SHA512}" > checksum.txt
	sha512sum -c checksum.txt
	
rpm: download
	docker build --tag rpmbuild .
	docker run -v `pwd`:/root/rpmbuild/RPMS/noarch rpmbuild

solaris: download
	./build_solaris_pkg.sh "apache-tomcat-${VERSION}.tar.gz"



	

clean_solaris:
	rm -rf solaris_pkg

test:
	docker run -it -v `pwd`:/rpms nimmis/java-centos:openjdk-8-jdk
