FROM redhat/ubi8:latest

# Clean up and update yum, then install required packages
RUN yum clean all && yum -y update -v && yum -y upgrade -v && \
    yum -y install wget rpm-build rpmlint make coreutils diffutils patch python3 -v

# Create the rpm build directories
RUN mkdir -p /root/rpmbuild/RPMS/noarch && \
    mkdir -p /root/rpmbuild/SOURCES && \
    mkdir -p /root/rpmbuild/SPECS && \
    mkdir -p /root/rpmbuild/SRPMS

# Copy source files and spec file
COPY *.tar.gz /root/rpmbuild/SOURCES/
COPY *.patch /root/rpmbuild/SOURCES/
ADD tomcat.spec /root/rpmbuild/SPECS/

# Set working directory
WORKDIR /root/rpmbuild/RPMS/noarch

# Command to build RPM
CMD ["rpmbuild", "--target", "noarch", "-v", "-bb", "tomcat.spec"]
