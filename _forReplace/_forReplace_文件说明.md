_forReplace 目录下的文件有些是自动生成的.所有文件编码都是 `UTF-8`.

文件关系如下:

CreateFiles4Help.ahk 在编译chm之前执行,它将修改 content.js, content.chm.js, Table of Contents.hhc, Index.hhk 这几个文件.

其中:

content.js 文件为这几个文件的组合:

> data_toc.js, data_index.js, data_translate.js, main.js, jquery.js, tree.jquery.js, 

content.chm.js 文件内容为这几个文件的组合:

> data_translate.js, main.js, jquery.js

Table of Contents.hhc 文件内容为这几个文件的组合:

> data_toc.js

Index.hhk 文件内容为这几个文件的组合:

> data_index.js

其中

`data_toc.js` 为目录结构和顺序;

`data_index.js` 为索引列表和顺序;

`data_translate.js` 为翻译标题菜单等翻译;

`main.js` 为一些工具函数,标题,菜单等运行时逻辑;

我们只需要修改这4个 js 文件即可.