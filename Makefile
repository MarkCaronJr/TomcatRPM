

rpm:
	docker build --tag rpmbuild .
	docker run -v `pwd`:/root/rpmbuild/RPMS/noarch rpmbuild rpmbuild -bb tomcat.spec