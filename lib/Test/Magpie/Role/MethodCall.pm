package Test::Magpie::Role::MethodCall;
BEGIN {
  $Test::Magpie::Role::MethodCall::VERSION = '0.01';
}
# ABSTRACT: A role that represents a method call
use Moose::Role;
use namespace::autoclean;

use aliased 'Test::Magpie::ArgumentMatcher';

use MooseX::Types::Moose qw( ArrayRef Str );
use Devel::PartialDump;

has 'method_name' => (
    isa => Str,
    is => 'ro',
    required => 1
);

has 'arguments' => (
    traits => [ 'Array' ],
    isa => ArrayRef,
    default => sub { [] },
    handles => {
        arguments => 'elements'
    }
);

sub as_string {
    my $self = shift;
    return $self->method_name .
        '(' . Devel::PartialDump->new->dump($self->arguments) . ')';
}

sub satisfied_by {
    my ($self, $invocation) = @_;
    return unless $invocation->method_name eq $self->method_name;
    my @input = $invocation->arguments;
    my @expected = $self->arguments;
    my $valid = 1;
    while($valid && @input && @expected) {
        my $matcher = shift(@expected);
        if (ref($matcher) eq ArgumentMatcher) {
            ($valid, @input) = $matcher->match(@input);
        }
        else {
            my $value = shift(@input);
            $valid = $value ~~ $matcher;
        }
    }
    return $valid == 1 && @input == 0 && @expected == 0;
}

1;


__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Role::MethodCall - A role that represents a method call

=head1 ATTRIBUTES

=head2 arguments

An array reference of arguments, or argument matchers.

=head2 method_name

The name of the method.

=head1 METHODS

=head2 as_string

Stringifies this method call to something that roughly resembles what you'd type
in Perl.

=head2 satisfied_by (MethodCall $invocation)

Returns true if the given $invocation would satisfy this method call. Note that
while the $invocation could have arguments matchers in C<arguments>, they will
be passed into this method calls argument matcher. Which basically means, it
probably won't work.

=head1 INTERNAL

This class is internal and not meant for use outside Magpie.

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

