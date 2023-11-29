VERSION = 9.0.83
SHA512 = "3f022ec8552bce1b72eb85d0778c93052ccb00226de3302544ec844ab93a9991e19c2db56ed06c18f03e5d75f34a46cedac46ae83bdd225518a55c62fc69ea04 *apache-tomcat-9.0.83.tar.gz"

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
