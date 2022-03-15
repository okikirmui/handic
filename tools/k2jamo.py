#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys, re, fileinput

initial = ["ᄀ", "ᄁ", "ᄂ", "ᄃ", "ᄄ", "ᄅ", "ᄆ", "ᄇ", "ᄈ", "ᄉ", "ᄊ", "ᄋ",
			"ᄌ", "ᄍ", "ᄎ", "ᄏ", "ᄐ", "ᄑ", "ᄒ"]
medial = ["ᅡ", "ᅢ", "ᅣ", "ᅤ", "ᅥ", "ᅦ", "ᅧ", "ᅨ", "ᅩ", "ᅪ", "ᅫ", "ᅬ",
		   "ᅭ", "ᅮ", "ᅯ", "ᅰ", "ᅱ", "ᅲ", "ᅳ", "ᅴ", "ᅵ", ""]
final = ["", "ᆨ", "ᆩ", "ᆪ", "ᆫ", "ᆬ", "ᆭ", "ᆮ", "ᆯ", "ᆰ", "ᆱ", "ᆲ",
		  "ᆳ", "ᆴ", "ᆵ", "ᆶ", "ᆷ", "ᆸ", "ᆹ", "ᆺ", "ᆻ", "ᆼ", "ᆽ", "ᆾ",
		  "ᆿ", "ᇀ", "ᇁ", "ᇂ"]

regex = u'[가-힣]'
pattern = re.compile(regex)

def convert_main(match):
	value = ord(match.group(0))
	my_int = value - 44032
	my_int_index = int(my_int / 588)
	my_final_index = my_int % 28
	my_medial_index = int((my_int - (my_int_index * 588) - my_final_index) / 28)
	result = initial[my_int_index] + medial[my_medial_index] + final[my_final_index]
	return result

for line in fileinput.input():
	print(re.sub(pattern, convert_main, line), end='')
fileinput.close()
