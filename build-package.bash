#!/bin/bash

#
# Parameter{1} SKU_DIR: the vendor folder to be build [must have]
# Parameter{2} the branch being build[ optional ]
#
#
set -x
set -e
DEBDIR="./debianstatic"
SKU_DIR=${1}
BRANCH=${2}

if [ ! -d "${DEBDIR}" ]; then 
    echo "no such debian directory ${DEBDIR}"
    exit 1 
fi

if [ ! -d  ${SKU_DIR} ]; then
    echo "[Error] No such vendor folder found :${SKU_DIR}"
    exit 2
fi


rm -rf ${SKU_DIR}_*
rm -rf packagebuild
mkdir -p packagebuild/debian 


git log -1 --pretty=format:%h.%ai.%s ${SKU_DIR} > commitstring.txt
export DEBFULLNAME=`git log -1 --pretty=format:%an ${SKU_DIR}`
export DEBEMAIL=`git log -1 --pretty=format:%ae ${SKU_DIR}`
export DEBBRANCH=`echo "${BRANCH}" | sed 's/[\/\_]/-/g'`
export DEBCOMMIT_DATE=`git log -1 --pretty=format:%ai ${SKU_DIR} |awk '{print $1}' `
export DEBCOMMIT_HASH=`git log -1 --pretty=format:%h ${SKU_DIR}`
export DEBCOMMIT=`git log -1 --pretty=oneline --abbrev-commit ${SKU_DIR}`
#export DEBPKGVER=-${DEBBRANCH}${DEBCOMMIT_DATE}-${DEBCOMMIT_HASH} # abondon $DEBBRANCH, since the strategy is to modify the debian/changelog for each release-branch
export DEBPKGVER=-${DEBCOMMIT_DATE}-${DEBCOMMIT_HASH}

pushd ${SKU_DIR}
tar czf ../packagebuild/${SKU_DIR}.tar.gz *
popd

pushd packagebuild
rsync -ar ../${DEBDIR}/ debian/

cat > /tmp/sed.script << EOF
s%{{name}}%${SKU_DIR}%
EOF

find . -type f -iname "*.in" -print0 | while IFS= read -r -d $'\0' file; do
    outFile=$(echo $file | sed -f /tmp/sed.script)
    cat $file | sed -f /tmp/sed.script > ${outFile%.in}
    rm $file
done
rm /tmp/sed.script

################################################################################
# dch=debchange
# -l : Add a suffix to the Debian version number for a local build
# text(${DEBPKGVER}) : a string in changelog for this new local debian version(packagebuild/debian/changelog)
###############################################################################
dch -l "${DEBPKGVER}" -u low "${DEBCOMMIT}"
debuild --no-lintian --no-tgz-check -us -uc
popd

mkdir -p tarballs && mv packagebuild/${SKU_DIR}.tar.gz tarballs/${SKU_DIR}_${DEBPKGVER}.tar.gz

ls -l .
