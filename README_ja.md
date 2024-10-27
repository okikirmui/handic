# HanDic: morphological analysis dictionary for contemporary Korean

[한국어 Readme](README.md)

HanDic(한딕)は，形態素解析エンジン[MeCab](https://taku910.github.io/mecab/)で現代韓国語を解析するための辞書です．12万を超える辞書項目，書きことばを中心とした6000文以上の[学習用データ](docs/source_list_ja.md)で構築されています．

著作権の問題があるため学習用データ自体の配布はしませんが，学習用モデルファイルはパッケージに含まれています．

## Requirements

  - MeCab
  - Python or Perl

## Installation

git clone

```Shell
$ git clone https://github.com/okikirmui/handic.git
```

もしくはZIPファイルをダウンロード

cloneしたリポジトリ配下のseedディレクトリに移動

```Shell
$ cd handic/seed/
```

ZIPファイルをダウンロードした場合は解凍し，seedディレクトリに移動

```Shell
$ cd handic-main/seed/
```

バイナリ辞書の作成

```Shell
$ /usr/local/libexec/mecab/mecab-dict-index -f utf8 -t utf8
```

パラメータ学習用のモデルファイル`model`が同梱されているので，それを使って配布用辞書を作成（インストール先が`/usr/local/lib/mecab/dic/handic`の場合）

```Shell
$ /usr/local/libexec/mecab/mecab-dict-gen -o /usr/local/lib/mecab/dic/handic -m model
```

解析用バイナリ辞書の作成

```Shell
$ cd /usr/local/lib/mecab/dic/handic
$ /usr/local/libexec/mecab/mecab-dict-index -f utf8 -t utf8
```

解析の際に必要なファイルは，`char.bin`，`dicrc`，`matrix.bin`，`sys.dic`，`unk.dic`です．

## Usage

### 実行時に辞書を指定する

MeCab実行時に`-d`オプションでHanDic辞書ファイルのあるディレクトリを指定します．

```Shell
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

こうした字母への分解は，任意のスクリプトを使って行っても構いません．なお，本プロジェクトでは`tools`ディレクトリにPerl用スクリプト`k2jamo.pl`とPython用スクリプト`k2jamo.py`を同梱しています．

コマンドラインやターミナルで，`k2jamo.pl`を使って`input.txt`（例）を解析する場合：

```Shell
$ perl k2jamo.pl input.txt | mecab -d /usr/local/lib/mecab/dic/handic
```

あるいはコマンドラインやターミナルで直接入力をする場合：

```Shell
$ echo "겨울 방학 때 뭐 했어요?" | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic
```

のように行うことができます．

### トークン化(tokenize)

出力フォーマットを指定する`-O`オプションを用いて，トークン化処理を行うことができます．
出力フォーマットとして`tokenize`を指定します．

```Shell
$ echo "뜻을 가진 가장 작은 말의 단위. ‘이야기책’의 ‘이야기’, ‘책’ 따위이다." | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic -O tokenize
뜻 을 가지 ㄴ 가장 작으 ㄴ 말 의 단위 . ‘ 이야기책 ’ 의 ‘ 이야기 ’ , ‘ 책 ’ 따위 이 다 .
```

## Usage(Python)

[PyPI](https://pypi.org/project/handic/)にて`handic`パッケージを公開しました．
`mecab-python3`パッケージと，入力を変換するための`jamotools`等のパッケージと共に使用します．

インストール:

```Shell
pip install handic mecab-python3 jamotools
```

例:

```Python
import MeCab
import handic
import jamotools

mecaboption = f'-r /dev/null -d {handic.DICDIR}'

tokenizer = MeCab.Tagger(mecaboption)
tokenizer.parse('')

# 『標準国語大辞典』，「형태소」語義
sentence = u'뜻을 가진 가장 작은 말의 단위. ‘이야기책’의 ‘이야기’, ‘책’ 따위이다.'

jamo = jamotools.split_syllables(sentence, jamo_type="JAMO")

node = tokenizer.parseToNode(jamo)
while node:
    print(node.surface, node.feature)
    node = node.next
```

## 品詞情報

品詞に関する情報は，[品詞情報](docs/pos_detail_ja.md)文書を参照してください．

## Author

  - Yoshinori Sugai(Kindai University)

## Copyrights

Copyright (c) 2011- Yoshinori Sugai. All rights reserved.

''HanDic'' is under [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
