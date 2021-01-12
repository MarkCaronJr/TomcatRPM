#!/bin/bash

MAJOR=`grep major_version tomcat.spec | head -1 | awk '{ print $3 }'`
MINOR=`grep minor_version tomcat.spec | head -1 | awk '{ print $3 }'`
PATCH=`grep patch_version tomcat.spec | head -1 | awk '{ print $3 }'`
RELEASE=`grep Release: tomcat.spec    | sed "s/Release:\s\+\([0-9]*\).*/\1/"`
VER="$MAJOR.$MINOR.$PATCH-$RELEASE"
FILE=`ls *.rpm`
echo "::set-output name=VERSION::$VER"
ehco "::set-output name=$FILE"