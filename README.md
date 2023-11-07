# Tomcat RPM and Solaris IPS package

This projects creates an RPM and Solaris IPS package of Apache Tomcat that defaults to having all of the practical STIG requirement config changes from https://cyber.mil in place.

# Usage


## Both

The ONLY Tomcat setting that the admin should change in the service definition is $CATALINA_BASE. ALL other settings should be 
set in CATALINA_BASE/bin/setenv.sh.

## RPM

The service uses a systemd unit file. It should be enabled in the usual way

```bash
# systemctl enable tomcat9
# systemctl disable tomcat9
```

If you need to override CATALINA_BASE use systemctl edit.

```
# systemctl edit tomcat9

[Service]
Environment="CATALINA_BASE=<your new base directory>"

```


## Solaris PKG

NOTE: at this time the preserve action on configuration files isn't working, it is recommend NOT to use the default CATALINA_BASE directory but to instead make a copy of the directory structure, you can then use this to compare when new STIG information comes out.

you use the use svcadm commands to start and stop the service

```bash
# svcadm disable tomcat9
# svcadm enable tomcat9
```

To change $CATALINA_BASE in the primary instance

```bash
svccfg -s svc:/network/tomcat9 setenv CATALINA_BASE "<your base directory>"
```


To create another instance of the tomcat service

```bash
# svccfg -s svc:/network/tomcat9 add instance2
## then to change the $CATALINA_BASE directory
# svccfg -s svc:/network/tomcat9:instance2 setenv CATALINA_BASE "<this instances catalina_base>"
```


# Updating the tomcat version

## Makefile

Update the version number and sha512 key (from the tomcat.apache.orgs download page)

## Spec
Update the appropriate digits at the top of the file

## Dealing with rejected patches

Every-so-often Tomcat makes changes to the baseline server.xml file that branches the patches. Most of the patch itself will still be applied.
To fix this situation either unzip the apache-tomcat-version.tar.gz file and manually apply the patch with diff in a way that creates server.xml.rej file.

Manually apply the rejected changes to the server.xml.

Run:

`diff -u apache-tomcat-<version>/conf/server.xml.org apache-tomcat-<version>/conf/server.xml.org > ${DIRECTORY_TO/}serverxml-stig.patch`

and as appropriate for web.xml and the manager-stig.patch.
