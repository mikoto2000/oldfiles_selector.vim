oldfiles_selector.vim
=====================

シンプルで簡単に使える oldfiles セレクタ―です。

Usage:
------

`oldfiles_selector#OpenOldfilesSelector()` を、お好みのキーにマッピングしてください。

設定例 :

```vim
noremap <Leader>mru <Esc>:call oldfiles_selector#OpenOldfilesSelector()<Enter>
```

`oldfiles_selector#OpenOldfilesSelector()` を実行すると、バッファー選択用のバッファーが開きます。

バッファー選択用バッファーで、表示したいバッファーにカーソルを合わせ `<Enter>` を押下してください。


License:
--------

Copyright (C) 2022 mikoto2000

This software is released under the MIT License, see LICENSE

このソフトウェアは MIT ライセンスの下で公開されています。 LICENSE を参照してください。


Author:
-------

mikoto2000 <mikoto2000@gmail.com>
