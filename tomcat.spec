%define major_version 9
%define minor_version 0
%define patch_version 89
%define full_version %{major_version}.%{minor_version}.%{patch_version}

Name: apache-tomcat
Version: %{full_version}
Release: 1%{?dist}
Summary: Apache Tomcat Server

Group: web
License: Apache 2.0
Source0: apache-tomcat-%{full_version}.tar.gz
Patch0: manager-stig.patch
Patch1: serverxml-stig.patch
Patch2: webxml-stig.patch

BuildRequires: systemd
BuildArch: noarch
Requires: java >= 1.8.0
Requires(pre): shadow-utils
Provides: tomcat-9 = %{version}
Obsoletes: tomcat-9 < %{version}
Conflicts: tomcat-9 < %{version}

%define catalina_home /opt/%{name}-%{major_version}
%define catalina_base /usr/local/tomcat/default

%define tomcat_user tomcat
%define tomcat_group tomcat

%description

%clean

%pre
getent group %tomcat_group  || groupadd -r %tomcat_group
getent passwd %tomcat_user  || \
useradd -M -r -p NP -g %tomcat_group -d /usr/local/tomcat/default \
    -c "tomcat service account" %tomcat_user
%prep
%setup -q 
%patch0 -p1
%patch1 -p1
%patch2 -p1
%build
cat > tomcat%{major_version}.service <<EOF
[Unit]
Description=Apache Tomcat %{major_version} service

[Service]
# DO NOT CHANGE THESE

User=%{tomcat_user}
Group=%{tomcat_group}
ExecStart=/opt/apache-tomcat-%{major_version}/bin/catalina.sh run

SuccessExitStatus=143

Environment="CATALINA_HOME=/opt/apache-tomcat-%{major_version}"

# DO NOT CHANGE THIS HERE, use systemctl edit tomcat9 
# (or what ever you've called your service file if running multiple instances )
# If you are running multiple instances make a copy of the tomcat9.service in %{_unit_dir}
Environment="CATALINA_BASE=/usr/local/tomcat/default"

[Install]
WantedBy=multi-user.target
EOF

%install
find . -name "*.bat" -exec rm {} \;
mkdir -p %{buildroot}/%{_unitdir}
mkdir -p %{buildroot}/%{catalina_home}
mkdir -p %{buildroot}/%{catalina_base}/lib
mkdir -p %{buildroot}/%{catalina_base}/webapps
install -m 644 tomcat%{major_version}.service %{buildroot}%{_unitdir}
cp -r bin %{buildroot}/%{catalina_home}
cp -r bin %{buildroot}/%{catalina_base}
cp -r lib %{buildroot}/%{catalina_home}
cp -r conf %{buildroot}/%{catalina_base}
mkdir -p %{buildroot}/%{catalina_base}/temp
mkdir -p %{buildroot}/%{catalina_base}/logs
cp -r work %{buildroot}/%{catalina_base}

%files
%attr(0644,root,root) %{_unitdir}/tomcat9.service
%defattr(0640,tomcat,%tomcat_group,0750)
/%{catalina_home}/*
/%{catalina_base}/*
%attr(0755,root,root) /%{catalina_home}/bin/*
%attr(0755,root,root) /%{catalina_base}/bin/*
%attr(0755,root,root) /%{catalina_home}/lib/*
%config(noreplace) /%{catalina_base}/conf/*

%post
echo $1

#Conditions for installing the manager and host-manager applications
#If a fresh install, manager application will be installed
#If an upgrade, manager application will only be upgraded IF it currently exists within the Tomcat webapps directory. 
#This gives users the ability to remove the manager applications if unneedded and them not be reinstalled during upgrades.  
if [ "$1" == 1 ]; then
    # Fresh install
    cp -r webapps/manager %{catalina_base}/webapps/manager
    cp -r webapps/host-manager %{catalina_base}/webapps/host-manager
elif [ "$1" == 2 ]; then
    # Upgrade
    if [ -d %{catalina_base}/webapps/manager ]; then
        cp -r webapps/manager %{catalina_base}/webapps/manager
    fi
    if [ -d %{catalina_base}/webapps/host-manager ]; then
        cp -r webapps/host-manager %{catalina_base}/webapps/host-manager
    fi
fi
