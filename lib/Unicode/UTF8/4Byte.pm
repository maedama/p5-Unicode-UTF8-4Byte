package Unicode::UTF8::4Byte;
use 5.008005;
use strict;
use warnings;
use base 'Encode::Encoding';
use Encode ();
$Encode::Encoding{"utf8-4byte-escaped"} = bless { Name => "utf8-4byte-escaped" }, __PACKAGE__;
our $VERSION = "0.01";

sub encode($$;$) {
    my ($self, $str, $check) = @_;
    $str = escape_4byte_utf8_chars($str);
    Encode::encode('utf8', $str);
}

sub decode($$;$) {
    my ($self, $str, $check) = @_;
    $str = Encode::decode('utf8', $str);
    unescape_4byte_utf8_chars($str);
}

sub escape_4byte_utf8_chars {
    my $str = shift;
    $str =~ s/[\x{10000}-\x{3ffff}\x{40000}-\x{fffff}\x{100000}-\x{10ffff}]/
        sprintf('\x{%x}', ord($&));
    /ge;
    return $str;
}

sub unescape_4byte_utf8_chars {
    my $str = shift;
    $str =~ s/\\x\{([A-Fa-f0-9]+)\}/
        my $hex = $1;

        if (length($hex) <= 8 ) { # 32bits
            chr(hex($1))
        }
        else {
            $&
        }
    /ge;
    return $str;
}



1;
__END__

=encoding utf-8

=head1 NAME

Unicode::UTF8::4Byte - It's new $module

=head1 SYNOPSIS

    use Unicode::UTF8::4Byte;

=head1 DESCRIPTION

Unicode::UTF8::4Byte is ...

=head1 LICENSE

Copyright (C) maedama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

maedama E<lt>maedama85@gmail.comE<gt>

=cut

