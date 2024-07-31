FROM redhat/ubi8:latest

RUN yum -y update && yum -y upgrade && \
    yum -y install wget rpm-build rpmlint make coreutils diffutils patch make python3

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
