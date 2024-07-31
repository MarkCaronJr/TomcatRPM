FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y wget rpm rpm-build rpmlint make coreutils diffutils patch python3

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
