# on-skupack
Maintain SKU specific package content such as templates and other static files.

# Quick Start
* Build SKU package

```
$ ./build-package.bash <sku_pack_directory> <subname>
```

* Register a new SKU with the package
```
$ curl -X POST --data-binary @sku_pack_directory_subname.tar.gz http://localhost:8080/api/common/skus/pack
```

* Please refer to [SKU PACK Guide](http://rackhd.readthedocs.org/en/latest/rackhd/index.html#workflow-sku-support) for more API commands
