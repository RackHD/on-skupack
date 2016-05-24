# Platform-R-KP (S2600KP) skupack

## Firmware upgrade
- The intel overlayFS image should be placed into the static directory.  To build the overlayFS:
```
git clone https://github.com/RackHD/on-imagebuilder
cd on-imagebuilder
sudo ansible-playbook -i hosts common/overlay_wrapper.yml -e "config_file=vars/oem/intel.yml provisioner=roles/oem/overlay/provision_intel_flashing_overlay"
cp /tmp/on-imagebuilder/builds/flash_intel.overlay.cpio.gz /location/of/skupack/static
```
The firmware upgrade files can be found here:
 1. [One Boot Flash Update Utility](https://downloadcenter.intel.com/download/25265/Intel-One-Boot-Flash-Update-Utility)
 2. [Save and Restore System Configuration utility](https://downloadcenter.intel.com/download/25439/Save-and-Restore-System-Configuration-utility-syscfg-)

- The firmware files should be acquired from the vendor.  The firmware can be acquired [here](https://downloadcenter.intel.com/download/25971/Intel-Server-Board-S2600KP-Family-BIOS-and-Firmware-update-for-OFU-and-WinPE).  The firmware image should then be placed into the static directory.
- The following vendor versions have been validated with this skupack
 1. 1.01.0016

**Run a firmware upgrade against a node**
```
POST
/api/1.1/nodes/<id>/workflows
{
    "name": "Graph.Flash.Intel.Firmware"
}
```

**Run a firmware upgrade against a node without rebooting at the end**
```
POST
/api/1.1/nodes/<id>/workflows
{
    "name": "Graph.Flash.Intel.Firmware"
    "options": {
        "when-reboot-at-end": {
            "rebootAtEnd": "false"
        }
    }
}
```
**Run a firmware upgrade against a node with a file override**
```
POST
/api/1.1/nodes/<id>/workflows
{
    "name": "Graph.Flash.Intel.Firmware"
    "options": {
        "upgrade-firmware": {
            "file": "file.img"
        }
    }
}
```
The file should be uploaded to the RackHD instance with the Files API before
invoking the workflow and the "file" property should be set to the value of
the resource name specified in the files URI
```
curl -X PUT -T file.img http://localhost:8080/api/current/files/file.img
```

