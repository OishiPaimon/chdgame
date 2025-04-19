# Git开发管理及常用命令

## 一、版本管理

- 每个人所有新开发功能或者修复 bug 都先创建自己的分支完成，自测没问题后，再合并回 `dev` 分支。
- 不要直接在 `dev` 分支上进行修改，除非是特别小的问题（如修改某个文本显示等）。
- 提交时，修改内容尽量描述清楚，省得日后不知道是因为什么而改的。
- 合并 `dev` 时，记得解决好冲突。

## 二、示例

```bash
git fetch -p               # 获取远端分支
git pull origin dev        # 拉取远端代码
git checkout -b XXXX       # 创建分支（XXXX为分支名）

# 开发过程
git status                 # 获取修改状态
git diff xxxx              # 查看区别
git mergetool              # 如果有冲突时用于解决冲突
git add xxx                # 添加要上传的内容
git commit "说明"          # 提交
git push origin xxx        # 上传远端（xxx为分支名）

# 暂存与恢复
git stash                  # 暂存修改
git stash pop              # 取出暂存

# 分支合并
git checkout dev           # 切回dev分支
git merge xxx              # 合并分支（xxx为分支名）
```

参考链接：[https://blog.csdn.net/bufegar0/article/details/109597640](https://blog.csdn.net/bufegar0/article/details/109597640)
