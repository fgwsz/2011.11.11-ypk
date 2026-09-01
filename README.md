# 游戏王 `2011.11.11` `OCG` `&` `TCG`环境补丁
(支持`YGOPro` `&` `YGOPro2` `&` `MDPro` `&` `YGOMobile`)

## 使用方法
### 1.生成补丁
#### 1.1 生成`2011.11.11`(`20110901`)环境补丁
`Windows`系统(GBK编码)运行
```powershell
./create-utility_lua.ps1
./create-ypk-cp936.ps1
```

`Windows`系统(unicode编码)运行
```powershell
./create-utility_lua.ps1
./create-ypk-utf8.ps1
```

`Linux`  系统运行
```bash
./create-utility_lua.sh
./create-ypk.sh
```
#### 1.2 生成`706`(`20110301`)环境补丁
`Windows`系统运行
```powershell
./create-utility_lua.ps1
./create-706-ypk.ps1
```

`Linux`  系统运行
```bash
./create-utility_lua.sh
./create-706-ypk.sh
```
### 2.将补丁存放到指定位置
`YGOPro`    根目录 `expansions`文件夹下(如果没有这个文件夹请新建一个)

`YGOPro2`   根目录 `Expansions`文件夹下(如果没有这个文件夹请新建一个)

`MDPro`     根目录 `Expansions`文件夹下(如果没有这个文件夹请新建一个)

`YGOMobile` 根目录 `expansions`文件夹下(如果没有这个文件夹请新建一个)

### 3.设置勾选启用扩展卡调试功能
### 4.搜索卡片时,开启多标签搜索功能
- `2011.11.11`(`20110901`)环境每次搜卡请添加`2011`字样
- `706`(`20110301`)环境每次搜卡请添加`706`字样
### 5.更新补丁的方式:删除旧补丁,存放新补丁即可

## 第三方库来源
`script`:

<https://github.com/purerosefallen/specials/tree/master/706>

`DataEditorX`:

<https://github.com/247321453/DataEditorX>
