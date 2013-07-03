package Test::Magpie::Invocation;
{
  $Test::Magpie::Invocation::VERSION = '0.06';
}
# ABSTRACT: Represents an invocation of a method
use Moose;

with 'Test::Magpie::Role::MethodCall';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Invocation - Represents an invocation of a method

=head1 DESCRIPTION

An invocation of a method on a mock object

=head1 ATTRIBUTES

=head2 arguments

Returns a list of all arguments passed to the method call.

=head2 method_name

The name of the method invoked;

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
