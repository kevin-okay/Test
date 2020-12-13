_forReplace 目录下的文件有些是自动生成的.所有文件编码都是 `UTF-8`.

文件关系如下:

CreateFiles4Help.ahk 在编译chm之前执行,它将修改 content.js, content.chm.js, Table of Contents.hhc, Index.hhk 这几个文件.

其中:

content.js 文件为这几个文件的组合:

> jquery.js, tree.jquery.js, data_toc.js, data_index.js, data_translate.js, main.js

content.chm.js 文件内容为这几个文件的组合:

> jquery.js, data_translate.js, main.js

Table of Contents.hhc 文件内容为这几个文件的组合:

> data_toc.js

Index.hhk 文件内容为这几个文件的组合:

> data_index.js

所以,我们只需要修改这些js文件内容,即可修改chm中的"索引","目录","翻译"等内容.