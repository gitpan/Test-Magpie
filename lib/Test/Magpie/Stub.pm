package Test::Magpie::Stub;
BEGIN {
  $Test::Magpie::Stub::VERSION = '0.01';
}
# ABSTRACT: The declaration of a stubbed method
use Moose;

use List::AllUtils qw( all pairwise );
use MooseX::Types::Moose qw( ArrayRef );
use Scalar::Util qw( blessed );

with 'Test::Magpie::Role::MethodCall';

has 'executions' => (
    isa => ArrayRef,
    traits => [ 'Array' ],
    default => sub { [] },
    handles => {
        _store_execution => 'push',
        _next_execution => 'shift'
    }
);

sub execute {
    my $self = shift;
    return $self->_next_execution->();
}

sub then_return {
    my $self = shift;
    my $ret = shift;
    $self->_store_execution(sub {
        return $ret;
    });
    return $self;
}

sub then_die {
    my $self = shift;
    my $exception = shift;
    $self->_store_execution(sub {
        if (blessed($exception) && $exception->can('throw')) {
            $exception->throw;
        }
        else {
            die $exception;
        }
    });
    return $self;
}

1;



__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Stub - The declaration of a stubbed method

=head1 DESCRIPTION

Represents a stub method - a method that may have some sort of action when
called. Stub methods are created by invoking the method name (with a set of
possible argument matchers/arguments) on the object returned by C<when> in
L<Test::Magpie>.

Stub methods have a stack of executions. Every time the stub method is called
(matching arguments), the next execution is taken from the front of the queue
and called. As stubs are matched via arguments, you may have multiple stubs for
the same method name.

=head1 ATTRIBUTES

=head2 executions

An array reference queue of all stub executions. Internal.

=head1 METHODS

=head2 then_return $return_value

Pushes a stub method that will return $return_value to the end of the execution
queue.

=head2 then_die $exception

Pushes a stub method that will throw C<$exception> when called to the end of the
execution stack.

=head2 execute

Internal. Will execute the next execution, if possible

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

