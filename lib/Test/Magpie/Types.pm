package Test::Magpie::Types;
BEGIN {
  $Test::Magpie::Types::VERSION = '0.02';
}
use MooseX::Types -declare => [qw( Mock )];

class_type Mock, { class => 'Test::Magpie::Mock' };

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Types

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

