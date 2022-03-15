#!/usr/bin/perl

use utf8;
use open ':utf8';
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");
#open(IN, shift(@ARGV));

@initial = ("ᄀ", "ᄁ", "ᄂ", "ᄃ", "ᄄ", "ᄅ", "ᄆ", "ᄇ", "ᄈ", "ᄉ", "ᄊ", "ᄋ",
			"ᄌ", "ᄍ", "ᄎ", "ᄏ", "ᄐ", "ᄑ", "ᄒ");
@medial = ("ᅡ", "ᅢ", "ᅣ", "ᅤ", "ᅥ", "ᅦ", "ᅧ", "ᅨ", "ᅩ", "ᅪ", "ᅫ", "ᅬ",
		   "ᅭ", "ᅮ", "ᅯ", "ᅰ", "ᅱ", "ᅲ", "ᅳ", "ᅴ", "ᅵ", "");
@final = ("", "ᆨ", "ᆩ", "ᆪ", "ᆫ", "ᆬ", "ᆭ", "ᆮ", "ᆯ", "ᆰ", "ᆱ", "ᆲ",
		  "ᆳ", "ᆴ", "ᆵ", "ᆶ", "ᆷ", "ᆸ", "ᆹ", "ᆺ", "ᆻ", "ᆼ", "ᆽ", "ᆾ",
		  "ᆿ", "ᇀ", "ᇁ", "ᇂ");

while(<>) {
	chomp;
	#s/[\x{AC00}-\x{D7A3}]/int(unpack("U*",$&))/ge;
	s/[\x{AC00}-\x{D7A3}]/convert_main($&)/ge;
	print "$_\n";
}
#close IN;

sub convert_main {
  my $char = shift(@_);
  my $int = int(unpack("U*", $char));
  $int = $int - 44032;
  $init_ind = int($int/588);
  $final_ind = $int % 28;
  $med_ind = int(($int - ($init_ind * 588) - $final_ind) / 28);
  $char = $initial[$init_ind] . $medial[$med_ind] . $final[$final_ind];
  return $char;
}

