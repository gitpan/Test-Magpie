package Test::Magpie::Spy;
BEGIN {
  $Test::Magpie::Spy::VERSION = '0.04';
}
# ABSTRACT: A look into the invocation history of a mock for verifaciotn
use Moose;
use namespace::autoclean;

use aliased 'Test::Magpie::Invocation';

use List::AllUtils qw( first );
use Moose::Util qw( find_meta );
use Test::Builder;
use Test::Magpie::Util qw( extract_method_name );

with 'Test::Magpie::Role::HasMock';

has 'invocation_counter' => (
    default => sub {
        sub { @_ > 0 }
    },
    is => 'bare',
);

my $tb = Test::Builder->new;

sub BUILDARGS {
    my $self = shift;
    my %args = @_;

    if (defined(my $times = delete $args{times})) {
        $args{invocation_counter} = ref($times) eq 'CODE'
            ? $times
            : sub { @_ == $times };
    }

    return \%args;
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $method = extract_method_name($AUTOLOAD);
    my $observe = Invocation->new(
        method_name => $method,
        arguments => \@_
    );

    my $meta = find_meta($self);
    my $mock = $meta->get_attribute('mock')->get_value($self);
    my $invocations = find_meta($mock)->get_attribute('invocations')
        ->get_value($mock);

    my @matches = grep { $observe->satisfied_by($_) } @$invocations;
    
    my $invocation_counter = $meta->get_attribute('invocation_counter')
        ->get_value($self);

    $tb->ok($invocation_counter->(@matches), 
        sprintf("%s was invoked the correct number of times",
            $observe->as_string));
}

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

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

