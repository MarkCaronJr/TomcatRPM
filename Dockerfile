FROM redhat/ubi8:latest

# Clean up and update yum, then install required packages
RUN yum clean all && yum -y update -v && yum -y upgrade -v && \
    yum -y install wget rpm-build rpm-devel rpmlint make coreutils diffutils patch rpmdevtools make python -v

# Set up the build directories
RUN mkdir -p /root/rpmbuild/{RPMS/noarch,SOURCES,SPECS,SRPMS}

# Copy source and spec files
COPY *.tar.gz /root/rpmbuild/SOURCES/
COPY *.patch /root/rpmbuild/SOURCES/
ADD tomcat.spec /root/rpmbuild/SPECS/

# Define the volume for the built RPMs
VOLUME /root/rpmbuild/RPMS/noarch

# Set the working directory
WORKDIR /root/rpmbuild/RPMS/noarch

# Default command to build the RPM
CMD ["rpmbuild", "--target", "noarch", "-v", "-bb", "/root/rpmbuild/SPECS/tomcat.spec"]
