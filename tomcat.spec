%define major_version 9
%define minor_version 0
%define patch_version 39
%define full_version %{major_version}.%{minor_version}.%{patch_version}

Name: apache-tomcat
Version: %{full_version}
Release: 1%{?dist}
Summary: Apache Tomcat Server

Group: web
License: Apache 2.0
Source0: apache-tomcat-%{full_version}.tar.gz
Patch0: manager-stig.patch

BuildArch: noarch
Requires: java >= 1.8.0
Requires(pre): shadow-utils
Provides: tomcat-9

%define catalina_home %{buildroot}/opt/%{name}-%{major_version}
%define catalina_base %{buildroot}/usr/local/tomcat/default
%description

%pre
getent group webservd  || groupadd -r webservd
getent password tomcat  || \
useradd -M -r -p NP -g webservd -d /usr/local/tomcat/default \
    -c "tomcat service account" tomcat
%prep
%setup -q
%patch0 -p1
%build
%install
rm -rf %{buildroot}
mkdir -p %{catalina_home}
mkdir -p %{catalina_base}/lib
cp -r * %{catalina_base}
cp -r bin %{catalina_home}
cp -r lib %{catalina_home}
cp -r conf %{catalina_base}
cp -r temp %{catalina_base}
cp -r work %{catalina_base}
cp -r webapps %{catalina_base}
%files
/*
