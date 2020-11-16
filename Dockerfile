FROM centos:7

RUN yum -y update && yum -y upgrade && \
    yum -y install wget rpm-build ant ecj apache-commons-daemon tomcat-taglibs-standard java-devel geronimo-jaxrpc geronimo-saaj aqute-bnd aqute-bndlib wsdl4j rpm-devel rpmlint make coreutils diffutils patch rpmdevtools make python

RUN mkdir -p /root/rpmbuild/RPMS/noarch && \
    mkdir -p /root/rpmbuild/SOURCES && \
    mkdir -p /root/rpmbuild/SPECS && \
    mkdir -p /root/rpmbuild/SRPMS


COPY *.tar.gz /root/rpmbuild/SOURCES/
COPY *.patch /root/rpmbuild/SOURCES/
ADD tomcat.spec /root/rpmbuild/SPECS/
VOLUME /root/rpmbuild/RPMS/noarch
WORKDIR /root/rpmbuild/RPMS/noarch
CMD ["rpmbuild","--target","noarch","-v","-bb","tomcat.spec"]
