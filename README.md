# HanDic: morphological analysis dictionary for contemporary Korean

[日本語Readme](README_ja.md)

HanDic(한딕)은 형태소 분석 엔진 [MeCab](https://taku910.github.io/mecab/)로 현대 한국어를 분석하기 위한 사전입니다.
12만 개 이상의 사전 항목과 문어를 중심으로 약 14,000개 이상의 [학습용 데이터](docs/source_list.md)로 구축되어 있습니다.

저작권 문제 때문에 학습용 데이터 자체는 배포하지 않지만, 학습용 모델 파일은 패키지에 포함되어 있습니다.

## Requirements

  - MeCab
  - Python or Perl

## Installation

git clone

```Shell
$ git clone https://github.com/okikirmui/handic.git
```

혹은 ZIP파일을 다운로드

seed 디렉토리로 이동

```Shell
$ cd handic/seed/
```

ZIP 파일을 다운받은 경우, 압축을 풀고 seed 디렉토리로 이동

```Shell
$ cd handic-main/seed/
```

Binary 사전 작성

```Shell
$ /usr/local/libexec/mecab/mecab-dict-index -f utf8 -t utf8
```

파라미터 학습용 모델 파일 `model`을 사용하여 배포용 사전을 작성(`/usr/local/lib/mecab/dic/handic`에 설치할 경우)

```Shell
$ /usr/local/libexec/mecab/mecab-dict-gen -o /usr/local/lib/mecab/dic/handic -m model
```

분석용 binary 사전 작성

```Shell
$ cd /usr/local/lib/mecab/dic/handic
$ /usr/local/libexec/mecab/mecab-dict-index -f utf8 -t utf8
```

분석할 때 실제로 필요한 파일은 `char.bin`, `dicrc`, `matrix.bin`, `sys.dic`, `unk.dic`입니다.

## Usage

### 실행시 사전을 지정

MeCab를 실행할 때 `-d` 옵션으로 사전 파일이 포함된 디렉토리를 지정할 수 있습니다.

```Shell
$ mecab -d /usr/local/lib/mecab/dic/handic
```

위 방법으로는 실행할 때마다 사전을 지정할 필요가 있습니다.

### 설정 파일에 사전 경로 기술

홈 디렉토리에 `.mecabrc` 파일을 작성하여 `dicdir`에 HanDic 사전 파일이 포함된 디렉토리 경로를 기술할 수 있습니다.

```text
dicdir = /usr/local/lib/mecab/dic/handic
```

위 방법으로는 항상 HanDic으로 분석하게 됩니다.

### 입력문

HanDic은 UTF-8 인코딩된 텍스트를 입력하여 형태소 분석을 실행합니다.
입력할 때에는 완성형 한글(Hangul Syllables 영역의 문자)가 아니라 초성·중성·종성으로 분리한 첫가끝 코드(조합형, 한글 자모 영역의 문자)로 기술할 필요가 있습니다.
예를 들어 완성형 한글의 '몸'(U+BAB8)은 한글 자모 영역의 글자를 사용하여 'ㅁ'(U+1106), 'ㅗ'(U+1169), 'ㅁ'(U+11B7)으로 나누어서 입력으로 주어야 합니다.

이러한 변환 처리는 임의로 스크립트를 만들어서 처리해도 괜찮습니다.
이 프로젝트에서는 Perl 스크립트 `k2jamo.pl`과 Python 스크립트 `k2jamo.py`를 제공하고 있습니다. `tools` 디렉토리를 참조하십시오.

`k2jamo.pl`로 `input.txt`를 분석할 경우:

```Shell
$ perl k2jamo.pl input.txt | mecab -d /usr/local/lib/mecab/dic/handic
```

혹은 문장을 직접 입력할 경우:

```Shell
$ echo "겨울 방학 때 뭐 했어요?" | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic
```

처럼 처리할 수 있습니다.

### 토큰화 처리(tokenize)

출력 포맷을 지정하는 `-O` 옵션을 사용하여 토큰화 처리를 할 수 있습니다.
출력 포맷으로 `tokenize`를 지정합니다.

```Shell
$ echo "뜻을 가진 가장 작은 말의 단위. ‘이야기책’의 ‘이야기’, ‘책’ 따위이다." | perl k2jamo.pl | mecab -d /usr/local/lib/mecab/dic/handic -O tokenize
뜻 을 가지 ㄴ 가장 작으 ㄴ 말 의 단위 . ‘ 이야기책 ’ 의 ‘ 이야기 ’ , ‘ 책 ’ 따위 이 다 .
```

## 사용법(Python)

[PyPI](https://pypi.org/project/handic/)에서 `handic` 패키지를 공개했습니다.
`mecab-python3` 패키지와 입력문을 변환하기 위한 `jamotools` 등의 패키지와 함께 사용합니다.

설치:

```bash
pip install handic mecab-python3 jamotools
```

예:

```Python
import MeCab
import handic
import jamotools

mecaboption = f'-r /dev/null -d {handic.DICDIR}'

tokenizer = MeCab.Tagger(mecaboption)
tokenizer.parse('')

# 《표준국어대사전》 "형태소" 뜻풀이
sentence = u'뜻을 가진 가장 작은 말의 단위. ‘이야기책’의 ‘이야기’, ‘책’ 따위이다.'

jamo = jamotools.split_syllables(sentence, jamo_type="JAMO")

node = tokenizer.parseToNode(jamo)
while node:
    print(node.surface, node.feature)
    node = node.next
```

## 품사 정보

품사 정보에 관한 정보는 [품사 정보](docs/pos_detail.md) 문서를 참조하시기 바랍니다.

## Author

  - Yoshinori Sugai(Kindai University)

## Copyrights

Copyright (c) 2011- Yoshinori Sugai. All rights reserved.

''HanDic'' is under [BSD-3-Clause](https://opensource.org/licenses/BSD-3-Clause).
