package Test::Magpie::Invocation;
{
  $Test::Magpie::Invocation::VERSION = '0.10';
}
# ABSTRACT: Represents an invocation of a method

use Moose;
use namespace::autoclean;

with 'Test::Magpie::Role::MethodCall';

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Test::Magpie::Invocation - Represents an invocation of a method

=head1 VERSION

version 0.10

=head1 DESCRIPTION

An invocation of a method on a mock object

=head1 ATTRIBUTES

=head2 name

Returns the name of the method invoked.

=head2 args

Returns a list of all arguments passed to the method call.

=head1 AUTHORS

=over 4

=item *

Oliver Charles <oliver.g.charles@googlemail.com>

=item *

Steven Lee <stevenwh.lee@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Oliver Charles.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
