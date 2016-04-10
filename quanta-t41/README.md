# Quanta T41 skupack

## BIOS firmware upgarde
- The BIOS firmware files should be acquired from the vendor.  The BIOS image and BIOS upgrade executable are then extracted into the /static/bios location of the skupack and the config.json should be updated with the md5sum of the firmware image.
- The following vendor versions have been validated with this skupack
 1. S2S_3A14
 2. S2S_3A17
 3. S2S_3A18

## BMC firmware upgrade
- The BMC firmware files should be acquired from the vendor.  The BMC image and BMC upgrade executable are then extracted into the /static/bmc location of the skupack and the config.json should be updated with the md5sum of the firmware image.
- The following vendor versions have been validated with this skupack
 1. 3.30
 2. 3.36
 3. 3.38

## NVRAM firmware upgrade
- The NVRAM image should be built following the vendor provided instructions.  Once built, the NVRAM configuration file and the NVRAM upgrade executable should be placed in the /static/bios location of the skupack and the config.json should be updated with the md5sum of the firmware image.