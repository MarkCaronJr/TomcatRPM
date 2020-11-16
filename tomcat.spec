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
Provides: tomcat-9
%description
%prep
%setup -q
%patch0 -p1
%build
%install
mkdir -p %{buildroot}/opt/%{name}-%{major_version}
cp -r * %{buildroot}/opt/%{name}-%{major_version}
%files
/*
