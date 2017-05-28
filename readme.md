# AutoHotkey_L-Docs 中文化项目

欢迎各位Ahker都参与进来,通过 Pull Request 或 提交 Issues 的方式均可.

对于有能力的朋友,如果本项目对您有帮助,欢迎用打赏的方式支持我们(微信扫描下方的二维码).

## 翻译工作流程:

- Step 1: 从 [官方Git](https://github.com/Lexikos/AutoHotkey_L-Docs.git) 获取更新 (fork & pull);
- Step 2: 直接覆盖 [本项目](https://git.oschina.net/fonny/AutoHotkey_L-Docs) 中的 `en` 分支,得到最新完整差异文件列表;
- Step 3: 获取更新差异: 逐一比较差异文件,得到 **每个差异文件的修改行以及修改的内容详细情况**;
- Step 4: 建立任务列表: 将 en 分支中有差异的文件复制到 dev 分支.如果存在同名文件则覆盖,得到需要汉化或修改的文件列表, **作为任务列表**;
- Step 5: 本地翻译: 以 `dev` 分支中的每一个文件为基础,比较 `master` 分支的同名文件,翻译修改 `master` 分支的文件;
- Step 6: 更新任务列表: 翻译完成之后,保存 `master` 分支的文件,同时删除 `dev` 分支的对应文件,表示该文件翻译完成;
- Step 7: 提交翻译: 提交并推送 dev 分支和 dev 分支,保存工作成果.
- Step 8: 任务列表还有文件则 `Goto setp 5`.

## TODO

### 辅助工具需求

上述流程中, Step 1 - 4 的工作用程序自动完成.


## 翻译技巧

- `Step 3` 能得到更新的具体位置,可以避免逐行查找更新;
- 学习使用 `BeyondCompare` 工具,可以方便的进行逐行对比翻译;

## 捐助

![捐助](http://cn.goldrobot.org/statics/img/donate.gif)