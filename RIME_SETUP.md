# 本机配置与 Git 同步

`~/Library/Rime` 直接作为 `tongsun99/rime-ice-custom` 的 Git 工作区。
仓库只管理个人配置、模型安装脚本和本文档；基础雾凇方案、词库、Lua、
模型文件、构建结果和用户学习数据由 `.gitignore` 排除。

## 获取 GitHub 上的个人配置更新

```sh
cd ~/Library/Rime
git status
git pull --rebase
sh scripts/install-model.sh
"/Library/Input Methods/Squirrel.app/Contents/MacOS/Squirrel" --reload
```

有未提交的个人配置改动时，先提交后再拉取。拉取遇到冲突时，解决冲突再继续，
不要用 `git reset --hard`、`git clean` 或整目录覆盖的方式同步。
`git pull` 只更新本仓库的个人配置，不更新雾凇上游词库和 Lua。
模型已安装且校验一致时，安装脚本不会再次下载。

## 保存本机修改到 GitHub

```sh
cd ~/Library/Rime
git diff
# 逐个添加本次修改的个人配置文件，例如：
git add double_pinyin_flypy.custom.yaml rime_ice.custom.yaml
git commit -m "config(schema): 更新个人输入方案配置"
git push origin main
```

读取公共仓库无需登录；推送需要 GitHub 写入认证。
不要提交邮箱短语、账号等私人内容；本仓库为公开仓库。

## 万象本地语言模型

全拼 `rime_ice` 和小鹤双拼 `double_pinyin_flypy` 通过各自的 custom 补丁加载
`wanxiang-lts-zh-hans.gram`。保留小鹤双拼原有的 `translator/preedit_format: []`。
模型参数采用雾凇官方的 `others/recipes/grammar.recipe.yaml` 配方，
改善整句组合，不启用 `contextual_suggestions`。

模型来自 <https://github.com/amzxyz/RIME-LMDG/releases/tag/LTS>，
本次核对文件大小为 404,661,292 字节，SHA-256：

```text
e3f958d2557a2c027543e874c802dcce9022b9b6fe1673d97c0bd1ef30592264
```

约 405 MB 的模型只保存在本机，不纳入 Git。GitHub 的 LTS 资产可能替换，
脚本遇到校验不符会停止；需要核对新版资产后再更新脚本中的 SHA-256。

## 备份与停用模型

本次操作前的完整目录备份位于：
`/Users/tongsun/Documents/Codex/2026-10-03/ni-k/work/rime-backup-before-model`。
其中包含用户词库，请留在本机。

停用模型时，从两个方案 custom 文件中去掉此次新增的 grammar 和 translator
配置，保留小鹤原有的 preedit_format 配置，再重新部署即可。
无需删除模型、用户词库或整个配置目录。
