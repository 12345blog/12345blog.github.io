---
title: Hexo 搭建记录 Hello World
date: 2021/1/18 22:31:19
excerpt: 此 Blog 搭建过程记录（保持更新）
---

## 用 [Hexo](https://hexo.io) 搭建博客并托管到 `GitHub`

好处不用说了，比如可以直接写 `Markdown` 等等，搜索 `Hexo` 会得到一大把相关说明甚至教程。

`Hello World` 就用来存这个 blog 的搭建过程和基本配置吧。

如果后续有工具或组件的更新，也会写在这篇内容里…… 


### 基础搭建

> 确认 `node.js` 和 `yarn` 已经准备好

```console
$ npm i -g hexo-cli
$ npm init blog  # 演示使用 blog 目录，可任意命名
$ cd blog
$ yarn

## 自动显示字数和阅读时间
$ yarn add hexo-wordcount

## 自动在中文和英文之间加入空格（编码习惯好的话，可以不必用）
$ yarn add hexo-filter-auto-spacing

## 自动摘要（我没装，感觉我选的主题不装它更美观，有需要的同学自己动手吧）
$ yarn add hexo-auto-excerpt

## 自动实时预览
$ npm i -g browser-sync
$ yarn add --dev hexo-browsersync
```

### 安装 `Acetolog` 主题并设置图标和头像

> Acetolog: https://github.com/iGuan7u/Acetolog

```console
$ yarn add hexo-renderer-swig
$ cd themes
$ git clone https://github.com/iGuan7u/Acetolog
```


#### `favicon` 图标文件

由 [favicon.io](https://favicon.io) 生成，解矸后存放在资源文件夹 `source` 里


### 设置整站 `_config.yml` 配置信息

```yaml
title: 12345.blog
subtitle: Neo Smith's blog
description: 懂一点代码的独立投资人
bio: Valuable or interesting
keywords: Neo Smith NeoSmith
author: Neo Smith
#language: en
language: zh_CN
#timezone: Asia/Shanghai
timezone: ''
avatar: https://secure.gravatar.com/avatar/4927b9863674cda74b85dbce5acc6ab6?s=800&d=identicon
url: https://12345.blog
permalink: :year/:title/  # 永久链接格式
auto_spacing: true  # 自动在中文和英文之间加入空格

public_dir: dist  # 更改发布目录为 ./dist

theme: Acetolog  # 使用 Acetolog 主题
highlight:
  enable: true
  hljs: true  # 开启代码高亮

# 其它的要么不必要修改，要么还不知道是啥，就这样吧
```


## 自动构建并发布到 `GitHub Pages`

库名使用 `<你的 GitHub 用户名>.github.io` 这样不必自建服务器，直接使用 `GitHub Pages` 托管。

需要懂一些 Git 的基本操作，这部分是基础技能，略

自动构建用到 `GitHub` 的 `Actions` 功能。

我这个可以直接抄去用，会自动生成博客并发布到 `gh-pages` 分支，配置 `.github/workflows/ci.yml` 文件：

```yaml
name: Auto Deploy

on:
  push:
    branches:
      - main

jobs:
  auto-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: timezone
        run: export TZ='Asia/Shanghai'  # 使用中国时区

      - name: checkout
        uses: actions/checkout@v2
        with:
          persist-credentials: false

      - name: hexo-cli
        run: sudo npm install -g hexo-cli

      - name: install
        run: yarn

      - name: build
        run: hexo generate && cp README.md ./dist/

      - name: deploy
        uses: JamesIves/github-pages-deploy-action@4.0.0
        with:
          branch: gh-pages
          folder: dist
```

自动构建完成后，进入代码库的 `Settings - GitHub Pages` 将 `gh-pages` 分支选为源，保存修改就能使用 `https://<你的 GitHub 用户名>.github.io/` 访问生成好的博客网站啦


### 如需独立域名

在 `source` 下建立 `CNAME` 文件，写入本站的域名

```text
12345.blog
```


### 为独立域名增加 `https` 支持

1. 将 `NS` 切换到 [CloudFlare](https://cloudflare.com)
2. 确认 `DNS` 的 `CNAME` 解析正确
3. 然后开启 `SSL` 的默认配置



## 使用 `ImgBot` 自动压缩优化图片文件

很方便：自动压缩优化图片文件，提高访问速度。

进入 GitHub 的 [Marketplace](https://github.com/marketplace) 找到 [ImgBot](https://github.com/marketplace/imgbot) 执行一下安装，本站的代码库开源（免费使用 ImgBot，开源库都可以免费使用它），然后这货会自动发现可以压缩优化的图片，自动提交 PR 到代码库。

比如本站的第 1 次 PR [链接在此](https://github.com/12345blog/12345blog.github.io/pull/1)，压掉了 21% 的图片体积，咱只管 Merge 合并就可以了……


## 配置 `gitalk` 留言插件

干净，整洁，好吃……

使用 `GitHub` 的 `Issues` 功能完成留言、回复、管理，推荐另建一个专用的库以保证博客源库的整洁。


### 申请 `GitHub` 的 `OAuth App`

去 `https://github.com/organizations/<你的 GitHub 用户名>/settings/applications` 申请一个新的 `OAuth App`

任意命名，可以不用上传 logo 但 `Homepage URL` 和 `Authorization callback URL` 一定要写填博客站点的首页地址，比如我的就是 `https://12345.blog/`



### 配置 `gitalk`

在 `themes/Acetolog/_config.yml` 中配置 `gitalk` 段：

```yaml
gitalk:
  enable: true
  clientID: xxx  # 填你自己的 Client ID
  clientSecret: xxx  # 填你自己的 Client secret
  repo: gitalk  # 专用的 repo 库名
  owner: username  # 所有者，GitHub 用户名或者组织用户名
  admin: username  # 管理员，填你自己的 GitHub 用户名
```

基本不必担心 `Client secret` 因为开源泄露，因为回调地址已经在 `OAuth App` 里配置好了……

---------

PEACE

终
