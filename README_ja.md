# HanDic: morphological analysis dictionary for contemporary Korean

한국어 Readmel: [README.md](README.md)

HanDic(한딕)は，形態素解析エンジン[MeCab](https://taku910.github.io/mecab/)で現代韓国語を解析するための辞書です．13万を超える辞書項目，書きことばを中心とした14,000文以上の[学習用データ](docs/source_list_ja.md)で構築されています．

## Quick Start(Python / pip)

Pythonパッケージ **`handic`** を使えば，辞書ファイルの構築なしに，すぐ形態素解析を始めることができます．

### パッケージのインストール

```bash
pip install handic mecab-python3 jamotools
```

### 形態素解析の例

```python
import handic

text = "우리가 평생 내는 의료비는 어디로 가장 많이 흘러갈까?"

print(handic.pos_tag(text))
print(handic.tokenize_hangul(text, mode="surface"))
print(handic.convert_text_to_hanja_hangul(text))
```

**出力**

```python
[('우리03', 'NP'), ('가11', 'JKS'), ('평생', 'NNG'), ('내다02', 'VV'), ('는03', 'ETM'), ('의료비', 'NNG'), ('는01', 'JX'), ('어디01', 'NP'), ('로06', 'JKB'), ('가장01', 'MAG'), ('많이', 'MAG'), ('흘러가다', 'VV'), ('ㄹ까', 'EF'), ('?', 'SF')]
['우리', '가', '평생', '내', '는', '의료비', '는', '어디', '로', '가장', '많이', '흘러가', 'ㄹ까', '?']
우리가 平生 내는 醫療費는 어디로 가장 많이 흘러갈까?
```

## HanDicの特徴

- 現代韓国語の形態素解析用辞書
- 言語学に基づいた品詞・形態素の設定
- MeCabを用いるため，処理が高速
- Python(`handic`)パッケージを用いて簡単に使用可能

著作権の問題があるため学習用データ自体の配布はしませんが，学習用モデルファイルはパッケージに含まれています．

### Pythonパッケージ (`handic`)

- PyPI: https://pypi.org/project/handic/
- MeCab Pythonラッパー（`mecab-python3`）, ハングル処理パッケージ（`jamotools`）とともに使用

## Dictionary Build

Pythonを使わない場合，ローカルのMeCabで形態素解析処理を行う場合，以下を実行してください．

## Requirements

  - MeCab
  - Python or Perl

### 辞書構築の手順（要約）

`mecab-dict-index`や`mecab-dict-gen`などの位置は，`mecab-config --libexecdir`の出力を参照してください．
ここでは，`/usr/local/libexec/mecab`にあると仮定しています．

```bash
# git clone
$ git clone https://github.com/okikirmui/handic.git
$ cd handic
# indexing
$ /usr/local/libexec/mecab/mecab-dict-index -f utf8 -t utf8
# 学習済みモデルである`model`ファイルを使用して，バイナリ辞書を構築
# /usr/local/lib/mecab/dic/handic ディレクトリに出力
$ /usr/local/libexec/mecab/mecab-dict-gen -o /usr/local/lib/mecab/dic/handic -m model
# 配布用バイナリ辞書構築
$ cd /usr/local/lib/mecab/dic/handic
$ /usr/local/libexec/mecab/mecab-dict-index -f utf8 -t utf8
```

解析の際に必要なファイルは，`char.bin`，`dicrc`，`matrix.bin`，`sys.dic`，`unk.dic`です．

## Usage

### 実行時に辞書を指定する

MeCab実行時に`-d`オプションでHanDic辞書ファイルのあるディレクトリを指定します．

```bash
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

```bash
$ perl k2jamo.pl input.txt | mecab -d /usr/local/lib/mecab/dic/handic
```

あるいはコマンドラインやターミナルで直接入力をする場合：

```bash
$ echo "겨울 방학 때 뭐 했어요?" | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic
```

のように行うことができます．

### トークン化(tokenize)

出力フォーマットを指定する`-O`オプションを用いて，トークン化処理を行うことができます．
出力フォーマットとして`tokenize`を指定します．

```bash
$ echo "뜻을 가진 가장 작은 말의 단위. ‘이야기책’의 ‘이야기’, ‘책’ 따위이다." | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic -O tokenize
뜻 을 가지 ㄴ 가장 작으 ㄴ 말 의 단위 . ‘ 이야기책 ’ 의 ‘ 이야기 ’ , ‘ 책 ’ 따위 이 다 .
```

## 品詞情報

品詞に関する情報は，[品詞情報](docs/pos_detail_ja.md)文書を参照してください．

## Author

  - Yoshinori Sugai(Kindai University)

## Copyrights

Copyright (c) 2011- Yoshinori Sugai. All rights reserved.

''HanDic'' is under [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
