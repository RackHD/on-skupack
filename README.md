# on-skupack
Maintain SKU specific package content such as templates and other static files.

# Quick Start
* Prerequisites

  * Debian based build system or equivalent that can install the necessary dependencies (i.e. Ubuntu 12.04 & up)
  * Install the following packages (Ubuntu example):
  
   ```
   sudo apt-get install dh-make devscripts debhelper
   ```

* Build SKU package

  * On the root directory of on-skupack repo run:

  ```
  $ ./build-package.bash <sku_pack_directory> <subname>
  Note: <sku_pack_directory> must be one of the directory names containing the node type on the root directory of on-skupack, e.g., it can be quanta-d51-1u,
  quanta-t41,dell-r630, etc, and <subname> can be any name a user likes. A {sku_pack_directory_subname}.tar.gz will be created in tarballs folder of the same directory
  ```
  
  * Example
  
  ```
  $ ./build-package.bash quanta-t41 master
  Note: After running this command, quanta-t41_master.tar.gz could be found at the tarballs folder which is under the root directory of on-skupack repo.
  ```
  
* Register a new SKU with the package

  ```
  $ curl -X POST -F file=@tarballs/sku_pack_directory_subname.tar.gz localhost:8080/api/current/skus/pack
  Note: The above command will return a SKU ID. If an error like “Duplicate name found”
  is returned in place of the the SKU ID, check the database (with the command:$ curl {ORA IP}:8080/api/current/skus | python -mjson.tool ) and delete
  a preexisting SKU package ( with the command: $ curl -X DELETE {ORA IP}:8080/api/current/skus/{sku id})
  ```

* Please refer to [SKU PACK Guide](http://rackhd.readthedocs.org/en/latest/rackhd/index.html#workflow-sku-support) for more API commands
