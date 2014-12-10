use strict;
use Test::More;

use_ok $_ for qw(
    Unicode::UTF8::4Byte
);

use Encode qw/encode decode/;

my $str_with_4byte_utf8_char = "a\x{1f600}b\x{1f600}c";
my $str_without_4byte_utf8_char = "a\x{2600}b\x{2600}c";

subtest "encode" => sub {
    is encode('utf8-4byte-escaped', $str_with_4byte_utf8_char), 'a\x{1f600}b\x{1f600}c', "4byte utf8 char is escaped";
    is encode('utf8-4byte-escaped', $str_without_4byte_utf8_char), encode('utf8', $str_without_4byte_utf8_char), "non 4byte chars are not escaped";
};


subtest "decode" => sub {
    my $str = encode('utf8', "\x{2600}") . '\x{1f600}';
    is decode('utf8-4byte-escaped', $str), "\x{2600}\x{1f600}", "escaped char is decoded";
};

subtest "round trip" => sub {
    is decode("utf8-4byte-escaped", encode("utf8-4byte-escaped", $str_without_4byte_utf8_char)), $str_without_4byte_utf8_char;
    is decode("utf8-4byte-escaped", encode("utf8-4byte-escaped", $str_without_4byte_utf8_char)), $str_without_4byte_utf8_char;
};

subtest "out or range code point not unescaped" => sub {
    my @invalid_letters = qw/
        \x{00000000000000000000000000000000000000000}
        \x{99999999999999999999999999999999999999999}
    /;
    for my $letter (@invalid_letters) {
        is decode("utf8-4byte-escaped", $letter), $letter, $letter;
    }
};

subtest 'invalid code point' => sub {
    is decode("utf8-4byte-escaped", '\x{d83f}'), "\x{d83f}";
    is decode("utf8-4byte-escaped", '\x{ffffffff}'), "\x{ffffffff}";
};
done_testing;

