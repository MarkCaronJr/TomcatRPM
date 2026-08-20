VERSION = 9.0.121
SHA512 = "16494dd4745f808d3c506807b5275521fd71044d976f441d18eeeab0f5a38bc1b5344ca395292f6f26eb7612cd8c8e746d01ccdfb29893d394052d9f4b1f4c11 *apache-tomcat-9.0.121.tar.gz"

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
