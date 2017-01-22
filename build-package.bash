#!/bin/bash -ex

DEBDIR="./debianstatic"
DEBNAME=${1,,}
BRANCH=${2}

if [ ! -d "${DEBDIR}" ]; then 
    echo "no such debian directory ${DEBDIR}"
    exit 1 
fi


rm -rf ${1}_*
rm -rf packagebuild
mkdir -p packagebuild/debian 


git log -1 --pretty=format:%h.%ai.%s ${1} > commitstring.txt
export DEBFULLNAME=`git log -1 --pretty=format:%an ${1}`
export DEBEMAIL=`git log -1 --pretty=format:%ae ${1}`
export DEBBRANCH=`echo "${BRANCH}" | sed 's/[\/\_]/-/g'`  
export DEBPKGVER=`git log -1 --pretty=oneline --abbrev-commit ${1}`

pushd ${1}
tar czf ../packagebuild/${DEBNAME}.tar.gz *
popd

pushd packagebuild
rsync -ar ../${DEBDIR}/ debian/

cat > /tmp/sed.script << EOF
s%{{name}}%${DEBNAME}%
EOF

find . -type f -iname "*.in" -print0 | while IFS= read -r -d $'\0' file; do
    outFile=$(echo $file | sed -f /tmp/sed.script)
    cat $file | sed -f /tmp/sed.script > ${outFile%.in}
    rm $file
done
rm /tmp/sed.script

dch -l "${DEBBRANCH}" -u low "${DEBPKGVER}"
debuild --no-lintian --no-tgz-check -us -uc
popd

mkdir -p tarballs && mv packagebuild/${DEBNAME}.tar.gz tarballs/${1}_${DEBBRANCH}.tar.gz

ls -l .
