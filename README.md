# HanDic

HanDicは，形態素解析エンジン[MeCab](https://taku910.github.io/mecab/)で利用できる，韓国語の形態素解析用辞書です．

## Requirements

  - MeCab
  - Python or Perl

## Installation

git clone

```console
$ git clone https://github.com/okikirmui/handic_working.git
```

cloneしたリポジトリに移動

```console
$ cd handic_working
```

バイナリ辞書の作成

```console
$ mecab-dict-index -f utf8 -t utf8
```

パラメータ学習用のモデルファイル`model`が同梱されているので，それを使って配布用辞書を作成（インストール先が`/usr/local/lib/mecab/dic/handic`の場合）

```console
$ mecab-dict-gen -o /usr/local/lib/mecab/dic/handic -m model
```

解析用バイナリ辞書の作成

```console
$ cd /usr/local/lib/mecab/dic/handic
$ mecab-dict-index -f utf8 -t utf8
```

## Author

<<<<<<< HEAD
  - Yoshinori Sugai
  - Kindai University
=======
    * Yoshinori Sugai
    * Kindai University
>>>>>>> a51d7f1f12a4ca8d054e2892e3703cd44b29a304

## Copyrights

Copyright (c) 2011- Yoshinori Sugai. All rights reserved.

"HanDic" is under [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
