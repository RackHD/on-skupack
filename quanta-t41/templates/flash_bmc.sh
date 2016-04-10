#!/bin/bash
set -xe
DOWNLOAD_DIR=/opt/downloads
CMD="<%= sku.bmcFirmware.command %>"
CMD=${CMD##*/}
CMD="/opt/downloads/${CMD}"


#
# Download the sku specific file if it exists
filename=<%= sku.bmcFirmware.filename %>
curl --retry 3 <%=api.server%>/${filename} -o ${DOWNLOAD_DIR}/${filename##*/}
md5=($(md5sum ${DOWNLOAD_DIR}/${filename##*/}))
test ${md5} = "<%= sku.bmcFirmware.md5sum %>"
FLASH_FILE=${DOWNLOAD_DIR}/${filename##*/}

#
# Download the user uploaded file if specified to override default
<% if (typeof file !== 'undefined' && file) { %>
  fileMd5Uri="<%=api.files%>/md5/<%=file%>/latest"
  fileUri="<%=api.files%>/<%=file%>/latest"
  outputPath="${DOWNLOAD_DIR}/<%= file %>"
  curl --retry 3 ${fileUri} -o ${outputPath}
  md5=($(md5sum ${outputPath}))
  test `curl ${fileMd5Uri}` = "${md5}"
  FLASH_FILE=${outputPath}
<% } %>

#
# Retrieve the update script and run it
curl --retry 3 <%=api.server%>/<%= sku.bmcFirmware.command %> -o ${CMD}
pushd ${DOWNLOAD_DIR}
chmod 777 ${CMD}
${CMD} <%= sku.bmcFirmware.args %>



