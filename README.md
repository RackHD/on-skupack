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

  ```
  $ ./build-package.bash <sku_pack_directory> <subname>
  ```
  
  * Example
  
  ```
  $ ./build-package.bash quanta-t41 master
  ```
  
* Register a new SKU with the package

  ```
  $ curl -X POST -F file=@tarballs/sku_pack_directory_subname.tar.gz localhost:8080/api/current/skus/pack
  ```

* Please refer to [SKU PACK Guide](http://rackhd.readthedocs.org/en/latest/rackhd/index.html#workflow-sku-support) for more API commands
