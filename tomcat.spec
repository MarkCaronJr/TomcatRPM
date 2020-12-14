%define major_version 9
%define minor_version 0
%define patch_version 41
%define full_version %{major_version}.%{minor_version}.%{patch_version}

Name: apache-tomcat
Version: %{major_version}.%{minor_version}
Release: %{patch_version}%{?dist}
Summary: Apache Tomcat Server

Group: web
License: Apache 2.0
Source0: apache-tomcat-%{full_version}.tar.gz
Patch0: manager-stig.patch
Patch1: serverxml-stig.patch
Patch2: webxml-stig.patch


BuildArch: noarch
Requires: java >= 1.8.0
Requires(pre): shadow-utils
Provides: tomcat-9 = %{version}
Obsoletes: tomcat-9 < %{version}

%define catalina_home /opt/%{name}-%{major_version}
%define catalina_base /usr/local/tomcat/default
%description

%pre
getent group webservd  || groupadd -r webservd
getent passwd tomcat  || \
useradd -M -r -p NP -g webservd -d /usr/local/tomcat/default \
    -c "tomcat service account" tomcat
%prep
%setup -q -c -n apache-tomcat 
mv apache-tomcat-*/* .
%patch0 -p1
%patch1 -p1
%patch2 -p1
%build
%install
find . -name "*.bat" -exec rm {} \;
mkdir -p %{buildroot}/%{catalina_home}
mkdir -p %{buildroot}/%{catalina_base}/lib
mkdir -p %{buildroot}/%{catalina_base}/webapps
cp -r bin %{buildroot}/%{catalina_home}
cp -r bin %{buildroot}/%{catalina_base}
cp -r lib %{buildroot}/%{catalina_home}
cp -r conf %{buildroot}/%{catalina_base}
mkdir -p %{buildroot}/%{catalina_base}/temp
cp -r work %{buildroot}/%{catalina_base}
cp -r webapps/manager %{buildroot}/%{catalina_base}/webapps/manager
cp -r webapps/host-manager %{buildroot}/%{catalina_base}/webapps/host-manager
%files
%defattr(0640,tomcat,webservd,0750)
/%{catalina_home}/*
/%{catalina_base}/*
%attr(0755,root,root) /%{catalina_home}/bin/*
%attr(0755,root,root) /%{catalina_base}/bin/*
%attr(0755,root,root) /%{catalina_home}/lib/*
%config(noreplace) /%{catalina_base}/conf/*
#%attr(0750,tomcat,webservd) /%{catalina_base}/conf
#%attr(-,tomcat,webservd) /%{catalina_base}/conf/*
#%attr(0750,tomcat,webservd) /%{catalina_base}/lib
#%attr(0750,tomcat,webservd) /%{catalina_base}/bin
#%attr(-,tomcat,webservd) /%{catalina_base}/bin/*
#%attr(-750,tomcat,webservd) /%{catalina_base}/temp
#%attr(0750,tomcat,webservd) /%{catalina_base}/work
#%attr(0640,tomcat,webservd,0750) /%{catalina_base}/webapps



