---
title: Hexo 搭建记录 Hello World
date: 2021/1/18 22:31:19
excerpt: 此 Blog 搭建过程记录（保持更新）
---

## 用 [Hexo](https://hexo.io) 搭建的博客

好处不用说了，比如可以直接写 `Markdown` 等等，搜索 `Hexo` 会得到一大把相关说明甚至教程。

`Hello World` 就用来存这个 blog 的搭建过程和基本配置吧。

如果后续有工具或组件的更新，也会写在这篇内容里…… 


### 基础搭建

> 确认 `node.js` 和 `yarn` 已经准备好

```console
$ npm i -g hexo-cli
$ npm init blog
$ cd blog
$ yarn

## 自动显示字数和阅读时间
$ yarn add hexo-wordcount

## 自动在中文和英文之间加入空格
$ yarn add hexo-filter-auto-spacing

## 自动摘要（我没装，感觉我选的主题不装它更美观，有需要的同学自己动手吧）
$ yarn add hexo-auto-excerpt

## 自动实时预览
$ npm i -g browser-sync
$ yarn add --dev hexo-browsersync
```

### 安装 Acetolog 主题并设置图标和头像

> Acetolog: https://github.com/iGuan7u/Acetolog

```console
$ yarn add hexo-renderer-swig
$ cd themes
$ git clone https://github.com/iGuan7u/Acetolog
```


#### favicon 图标文件

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


## 自动构建并发布到 GitHub Pages

（使用 GitHub Actions）配置 `.github/workflows/ci.yml`：

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

      - name: install
        run: sudo npm install -g hexo-cli && yarn

      - name: build
        run: hexo generate && cp README.md ./dist/

      - name: deploy
        uses: JamesIves/github-pages-deploy-action@4.0.0
        with:
          branch: gh-pages
          folder: dist
```


### 独立域名

在 `source` 下建立 `CNAME` 文件，写入本站的域名

```text
12345.blog
```


### 增加 `https` 支持

1. 将 `NS` 切换到 [CloudFlare](https://cloudflare.com)
2. 确认 `DNS` 的 `CNAME` 解析正确
3. 然后开启 `SSL` 的默认配置



## 使用 ImgBot 自动压缩优化图片文件

很方便：自动压缩优化图片文件，提高访问速度。

进入 GitHub 的 [Marketplace](https://github.com/marketplace) 找到 [ImgBot](https://github.com/marketplace/imgbot) 执行一下安装，本站的代码库开源（免费使用 ImgBot，开源库都可以免费使用它），然后这货会自动发现可以压缩优化的图片，自动提交 PR 到代码库。

比如本站的第 1 次 PR [链接在此](https://github.com/12345blog/12345blog.github.io/pull/1)，压掉了 21% 的图片体积，咱只管 Merge 合并就可以了……

---------

终 <THE END>
