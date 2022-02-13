# HanDic: morphological analysis dictionary for contemporary Korean

HanDic(한딕)は，形態素解析エンジン[MeCab](https://taku910.github.io/mecab/)で現代韓国語を解析するための辞書です．11万を超える辞書項目，書きことばを中心とした5000文以上の学習用データで構築されています．

## Requirements

  - MeCab
  - Python or Perl

## Installation

git clone

```console
$ git clone https://github.com/okikirmui/handic.git
```

cloneしたリポジトリ配下のseedディレクトリに移動

```console
$ cd handic/seed/
```

バイナリ辞書の作成

```console
$ /usr/local/libexec/mecab-dict-index -f utf8 -t utf8
```

パラメータ学習用のモデルファイル`model`が同梱されているので，それを使って配布用辞書を作成（インストール先が`/usr/local/lib/mecab/dic/handic`の場合）

```console
$ /usr/local/libexec/mecab-dict-gen -o /usr/local/lib/mecab/dic/handic -m model
```

解析用バイナリ辞書の作成

```console
$ cd /usr/local/lib/mecab/dic/handic
$ /usr/local/libexec/mecab-dict-index -f utf8 -t utf8
```

## Usage

### 実行時に辞書を指定する

MeCab実行時に`-d`オプションでHanDic辞書ファイルのあるディレクトリを指定します．

```console
$ mecab -d /usr/local/lib/mecab/dic/handic
```

この方法では，実行するたびに辞書を指定する必要があります．

### 設定ファイルで辞書を指定する

ホームディレクトリに`.mecabrc`を作成して，`dicdir`にHanDic辞書ファイルのあるディレクトリを記述します．

```text
dicdir = /usr/local/lib/mecab/dic/handic
```

この方法では，常にHanDicを使って解析することになります．

### 入力を与える

HanDicは，UTF-8エンコーディングされたテキストを入力として形態素解析を行います．
また，入力は通常のハングル（Hangul Syllables「ハングル音節文字」領域の文字，いわゆる「完成型ハングル」）ではなく，初声・中声・終声の字母に分解した入力（Hangul Jamo「ハングル字母」領域の文字）である必要があります．
例えば完成型ハングルの「몸」（U+BAB8）は，字母に分解すると「ㅁ」（U+1106）「ㅗ」（U+1169）「ㅁ」（U+11B7）となります．

こうした字母への分解は，任意のスクリプトを使って行っても構いません．なお，本プロジェクトではPerl用スクリプトk2jamo.plとPython用スクリプトpy_k2jamo.py（[ダウンロード-OSDN](https://ja.osdn.net/rel/handic/tools/k2jamo)）を作成し，配布しています．

コマンドラインやターミナルで，k2jamo.plを使ってinput.txt（例）を解析する場合：

```console
$ perl k2jamo.pl input.txt | mecab -d /usr/local/lib/mecab/dic/handic
```

あるいはコマンドラインやターミナルで直接入力をする場合：

```console
$ echo "겨울 방학 때 뭐 했어요?" | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic
```

のように行うことができます．

## Author

  - Yoshinori Sugai(Kindai University)

## Copyrights

Copyright (c) 2011- Yoshinori Sugai. All rights reserved.

''HanDic'' is under [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
