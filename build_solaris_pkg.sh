#!/bin/bash

BUILDDIR=`pwd`/solaris_pkg
PKG_ROOT=$BUILDDIR/root
CATALINA_HOME=/opt/apache-tomcat-9
CATALINA_BASE=/usr/local/tomcat/default
TOMCAT_TARBAL=$1
TOMCAT_DIR=`basename $1 .tar.gz`

if [ ! -d $BUILDDIR ]; then mkdir $BUILDDIR; fi

gtar -xvz -C $BUILDDIR -f $TOMCAT_TARBAL
cd solaris_pkg
if [ -d $PKG_ROOT ]; then rm -rf $PKG_ROOT; fi
mkdir $PKG_ROOT
mkdir -p $PKG_ROOT/$CATALINA_BASE
mkdir -p $PKG_ROOT/$CATALINA_HOME
mkdir -p $PKG_ROOT/lib/svc/manifest/site
mkdir -p $PKG_ROOT/lib/svc/method


mv $TOMCAT_DIR/bin $PKG_ROOT/$CATALINA_HOME
mv $TOMCAT_DIR/lib $PKG_ROOT/$CATALINA_HOME

mv $TOMCAT_DIR/conf $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/logs $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/webapps $PKG_ROOT/$CATALINA_BASE
cd $PKG_ROOT/$CATALINA_BASE/webapps
rm -r host-manager
rm -r docs
rm -r examples
rm -r ROOT
cd ../conf
rm -f *.bat

cd $BUILDDIR
mv $TOMCAT_DIR/work $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/temp $PKG_ROOT/$CATALINA_BASE

mv $TOMCAT_DIR/* $PKG_ROOT/$CATALINA_HOME

echo "generate solaris package information"
#pkgsend generate root | pkgfmt > apache-tomcat.p5m.1
pkgmogrify ../apache-tomcat.p5m.1 ../apache-tomcat.mog | pkgfmt > apache-tomcat.p5m.2
pkgdepend generate -md root apache-tomcat.p5m.2 | pkgfmt > apache-tomcat.p5m.3
pkgdepend resolve -m apache-tomcat.p5m.3

echo "verifying package"
pkglint  apache-tomcat.p5m.3.res
pkgrepo create repo
pkgsend -s repo publish -d root apache-tomcat.p5m.3.res
pkgrecv -s repo -a -d apache-tomcat-9.p5p apache-tomcat-9

