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

mv $TOMCAT_DIR/bin $PKG_ROOT/$CATALINA_HOME
mv $TOMCAT_DIR/lib $PKG_ROOT/$CATALINA_HOME

mv $TOMCAT_DIR/conf $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/logs $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/webapps $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/work $PKG_ROOT/$CATALINA_BASE
mv $TOMCAT_DIR/temp $PKG_ROOT/$CATALINA_BASE

mv $TOMCAT_DIR/* $PKG_ROOT/$CATALINA_HOME
