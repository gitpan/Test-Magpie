package Test::Magpie::Util;
BEGIN {
  $Test::Magpie::Util::VERSION = '0.05';
}
# ABSTRACT: Utilities used by Test::Magpie
use strict;
use warnings;

use aliased 'Test::Magpie::ArgumentMatcher';
use Scalar::Util qw( blessed );

use Sub::Exporter -setup => {
    exports => [qw( extract_method_name match )],
};

sub extract_method_name {
    my $name = shift;
    my ($method) = $name =~ qr/:([^:]+)$/;
    return $method;
}

sub match {
    my ($a, $b) = @_;
    return blessed($a)
        ? (ref($a) eq ref($b) && $a == $b)
        : $a ~~ $b;
}

1;



__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Util - Utilities used by Test::Magpie

=head1 FUNCTIONS

=head2 extract_method_name

Internal. From a fully qualified method name such as Foo::Bar::baz, will return
just the method name (in this example, baz).

=head2 match

Internal. Match 2 values for equality

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

