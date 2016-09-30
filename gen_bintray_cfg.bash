#!/bin/bash

#
# Parameter{2} the branch being build[ optional ]
#
#
set -x
set -e


export REPO_COMMIT_DATE=`git log -1 --pretty=format:%ai  |awk '{print $1}' `
export REPO_COMMIT_HASH=`git log -1 --pretty=format:%h `
export REPO_PKGVER=${TRAVIS_BRANCH}-${REPO_COMMIT_DATE}-${REPO_COMMIT_HASH}


STATIC_REPO_PREFIX="static-"
DEB_REPO_PREFIX="rackhd-trial-"

sed  -e "s/#REPO_NAME#/${STATIC_REPO_PREFIX}${TRAVIS_BRANCH}/g" \
     -e "s/#REVISION#/${REPO_PKGVER}/g"  \
     .bintray-gen.json.in       > .bintray-gen.json

sed -e "s/#REPO_NAME#/${DEB_REPO_PREFIX}${TRAVIS_BRANCH}/g"  \
    -e "s/#REVISION#/${REPO_PKGVER}/g"   \
    .bintray-deb.json.in > .bintray-deb.json

cat .bintray-gen.json



cat .bintray-deb.json

