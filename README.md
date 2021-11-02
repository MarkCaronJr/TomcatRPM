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


