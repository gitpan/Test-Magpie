package Test::Magpie;
BEGIN {
  $Test::Magpie::VERSION = '0.01_01';
}
# ABSTRACT: Spy on objcets to achieve test doubles (mock testing)
use strict;
use warnings;

use aliased 'Test::Magpie::Mock';
use aliased 'Test::Magpie::Spy';
use aliased 'Test::Magpie::When';

use Moose::Util qw( find_meta );

use Sub::Exporter -setup => {
    exports => [qw( mock when verify )]
};

sub verify {
    my $mock = shift;
    return Spy->new(mock => $mock, @_);
}

sub mock {
    return Mock->new;
}

sub when {
    my $mock = shift;
    return When->new(mock => $mock);
}

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie - Spy on objcets to achieve test doubles (mock testing)

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

