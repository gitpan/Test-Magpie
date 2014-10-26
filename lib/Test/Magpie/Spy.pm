package Test::Magpie::Spy;
{
  $Test::Magpie::Spy::VERSION = '0.07';
}
# ABSTRACT: A look into the invocation history of a mock for verifaciotn
use Moose;
use namespace::autoclean;

use aliased 'Test::Magpie::Invocation';

use MooseX::Types::Moose qw( HashRef Str );
use Test::Builder;
use Test::Magpie::Util qw( extract_method_name get_attribute_value );

with 'Test::Magpie::Role::HasMock';

my $TB = Test::Builder->new;

has 'name' => (
    isa => Str,
    is => 'bare',
);

has 'verification' => (
    isa => HashRef,
    is => 'bare',
);

around 'BUILDARGS' => sub {
    my $orig = shift;
    my $self = shift;
    my $args = $self->$orig(@_);

    $args->{verification} = {
        map  { $_ => delete $args->{$_} }
        grep { defined $args->{$_} }
        qw( times at_least at_most between )
    };

    return $args;
};

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $method_name = extract_method_name($AUTOLOAD);

    my $observe = Invocation->new(
        method_name => $method_name,
        arguments   => \@_,
    );

    my $mock         = get_attribute_value($self, 'mock');
    my $invocations  = get_attribute_value($mock, 'invocations');
    my $verification = get_attribute_value($self, 'verification');

    my $matches = grep { $observe->satisfied_by($_) } @$invocations;

    my $name = get_attribute_value($self, 'name') ||
        sprintf("%s was invoked the correct number of times",
            $observe->as_string);

    if (defined $verification->{times}) {
        if (ref $verification->{times} eq 'CODE') {
            # handle use of at_least() and at_most()
            $verification->{times}->( $matches, $name, $TB );
        }
        else {
            $TB->is_num( $matches, $verification->{times}, $name );
        }
    }
    elsif (defined $verification->{at_least}) {
        $TB->cmp_ok( $matches, '>=', $verification->{at_least}, $name );
    }
    elsif (defined $verification->{at_most}) {
        $TB->cmp_ok( $matches, '<=', $verification->{at_most}, $name );
    }
    elsif (defined $verification->{between}) {
        my ($lower, $upper) = @{ $verification->{between} };
        $TB->ok( $lower <= $matches && $matches <= $upper, $name );
    }

    return;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Spy - A look into the invocation history of a mock for verifaciotn

=head1 DESCRIPTION

Spy objects allow you to look inside a mock and verify that certain methods have
been called. You create these objects by using C<verify> from L<Test::Magpie>.

Spy objects do not have a public API as such; they share the same method calls
as the mock object itself. The difference being, a method call now checks that
the method was invoked on the mock at some point in time, and if not, fails a
test.

You may use argument matchers in verification method calls.

=head1 ATTRIBUTES

=head2 name

The name of the test that is printed to screen when the test is executed.

=head2 verification

    times => 1
    at_least => 3
    at_most => 5
    between => [3, 5]

The test to be applied. It is specified as a HashRef that maps the type of test
to the test parameters.

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
