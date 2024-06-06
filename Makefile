VERSION = 9.0.89
SHA512 = "aaa2851bdc7a2476b6793e95174965c1c861531f161d8a138e87f8532b1af4d4b3d92dd1ae890614a692e5f13fb2e6946a1ada888f21e9d7db1964616b4181f0 *apache-tomcat-9.0.89.tar.gz"

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
