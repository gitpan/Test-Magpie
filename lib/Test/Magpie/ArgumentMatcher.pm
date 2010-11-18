package Test::Magpie::ArgumentMatcher;
BEGIN {
  $Test::Magpie::ArgumentMatcher::VERSION = '0.02';
}
# ABSTRACT: Various templates to catch arguments

use strict;
use warnings;

use Test::Magpie::Util match => { -as => '_match' };
use Set::Object qw( set );

use Sub::Exporter -setup => {
    exports => [
        qw( anything hash custom_matcher ),
        set => sub { \&_set }
    ],
};

sub anything {
    bless sub { return () }, __PACKAGE__;
}

sub hash {
    my (%template) = @_;
    bless sub {
        my %hash = @_;
        for (keys %template) {
            if (my $v = delete $hash{$_}) {
                return unless _match($v, $template{$_});
            }
            else {
                return;
            }
        }
        return %hash;
    }, __PACKAGE__;
}

sub _set {
    my ($take) = set(@_);
    bless sub {
        return set(@_) == $take ? () : undef;
    }, __PACKAGE__;
}

sub match {
    my ($self, @input) = @_;
    return $self->(@input);
}

sub custom_matcher {
    my $test = shift;
    bless sub {
        $test->(@_) ? () : undef
    }, __PACKAGE__;
}

1;


__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::ArgumentMatcher - Various templates to catch arguments

=head1 SYNOPSIS

    use Test::Magpie::ArgumentMatcher qw( anything );
    use Test::Magpie qw( mock verify );

    my $mock = mock;
    $mock->push( button => 'red' );

    verify($mock)->push(anything);

=head1 DESCRIPTION

Argument matchers allow you to be more general in your specification to stubs
and verification. An argument matcher is an object that takes all remaining
paremeters of an invocation, consumes 1 or more, and returns the remaining
arguments back. At verification time, a invocation is verified if all arguments
have been consumed by all argument matchers.

An argument matcher may return C<undef> if the argument does not pass
validation.

=head2 Custom argument validators

An argument validator is just a subroutine that is blessed as
C<Test::Magpie::ArgumentMatcher>. You are welcome to subclass this package if
you wish to use a different storage system (like a traditional hash-reference),
though a single sub routine is normally all you will need.

=head2 Default argument matchers

This module provides a set of common argument matchers, and will probably handle
most of your needs. They are all available for import by name.

=head1 METHODS

=head2 match @in

Match an argument matcher against @in, and return a list of parameters still to
be consumed, or undef on validation.

=head1 FUNCTIONS

=head2 anything

Consumes all remaining arguments (even 0) and returns none. This effectively
slurps in any remaining arguments and considers them valid. Note, as this
consumes I<all> arguments, you cannot use further argument validators after this
one. You are, however, welcome to use them before.

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

