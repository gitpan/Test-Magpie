package Test::Magpie::Util;
BEGIN {
  $Test::Magpie::Util::VERSION = '0.01_01';
}
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw( extract_method_name )],
};

sub extract_method_name {
    my $name = shift;
    my ($method) = $name =~ qr/:([^:]+)$/;
    return $method;
}

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Util

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

