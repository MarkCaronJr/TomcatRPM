Name: apache-tomcat
Version: 9.0.39
Release: 1
Summary: Apache Tomcat Server

Group: web
License: Apache 2.0
Source0: apache-tomcat-9.0.39.tar.gz

BuildArch: noarch
Requires: java >= 1:1.8.0
%description
%prep
%setup -q
%build
%install
mkdir -p %{buildroot}/opt/%{name}-%{version}
cp -r * %{buildroot}/opt/%{name}-%{version}
%files
/*
