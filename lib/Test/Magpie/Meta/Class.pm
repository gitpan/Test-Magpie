package Test::Magpie::Meta::Class;
BEGIN {
  $Test::Magpie::Meta::Class::VERSION = '0.03';
}
# ABSTRACT: Metaclass for mocks
use Moose;
use namespace::autoclean;

extends 'Moose::Meta::Class';

override 'does_role' => sub { 1 };

1;



__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Meta::Class - Metaclass for mocks

=head1 DESCRIPTION

A metaclass that pretends that all instances consume every role.

=head1 INTERNAL

This metaclass is internal and not meant for use outside Magpie

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

