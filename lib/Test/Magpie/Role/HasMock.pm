package Test::Magpie::Role::HasMock;
BEGIN {
  $Test::Magpie::Role::HasMock::VERSION = '0.01_01';
}
use Moose::Role;
use namespace::autoclean;

has 'mock' => (
    is => 'bare',
    required => 1
);

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Role::HasMock

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

