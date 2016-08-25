#!/bin/bash
set -xe
DOWNLOAD_DIR=/opt/downloads
CMD="<%= sku.biosFirmware.command %>"
CMD=${CMD##*/}
CMD="/opt/ami/${CMD}"

#
# Retrieve the update script and run it
mkdir -p /opt/ami
curl --retry 3 <%=api.server%>/<%= sku.biosFirmware.command %> -o ${CMD}
chmod 777 ${CMD}

#
# Download the sku specific file if it exists
filename=<%= sku.biosFirmware.filename %>
curl --retry 3 <%=api.server%>/${filename} -o ${DOWNLOAD_DIR}/${filename##*/}
md5=($(md5sum ${DOWNLOAD_DIR}/${filename##*/}))
test ${md5} = "<%= sku.biosFirmware.md5sum %>"
FLASH_FILE=${DOWNLOAD_DIR}/${filename##*/}

#
# Download the user uploaded file if specified to override default
<% if (typeof file !== 'undefined' && file) { %>
  fileMd5Uri="<%=api.files%>/md5/<%=file%>/latest"
  fileUri="<%=api.files%>/<%=file%>/latest"
  outputPath="${DOWNLOAD_DIR}/<%= file %>"
  curl --retry 3 ${fileUri} -o ${outputPath}
  md5=($(md5sum ${outputPath}))
  test `curl ${fileMd5Uri}` = "\"${md5}\""
  FLASH_FILE=${outputPath}
<% } %>

pushd ${DOWNLOAD_DIR}

#Snapshot the current image
VERSION=`${CMD} /S | grep 'ROM ID' | awk -F= '{print $2}' | tr -d ' '`
${CMD} backup.bin /O
curl -T ./${BACKUP_FILE} <%= api.files %>/<%= nodeId %>-${VERSION}

# Flash new image
${CMD} <%= sku.biosFirmware.args %>

